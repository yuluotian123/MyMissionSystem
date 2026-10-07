"""Publish verified Player/RenderDoc evidence; RDCs stay in their capture directory.

Usage: python publish_relink_town_evidence.py CAPTURE_DIRECTORY REPLAY_DIRECTORY
Requires three warmed profile reports and an explicit, replayed final-color event.
"""
import argparse
import hashlib
import json
import shutil
from datetime import datetime, timezone
from pathlib import Path
from PIL import Image


def read(path):
    return json.loads(path.read_text(encoding='utf-8-sig'))


def write(path, data):
    path.write_text(json.dumps(data, ensure_ascii=False, indent=2), encoding='utf8')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('captures', type=Path)
    parser.add_argument('replay', type=Path)
    args = parser.parse_args()
    workspace = Path(__file__).resolve().parents[2]
    evidence = workspace / 'Documentation/Rendering/Evidence/srp-town'
    status = read(args.replay / 'analysis_status.json')
    inventory = read(args.replay / 'inventory.json')
    if status['state'] != 'complete':
        raise RuntimeError('Replay incomplete')
    event = status['final_color_event']
    action = next(a for a in inventory['actions'] if a['event'] == event)
    texture = next(t for t in inventory['textures'] if t['id'] == status['final_color_resource'])
    if 'R8G8B8A8' not in texture['format'] or action['outputs'][0] != texture['id']:
        raise RuntimeError('Final event is not the 8-bit color target')
    native = Image.open(args.replay / 'final.png').convert('RGB')
    player = Image.open(args.captures / 'Town-Player-1920x1080.png').convert('RGB')
    if native.size != player.size or native.size != (1920, 1080):
        raise RuntimeError('Unexpected image dimensions')
    errors = []
    for y in range(0, native.height, 37):
        for x in range(0, native.width, 71):
            errors.extend(abs(a - b) for a, b in zip(native.getpixel((x, native.height - 1 - y)), player.getpixel((x, y))))
    comparison = dict(replay_event=event, resource=texture['id'],
                      comparison='Player PNG vs raw RenderDoc target with vertical-coordinate normalization',
                      channels_sampled=len(errors), maximum_8bit_error=max(errors),
                      mean_8bit_error=sum(errors) / len(errors))
    if comparison['maximum_8bit_error'] > 1:
        raise RuntimeError(f'Player/replay color mismatch: {comparison}')
    manifest = dict(utc=datetime.now(timezone.utc).isoformat(), unity='6000.3.10f1', api='D3D11', gpu='NVIDIA GeForce RTX 5080',
                    player_build='Development Windows x64, standalone SRP, no package dependencies',
                    capture_scope='One explicitly submitted camera render request after 280 warmed frames; no swapchain presentation',
                    captures=[], source_sha256={})
    for resolution in ('1280x720', '1920x1080', '2560x1440'):
        rdc = args.captures / f'Native-{resolution}_capture.rdc'
        timing = read(args.captures / f'GPU-{resolution}.json')
        if timing['state'] != 'complete':
            raise RuntimeError(f'Profile incomplete: {resolution}')
        manifest['captures'].append(dict(resolution=resolution, path=rdc.resolve().relative_to(workspace).as_posix(),
            bytes=rdc.stat().st_size, sha256=hashlib.sha256(rdc.read_bytes()).hexdigest().upper(),
            gpu_replay_median_ms=timing['gpu_event_sum_median_ms'],
            draw_count=sum('Draw' in a['name'] for a in timing['actions']),
            dispatch_count=sum('Dispatch' in a['name'] for a in timing['actions']),
            texture_resource_bytes=sum(t['bytes'] for t in timing['textures']), timing_report=f'GPU-{resolution}.json'))
        for name in (f'GPU-{resolution}.json', f'Town-Player-{resolution}.png'):
            shutil.copy2(args.captures / name, evidence / name)
    for path in sorted((workspace / 'Assets/RelinkStyle').rglob('*')):
        if path.suffix not in ('.cs', '.shader', '.cginc', '.compute'):
            continue
        relative = path.relative_to(workspace)
        digest = hashlib.sha256(path.read_bytes()).hexdigest().upper()
        build_path = workspace / 'Temp/RelinkTownValidation' / relative
        if not build_path.exists() or hashlib.sha256(build_path.read_bytes()).hexdigest().upper() != digest:
            raise RuntimeError(f'Player build source differs: {relative}')
        manifest['source_sha256'][relative.as_posix()] = digest
    shutil.copy2(args.captures / 'performance.json', evidence / 'frame-timing-manager.json')
    for name in ('inventory.json', 'analysis_status.json', 'replay_messages.json'):
        shutil.copy2(args.replay / name, evidence / ('native-' + name))
    shutil.copy2(args.replay / 'final.png', evidence / 'Native-Replay-Raw.png')
    write(evidence / 'capture-manifest.json', manifest)
    write(evidence / 'replay-color-comparison.json', comparison)
    print(json.dumps(dict(captures=manifest['captures'], replay=comparison, actions=inventory['action_count'],
                          target_groups=len(inventory['target_groups']), source_files=len(manifest['source_sha256'])), ensure_ascii=False, indent=2))


if __name__ == '__main__':
    main()
