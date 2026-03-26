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
1. `sudo pacman -S <package>` (official repos)
2. `yay -S <package>` (AUR)
3. pip/npm only in venv / node_modules

## What it covers

- pacman/yay workflow
- systemd service templates
- Docker
- Timeshift / Btrfs
- 12 troubleshooting flows
- /manjaro command (check, install, rescue)

## Example

**Before:** `sudo pip install black`  
**After:** `sudo pacman -S python-black` (or `yay -S python-black`)

GitHub: https://github.com/ankaboot-source/manjaro-skill

MIT licensed. Contributions welcome!
