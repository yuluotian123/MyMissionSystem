"""Read-only source-game pixel traces at the verified directional event 20304.
Run with RenderDoc 1.46 qrenderdoc --python. RELINK_RDC and RELINK_DEBUG_OUTPUT
select capture/report. Event/register mapping is specific to frame10803's shader.
"""
import os,json,math,sys,traceback
import renderdoc as rd

path=os.environ['RELINK_RDC']
output=os.environ['RELINK_DEBUG_OUTPUT']
cap=rd.OpenCaptureFile();controller=None
report={'capture':os.path.basename(path),'event':20304,'state':'opening','pixels':[]}
def variable(v):
    values=[float(x) for x in v.value.f32v[:max(1,v.rows*v.columns)]]
    return {'name':v.name,'type':str(v.type),'floats':[x if math.isfinite(x) else None for x in values],
            'uints':list(v.value.u32v[:max(1,v.rows*v.columns)]),'members':[variable(m) for m in v.members]}
try:
    if cap.OpenFile(path,'',None)!=rd.ResultCode.Succeeded:raise RuntimeError('Capture open failed')
    status,controller=cap.OpenCapture(rd.ReplayOptions(),None)
    if status!=rd.ResultCode.Succeeded:raise RuntimeError(str(status))
    controller.SetFrameEvent(20304,True)
    texture=next(t for t in controller.GetTextures() if str(t.resourceId)=='ResourceId::4379')
    mask=controller.GetTextureData(texture.resourceId,rd.Subresource())
    candidates=[]
    for y in range(32,texture.height-32,17):
        for x in range(32,texture.width-32,17):
            offset=(y*texture.width+x)*4
            if mask[offset]>25:candidates.append((mask[offset],x,y))
    candidates.sort(reverse=True)
    coords=[(1200,1100),(1900,650),(1650,1150),(800,700)]
    for value,x,y in candidates:
        if all(abs(x-a)+abs(y-b)>100 for a,b in coords):coords.append((x,y))
        if len(coords)>=8:break
    report['metal_candidates']=len(candidates)
    for x,y in coords:
        trace=controller.DebugPixel(x,y,rd.DebugPixelInputs())
        try:
            if not trace or not trace.debugger:raise RuntimeError('No shader debugger for pixel')
            record={'x':x,'y':y,'inputs':[variable(v) for v in trace.inputs],
                    'constants':[variable(v) for v in trace.constantBlocks],'steps':[]}
            registers={}
            for chunk in range(1000):
                states=controller.ContinueDebug(trace.debugger)
                if not states:break
                for state in states:
                    changes=[variable(c.after) for c in state.changes]
                    for v in changes:registers[v['name']]=v
                    record['steps'].append({'next_instruction':state.nextInstruction,'changes':changes})
            else:raise RuntimeError('Debugger did not finish')
            record['final_registers']=registers
            report['pixels'].append(record)
        finally:
            if trace:controller.FreeTrace(trace)
    report['state']='complete'
except Exception:report.update(state='failed',error=traceback.format_exc())
finally:
    os.makedirs(os.path.dirname(output),exist_ok=True)
    with open(output,'w',encoding='utf8') as f:json.dump(report,f,ensure_ascii=False,indent=2)
    if controller:controller.Shutdown()
    cap.Shutdown()
sys.exit(0 if report['state']=='complete' else 1)
