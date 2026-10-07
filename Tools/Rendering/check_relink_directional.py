"""Compare the reconstructed directional formula with actual RenderDoc pixel traces.

No replay or game launch: consumes debug_relink_directional.py's trace. This checks
the unblended shader output, not the quantized HDR target or the entire frame.
Register checkpoints only extract inputs; dot products/BRDF are recomputed here.
"""
import argparse
import hashlib
import json
import math
from pathlib import Path


def normalize(vector):
    length = math.sqrt(sum(v * v for v in vector))
    return [v / length for v in vector]


def dot(a, b):
    return max(0, min(1, sum(x * y for x, y in zip(a, b))))


def check(trace):
    checkpoints = {3, 28, 37, 41, 43, 48, 49, 51}
    registers, snapshots = {}, {}
    for step in trace['steps']:
        for variable in step['changes']:
            registers[variable['name']] = variable['floats']
        if step['next_instruction'] in checkpoints:
            snapshots[step['next_instruction']] = dict(registers)
    base = snapshots[3]['r1'][:3]
    normal = snapshots[28]['r0'][1:4]
    position = snapshots[37]['r3'][:3]
    metal = snapshots[41]['r1'][3]
    rough = snapshots[43]['r2'][2]
    shadow = snapshots[48]['r2'][0]
    subtract = snapshots[49]['r4'][:3]
    constants = next(c for c in trace['constants'] if c['name'] == 'cb2')['members']
    light = constants[1]['floats'][:3]
    radiance = [max(0, a - b) for a, b in zip(constants[0]['floats'][:3], subtract)]
    view = normalize([-v for v in position])
    half = normalize([a + b for a, b in zip(light, view)])
    nl, nh, lh = dot(normal, light), dot(normal, half), dot(light, half)
    rough4 = rough ** 4
    denominator = 4 * math.pi * (rough + .5) * (lh * (nh * nh * (rough4 - 1) + 1)) ** 2
    diffuse_scale = (1 - metal) * nl / math.pi
    specular_scale = metal * nl * rough4 / denominator
    expected = [a * r * (diffuse_scale + specular_scale) * shadow for a, r in zip(base, radiance)]
    actual = trace['final_registers']['o0']['floats'][:3]
    error = max(abs(a - b) for a, b in zip(expected, actual))
    return dict(x=trace['x'], y=trace['y'], base=base, normal=normal, position=position,
                metal=metal, rough=rough, shadow=shadow, radiance=radiance,
                NdotL=nl, NdotH=nh, LdotH=lh,
                expected=expected, actual=actual, max_absolute_error=error,
                passed=error < 1e-5)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('trace', type=Path)
    parser.add_argument('output', type=Path)
    args = parser.parse_args()
    raw = args.trace.read_bytes()
    trace = json.loads(raw)
    if trace['state'] != 'complete':
        raise RuntimeError('Trace incomplete')
    pixels = [check(p) for p in trace['pixels']]
    result = dict(capture=trace['capture'], event=trace['event'],
                  trace_sha256=hashlib.sha256(raw).hexdigest().upper(),
                  scope='Directional shader unblended RGB at eight sampled pixels; not whole-frame equivalence',
                  tolerance=1e-5, pixels=pixels,
                  max_absolute_error=max(p['max_absolute_error'] for p in pixels),
                  passed=all(p['passed'] for p in pixels))
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, ensure_ascii=False, indent=2), encoding='utf8')
    print(json.dumps({k:v for k,v in result.items() if k != 'pixels'}, indent=2))
    for p in pixels:
        print(f"({p['x']},{p['y']}) metal={p['metal']:.6f} NL={p['NdotL']:.6f} error={p['max_absolute_error']:.9g}")
    if not result['passed']:
        raise SystemExit(1)


if __name__ == '__main__':
    main()
