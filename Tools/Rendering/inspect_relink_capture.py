"""Offline RenderDoc inspection; run with qrenderdoc.exe --python this_file.py.

RELINK_RDC: capture path. RELINK_ANALYSIS_OUTPUT: output directory.
RELINK_INSPECT_EVENTS: optional comma-separated event IDs for detailed replay.
RELINK_SNAPSHOT=0 disables intermediate PNG exports (faster).
RELINK_SNAPSHOT_EVENTS: optional comma-separated subset to export.
RELINK_FINAL_EVENT: optional explicit final-color draw (history writes may follow it).
Inventory does not assign semantic names to passes; those require manual review.
"""
import collections
import json
import os
import sys
import traceback
import renderdoc as rd

capture_path = os.environ.get("RELINK_RDC", os.path.abspath("Captures/Relink/relink_frame18802.rdc"))
output = os.environ.get("RELINK_ANALYSIS_OUTPUT", os.path.abspath("Temp/RelinkAnalysis"))
os.makedirs(output, exist_ok=True)
capture = None
controller = None
status = {"state": "opening", "capture": capture_path}


def write_json(name, data):
    temporary = os.path.join(output, name + ".tmp")
    with open(temporary, "w", encoding="utf-8") as stream:
        json.dump(data, stream, ensure_ascii=False, indent=2)
    os.replace(temporary, os.path.join(output, name))


def rid(value):
    return str(value)


def texture_info(texture):
    return dict(id=rid(texture.resourceId), width=texture.width, height=texture.height,
                depth=texture.depth, array_size=texture.arraysize, mips=texture.mips,
                samples=texture.msSamp, format=texture.format.Name(),
                flags=str(texture.creationFlags), type=str(texture.type))


def descriptor_info(used):
    d = used.descriptor
    a = used.access
    return dict(resource=rid(d.resource), byte_offset=d.byteOffset, byte_size=d.byteSize,
                first_mip=d.firstMip, first_slice=d.firstSlice,
                view_format=d.format.Name(),
                reflection_index=a.index, descriptor_type=str(a.type))


def variable_info(variable):
    return dict(name=variable.name, rows=variable.rows, columns=variable.columns,
                type=str(variable.type), floats=list(variable.value.f32v),
                members=[variable_info(v) for v in variable.members])


