# Design: Python Virtualenv Prompt Indicator

**Date:** 2026-02-22

## Problem

The custom `fish_prompt.fish` fully replaces fish's default prompt, which means the
virtualenv `activate.fish` script's prompt-patching is silently ignored. `$VIRTUAL_ENV`
is set on activation but never displayed.

## Design

### Placement

Line 2 of the prompt, before the `>` character:

```
[10:42:15] user@host ~/project          (main)
🐍(myenv) > _
```

When no virtualenv is active, line 2 is unchanged:

```
[10:42:15] user@host ~/project          (main)
> _
```

### Color

Yellow — matches the existing command-duration indicator color.

### Implementation

One change to `functions/fish_prompt.fish`: replace the unconditional `left_bottom`
assignment with a conditional that checks `$VIRTUAL_ENV`:

```fish
if set -q VIRTUAL_ENV
    set -l venv_name (basename $VIRTUAL_ENV)
    set -l left_bottom (printf '%s🐍(%s)%s > ' (set_color yellow) $venv_name (set_color normal))
else
    set -l left_bottom (printf '%s> ' (set_color normal))
end
```

### Why not `VIRTUAL_ENV_DISABLE_PROMPT`?

Not needed. That flag tells `activate.fish` not to patch the prompt. Since the custom
`fish_prompt.fish` already prevents that patching from taking effect, the flag provides
no benefit here.

## Files Changed

- `functions/fish_prompt.fish` — add virtualenv conditional to `left_bottom`
