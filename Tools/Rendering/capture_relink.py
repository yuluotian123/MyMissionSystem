"""Run with qrenderdoc.exe --python capture_relink.py.

Connects to an already injected game. Does not launch a game or change game settings.
RELINK_TARGET defaults to RenderDoc's first local target port, 38920.
RELINK_CAPTURE_MODE=probe only queries the connection; capture requests one frame.
RELINK_CAPTURE_OUTPUT must point to a writable output directory.
"""
import json
import os
import sys
import time
import traceback
import renderdoc as rd

output = os.environ.get("RELINK_CAPTURE_OUTPUT", os.path.abspath("Captures/Relink"))
os.makedirs(output, exist_ok=True)
status_path = os.path.join(output, "capture_status.json")
status = {"state": "connecting"}
target = None


def write_status():
    with open(status_path + ".tmp", "w", encoding="utf-8") as stream:
        json.dump(status, stream, indent=2)
    os.replace(status_path + ".tmp", status_path)


try:
    target = rd.CreateTargetControl("", int(os.environ.get("RELINK_TARGET", "38920")), "Relink rendering research", False)
    if target is None or not target.Connected():
        raise RuntimeError("No injected game on the selected target port. Launch with renderdoccmd capture first.")
    status.update(target=target.GetTarget(), pid=target.GetPID(), state="connected")
    if "granblue_fantasy_relink" not in status["target"].lower():
        raise RuntimeError("Connected target is not Relink; select the correct target port.")
    # Reconnecting sends notifications for existing captures. Drain them before
    # requesting a new frame, then also reject late historical notifications.
    known_captures = set()
    initial_deadline = time.monotonic() + 10
    idle_messages = 0
    while target.Connected() and time.monotonic() < initial_deadline and (
            idle_messages < 2 or not target.GetAPI()):
        message = target.ReceiveMessage(None)
        if message.type == rd.TargetControlMessageType.NewCapture:
            known_captures.add(message.newCapture.captureId)
        idle_messages = idle_messages + 1 if message.type in (
            rd.TargetControlMessageType.Noop, rd.TargetControlMessageType.Unknown) else 0
    status["existing_capture_ids"] = sorted(known_captures)
    status["api"] = target.GetAPI()
    write_status()
    if os.environ.get("RELINK_CAPTURE_MODE", "capture") != "probe":
        requested_at = int(time.time())
        status["requested_at"] = requested_at
        target.TriggerCapture(1)
        status["state"] = "capturing"
        write_status()
        deadline = time.monotonic() + 90
        while target.Connected() and time.monotonic() < deadline:
            message = target.ReceiveMessage(None)
            if message.type == rd.TargetControlMessageType.NewCapture:
                capture_data = message.newCapture
                if capture_data.captureId in known_captures or capture_data.timestamp < requested_at:
                    continue
                status.pop("progress", None)
                status.update(state="captured", path=capture_data.path,
                              capture_id=capture_data.captureId, frame=capture_data.frameNumber,
                              timestamp=capture_data.timestamp, api=capture_data.api or target.GetAPI())
                break
            if message.type == rd.TargetControlMessageType.CaptureProgress:
                status["progress"] = message.capProgress
                write_status()
        if status["state"] != "captured":
            raise RuntimeError("Timed out waiting for a rendered frame. The game may be minimized or paused.")
    write_status()
except Exception:
    status.update(state="failed", error=traceback.format_exc())
    write_status()
finally:
    if target is not None:
        target.Shutdown()
sys.exit(0 if status["state"] in ("connected", "captured") else 1)