def inspect_event(event):
    controller.SetFrameEvent(event, True)
    pipe = controller.GetPipelineState()
    viewport = pipe.GetViewport(0)
    action = next(a for a in actions if a["event"] == event)
    compute = "Dispatch" in action["flags"]
    data = dict(event=event, action=action["name"], flags=action["flags"],
                outputs=[rid(d.resource) for d in pipe.GetOutputTargets()],
                output_views=[dict(resource=rid(d.resource), format=d.format.Name(),
                                   first_slice=d.firstSlice) for d in pipe.GetOutputTargets()],
                depth=rid(pipe.GetDepthTarget().resource),
                depth_view=dict(format=pipe.GetDepthTarget().format.Name(),
                                first_slice=pipe.GetDepthTarget().firstSlice),
                viewport=dict(x=viewport.x, y=viewport.y, width=viewport.width, height=viewport.height),
                stages={})
    for stage in ((rd.ShaderStage.Compute,) if compute else (rd.ShaderStage.Vertex, rd.ShaderStage.Pixel)):
        reflection = pipe.GetShaderReflection(stage)
        if reflection is None:
            continue
        entry = pipe.GetShaderEntryPoint(stage)
        shader = pipe.GetShader(stage)
        detail = dict(shader=rid(shader), entry=entry,
                      read_only=[descriptor_info(d) for d in pipe.GetReadOnlyResources(stage, True)],
                      read_write=[descriptor_info(d) for d in pipe.GetReadWriteResources(stage, True)],
                      input_signature=[dict(name=s.varName, semantic=s.semanticName,
                                            index=s.semanticIndex, register=s.regIndex,
                                            components=s.compCount) for s in reflection.inputSignature],
                      output_signature=[dict(name=s.varName, semantic=s.semanticName,
                                             index=s.semanticIndex, register=s.regIndex,
                                             components=s.compCount) for s in reflection.outputSignature],
                      constant_blocks=[])
        for key, reflected in (("read_only", reflection.readOnlyResources),
                               ("read_write", reflection.readWriteResources)):
            for descriptor in detail[key]:
                index = descriptor["reflection_index"]
                if index < len(reflected):
                    descriptor["name"] = reflected[index].name
                    descriptor["bind"] = reflected[index].fixedBindNumber
        for index, block in enumerate(reflection.constantBlocks):
            bound = pipe.GetConstantBlock(stage, index, 0).descriptor
            item = dict(name=block.name, byte_size=block.byteSize, buffer=rid(bound.resource),
                        bind=block.fixedBindNumber)
            try:
                variables = controller.GetCBufferVariableContents(pipe.GetGraphicsPipelineObject(), shader,
                    stage, entry, index, bound.resource, bound.byteOffset, bound.byteSize)
                item["variables"] = [variable_info(v) for v in variables]
            except Exception as error:
                item["error"] = str(error)
            detail["constant_blocks"].append(item)
        disassembly = controller.DisassembleShader(pipe.GetGraphicsPipelineObject(), reflection, "")
        name = "event_{}_{}.asm".format(event, str(stage))
        with open(os.path.join(output, name), "w", encoding="utf-8") as stream:
            stream.write(disassembly)
        detail["disassembly_file"] = name
        data["stages"][str(stage)] = detail
    # D3D11-specific state exposes exact depth and blend operations for this capture.
    if not compute and controller.GetAPIProperties().pipelineType == rd.GraphicsAPI.D3D11:
        d3d = controller.GetD3D11PipelineState()
        data["depth_state"] = {key: str(getattr(d3d.outputMerger.depthStencilState, key))
                               for key in ("depthEnable", "depthWrites", "depthFunction", "stencilEnable")}
        data["blends"] = [dict(enabled=b.enabled, source=str(b.colorBlend.source),
                               destination=str(b.colorBlend.destination), operation=str(b.colorBlend.operation),
                               write_mask=b.writeMask) for b in d3d.outputMerger.blendState.blends]
    return data


def save_texture(resource, path, channel=-1):
    config = rd.TextureSave()
    config.resourceId = resource
    config.destType = rd.FileType.PNG
    config.mip = 0
    config.slice.sliceIndex = 0
    config.channelExtract = channel
    result = controller.SaveTexture(config, os.path.join(output, path))
    if result.code != rd.ResultCode.Succeeded:
        raise RuntimeError("Texture export failed for {}: {}".format(path, result))
    return str(result)


