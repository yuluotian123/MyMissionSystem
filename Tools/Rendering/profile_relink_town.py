"""RenderDoc 1.46 replay GPU counters; run with qrenderdoc --python.
RELINK_TOWN_RDC and RELINK_TOWN_PROFILE_OUTPUT select capture and JSON report.
Counter timings are replay measurements, not live game frame rate.
"""
import json, os, statistics, sys, traceback
import renderdoc as rd

path=os.environ['RELINK_TOWN_RDC']
output=os.environ['RELINK_TOWN_PROFILE_OUTPUT']
capture=rd.OpenCaptureFile()
controller=None
result={'capture':os.path.basename(path),'state':'opening'}
try:
    status=capture.OpenFile(path,'',None)
    if status != rd.ResultCode.Succeeded: raise RuntimeError(str(status))
    status,controller=capture.OpenCapture(rd.ReplayOptions(),None)
    if status != rd.ResultCode.Succeeded: raise RuntimeError(str(status))
    structured=controller.GetStructuredFile()
    labels={}
    action_lookup={}
    def visit(actions,parents):
        for action in actions:
            name=action.GetName(structured)
            labels[action.eventId]=parents+[name]
            action_lookup[action.eventId]=action
            visit(action.children,parents+[name])
    visit(controller.GetRootActions(),[])
    textures={str(t.resourceId):t for t in controller.GetTextures()}
    def classify(event):
        names=labels.get(event,[])
        action=action_lookup.get(event)
        # Unity's native renderer draws can be outside CommandBuffer marker regions.
        if action:
            depth=textures.get(str(action.depthOut))
            if depth and depth.arraysize in (3,16) and depth.format.Name() in ('D16_UNORM','R16_TYPELESS'):
                return 'Relink / three D16 sun layers' if depth.arraysize==3 else 'Relink / local shadow faces'
            outputs=[textures[str(r)] for r in action.outputs if str(r) in textures]
            if len(outputs)>=4 and any('R10G10B10A2' in t.format.Name() for t in outputs):
                return 'Relink / four GBuffer MRTs'
        return next((name for name in names if 'Relink / ' in name),'Unlabelled / copies / clears')
    counter=rd.GPUCounter.EventGPUDuration
    if counter not in controller.EnumerateCounters(): raise RuntimeError('EventGPUDuration unavailable')
    samples=[]
    for iteration in range(7):
        timings=controller.FetchCounters([counter])
        stages={}
        total=0
        for timing in timings:
            milliseconds=timing.value.d*1000
            if milliseconds<0: continue
            total+=milliseconds
            label=classify(timing.eventId)
            stages[label]=stages.get(label,0)+milliseconds
        if iteration>0: samples.append({'total_ms':total,'stages_ms':stages})
    result.update(state='complete',api=str(controller.GetAPIProperties().pipelineType),
        gpu_event_sum_median_ms=statistics.median(s['total_ms'] for s in samples),
        stages_median_ms={name:statistics.median(s['stages_ms'].get(name,0) for s in samples) for name in sorted(set(n for s in samples for n in s['stages_ms']))},
        samples=samples,method='Six warmed replay samples of EventGPUDuration; sums include draw/dispatch/copy/clear events, exclude CPU and presentation.')
    result['actions']=[{'event':a.eventId,'name':a.GetName(structured),'group':classify(a.eventId),'outputs':[str(r) for r in a.outputs if str(r) in textures],'depth':str(a.depthOut)} for a in action_lookup.values() if a.flags & (rd.ActionFlags.Drawcall|rd.ActionFlags.Dispatch)]
    result['textures']=[{'id':str(t.resourceId),'width':t.width,'height':t.height,'layers':t.arraysize,'mips':t.mips,'format':t.format.Name(),'bytes':t.byteSize} for t in textures.values()]
except Exception:
    result.update(state='failed',error=traceback.format_exc())
finally:
    os.makedirs(os.path.dirname(output),exist_ok=True)
    with open(output,'w',encoding='utf8') as f: json.dump(result,f,indent=2,ensure_ascii=False)
    if controller: controller.Shutdown()
    capture.Shutdown()
sys.exit(0 if result['state']=='complete' else 1)
