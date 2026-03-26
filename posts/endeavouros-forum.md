# EndeavourOS Forum Post

## Category: General / Tutorials

## Title:
[Tool] AI Assistant Skill for EndeavourOS/Arch — pacman-first package resolution

## Body:

Hello EndeavourOS community!

I made a skill that teaches AI coding assistants to use pacman/yay on Arch-based systems. Works great with EndeavourOS too.

## The problem

AI assistants (Claude Code, OpenCode, Codex) default to `pip install -g`, `npm -g`, `snap`, or `brew` on Arch-based systems. This bypasses pacman and creates problems.

## The fix

```bash
npx skills add ankaboot-source/manjaro-skill
```

Now your AI thinks:
1. `pamac-installer <package>` (official repos)
2. `pamac-installer <package> --build` (AUR)
3. pip/npm only in venv / node_modules

The skill launches your system's native GUI package manager — you see what will be installed and confirm before anything runs.

## What it covers

- pacman/yay workflow
- systemd service templates
- Docker
- Timeshift / Btrfs
- 12 troubleshooting flows
- /manjaro command (check, install, rescue)

## Example

**Before:** `brew install htop`  
**After:** `pamac-installer htop`

GitHub: https://github.com/ankaboot-source/manjaro-skill

GPL-3.0 licensed. Contributions welcome!