try:
    write_json("analysis_status.json", status)
    capture = rd.OpenCaptureFile()
    result = capture.OpenFile(capture_path, "", None)
    if result.code != rd.ResultCode.Succeeded:
        raise RuntimeError(str(result))
    thumbnail = capture.GetThumbnail(rd.FileType.PNG, 0)
    if thumbnail.data:
        with open(os.path.join(output, "capture_thumbnail.png"), "wb") as stream:
            stream.write(thumbnail.data)
    result, controller = capture.OpenCapture(rd.ReplayOptions(), None)
    if result.code != rd.ResultCode.Succeeded:
        raise RuntimeError(str(result))
    structured = controller.GetStructuredFile()
    textures = [texture_info(t) for t in controller.GetTextures()]
    resources = {rid(r.resourceId): r.name for r in controller.GetResources()}
    actions = []

    def flatten(items, parents):
        for action in items:
            name = action.GetName(structured)
            actions.append(dict(event=action.eventId, name=name, parents=parents,
                                flags=str(action.flags), indices=action.numIndices,
                                instances=action.numInstances, dispatch=list(action.dispatchDimension),
                                outputs=[rid(r) for r in action.outputs if r != rd.ResourceId.Null()],
                                depth=rid(action.depthOut), copy_destination=rid(action.copyDestination)))
            flatten(action.children, parents + [name])

    flatten(controller.GetRootActions(), [])
    draws = [a for a in actions if "Drawcall" in a["flags"]]
    groups = []
    for draw in draws:
        key = (tuple(draw["outputs"]), draw["depth"])
        if not groups or groups[-1]["key"] != key:
            groups.append(dict(key=key, start=draw["event"], end=draw["event"], draws=0, examples=[]))
        group = groups[-1]
        group["end"] = draw["event"]
        group["draws"] += 1
        if len(group["examples"]) < 4:
            group["examples"].append(draw["event"])
    inventory = dict(capture=os.path.basename(capture_path), bytes=os.path.getsize(capture_path),
                     api=str(controller.GetAPIProperties().pipelineType),
                     action_count=len(actions), draw_count=len(draws),
                     dispatch_count=sum("Dispatch" in a["flags"] for a in actions),
                     textures=textures, resources=resources, actions=actions, target_groups=groups)
    write_json("inventory.json", inventory)
    requested = os.environ.get("RELINK_INSPECT_EVENTS", "")
    details = []
    snapshot_events = {int(e) for e in os.environ.get("RELINK_SNAPSHOT_EVENTS", "").split(",") if e}
    if requested:
        for event in map(int, requested.split(",")):
            details.append(inspect_event(event))
            write_json("events.json", details)
            # Snapshot every non-null render target at this event, plus compute outputs.
            pipe = controller.GetPipelineState()
            if os.environ.get("RELINK_SNAPSHOT", "1") == "0":
                continue
            if snapshot_events and event not in snapshot_events:
                continue
            pipe = controller.GetPipelineState()
            is_compute = "Dispatch" in details[-1]["flags"]
            targets = ([d.descriptor.resource for d in pipe.GetReadWriteResources(rd.ShaderStage.Compute, True)]
                       if is_compute else [d.resource for d in pipe.GetOutputTargets()])
            texture_ids = {t["id"] for t in textures}
            for index, resource in enumerate(targets):
                if rid(resource) in texture_ids:
                    save_texture(resource, "event_{}_target_{}.png".format(event, index))
            depth = pipe.GetDepthTarget().resource
            if not is_compute and rid(depth) in texture_ids:
                save_texture(depth, "event_{}_depth.png".format(event), 0)
    if draws:
        final_event = int(os.environ.get("RELINK_FINAL_EVENT", draws[-1]["event"]))
        selected = next(a for a in draws if a["event"] == final_event)
        controller.SetFrameEvent(final_event, True)
        last_output = selected["outputs"][0]
        resource = next(t.resourceId for t in controller.GetTextures() if rid(t.resourceId) == last_output)
        save_texture(resource, "final.png")
        status.update(final_color_event=final_event, final_color_resource=last_output)
    write_json("replay_messages.json", [dict(event=m.eventId, severity=str(m.severity),
               category=str(m.category), description=m.description) for m in controller.GetDebugMessages()])
    summaries = []
    for event in details:
        summary = {key: value for key, value in event.items() if key != "stages"}
        summary["stages"] = {}
        for stage, data in event["stages"].items():
            summary["stages"][stage] = {key: value for key, value in data.items() if key != "constant_blocks"}
            summary["stages"][stage]["constant_blocks"] = [dict(name=b["name"], bind=b["bind"],
                byte_size=b["byte_size"], variables=[v["name"] for v in b.get("variables", [])])
                for b in data["constant_blocks"]]
        summaries.append(summary)
    write_json("events_summary.json", summaries)
    status.update(state="complete", draw_count=len(draws), target_groups=len(groups), inspected=len(details))
except Exception:
    status.update(state="failed", error=traceback.format_exc())
finally:
    write_json("analysis_status.json", status)
    if controller is not None:
        controller.Shutdown()
    if capture is not None:
        capture.Shutdown()
sys.exit(0 if status["state"] == "complete" else 1)
