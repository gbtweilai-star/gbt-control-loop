# control_loop

**One capability bit from GBT V8, packaged standalone.** No. 74 of 341,
`desktop` domain (Desktop).

<p>
<img alt="python" src="https://img.shields.io/badge/python-3.9%2B-blue">
<img alt="license" src="https://img.shields.io/badge/license-MIT-green">
<img alt="deps" src="https://img.shields.io/badge/runtime%20dependencies-0-brightgreen">
</p>

> 快慢双脑控制回路（蒸馏自 Jev/TypeSafe System One + browser-use/jev-ultrafast）：动作是**枚举**（CLICK/TYPE_TEXT/SELECT/SCROLL_*/WAIT/DONE/BLOCKED，枚举外不存在）· 一次观测出「操作+目标」两个头 · 只为 TYPE_TEXT 调生成模型 · **执行前两查（新鲜+遮挡）+ DONE 必须独立验证** · 低置信度才升级慢脑（无慢脑如实 BLOCKED）· 预算闸（单次时延+每分钟次数）· 每次决策写 state/control_loop.jsonl 审计链。**它只决策不动手**：动作仍走 desktop_control 等门。op=decide/observe/act/demo/selftest

That description is copied verbatim from the registry. `tests/test_spec.py` pins it,
so documentation drift fails the build instead of shipping quietly.

## What this package actually is

It is the **contract** for one capability: its name, its parameters, the values it
accepts, and whether it can change state that cannot be restored. It is not the
implementation — that lives in the runtime this bit was extracted from.

So `run()` goes through a narrow `Backend` protocol, and the default backend is a
stub that **says so**:

```
status="validated"   backend="stub"   data={"executed": false}
```

Never `status="ok"`. A stub that reports success is worse than no stub, because the
caller stops looking for the real thing.

## Install

```bash
git clone https://github.com/gbtweilai-star/gbt-control-loop.git
cd gbt-control-loop
python -m pip install -e ".[dev]"
```

## Use

```bash
python -m gbt_control_loop info                  # capability card
python -m gbt_control_loop spec --json           # machine-readable contract
python -m gbt_control_loop check --payload '{}'
python -m gbt_control_loop run   --payload '{}'
```

Real `info` output from this machine:

```text
control_loop  (desktop)  v1.0.0
----------------------------------------
快慢双脑控制回路（蒸馏自 Jev/TypeSafe System One + browser-use/jev-ultrafast）：动作是**枚举**（CLICK/TYPE_TEXT/SELECT/SCROLL_*/WAIT/DONE/BLOCKED，枚举外不存在）· 一次观测出「操作+目标」两个头 · 只为 TYPE_TEXT 调生成模型 · **执行前两查（新鲜+遮挡）+ DONE 必须独立验证** · 低置信度才升级慢脑（无慢脑如实 BLOCKED）· 预算闸（单次时延+每分钟次数）· 每次决策写 state/control_loop.jsonl 审计链。**它只决策不动手**：动作仍走 desktop_control 等门。op=decide/observe/act/demo/selftest

gated      : False
external   : False
multi-op   : True
params     : (none)
values     : decide, observe, act, demo, selftest
```

Wire a real implementation:

```python
from gbt_control_loop import run

class MyBackend:
    name = "my-backend"
    def invoke(self, cap, payload):
        return {"cap": cap, "handled": sorted(payload)}

result = run({}, backend=MyBackend())
assert result.status == "ok"
```

## Parameters

| name | required | notes |
|---|---|---|
| — | no | the registry declares no required parameters |

Registry hint (`params_hint`): (empty)

**注册表登记的取值 / 子动作（5 个）**：`decide`、`observe`、`act`、`demo`、`selftest`

Types are deliberately absent: the registry does not declare them, and an invented
type is worse than no type, because callers believe it.

## Boundaries

- Not gated: the registry marks this bit `safe: true`.
- No external service dependency declared.
- Multi-op (`multi_op: true`): several sub-actions share one name — read `op` before calling.
- No implementation ships here. Bring a backend; the protocol is one method.

## What this is not

Not a wrapper around a hosted API. Not a model. Not a promise that calling it does
anything on its own. It is the typed seam plus the validation, which is the part that
stays correct even when the implementation changes.

## Tests

```bash
python -m pytest
```

```text
20 passed, 3 skipped in 0.12s
```

## Provenance

| field | value |
|---|---|
| capability | `control_loop` |
| domain | `desktop` |
| handler | `control_loop` |
| safe | `True` (gated = `False`) |
| external | `False` |
| atlas page | [desktop/control_loop](https://github.com/gbtweilai-star/gbt-caps/blob/main/caps/desktop/control_loop.md) |
| full index | [https://github.com/gbtweilai-star/gbt-caps](https://github.com/gbtweilai-star/gbt-caps) |

The parent README says 348 capabilities; an AST pass over the registry enumerates
`341 + 0 unimplemented + 0 disabled = 341`. The extra 7 are historical duplicates.
Numbering here follows 341 and matches the `gbt-caps` index one-to-one.

## License

MIT.
