# Reddit Post — r/ManjaroLinux

## Title (choose one):

**Option A:** "I built a skill that makes AI assistants use pacman instead of pip/npm/snap/brew"

**Option B:** "Stop telling your AI to run `sudo pip install` on Manjaro — here's the fix"

**Option C:** "New open-source skill: AI assistants that actually know Manjaro/Arch Linux"

---

## Body:

Hey r/ManjaroLinux 👋

If you've ever used an AI coding assistant (Claude Code, OpenCode, Codex, etc.) on your Manjaro system, you've probably noticed it defaulting to the wrong package manager.

Ask it to install something → it suggests `sudo pip install`, `npm -g`, `snap install`, or `brew install`. None of those are the Manjaro way.

**So I built a skill that fixes this.**

It's a ~15KB instruction set that teaches AI assistants the pacman-first hierarchy:

```
1. pacman (official repos)
2. yay (AUR)
3. pip/npm/etc. ONLY in isolation (venv, node_modules)
   NEVER: sudo pip install, npm -g, snap install
```

## What it covers

- Package management (pacman, yay, makepkg)
- Systemd services (systemctl, journalctl)
- Configuration files (pacman.conf, mirrorlist)
- Docker workflow
- Timeshift / Btrfs snapshots
- 12 troubleshooting flows (broken updates, GPU issues, boot failures...)
- Maintenance (cache cleanup, orphan removal, kernel management)

## Install (one line)

```bash
# OpenCode / Claude Code
npx skills add ankaboot-source/manjaro-skill

# Or via marketplace
curl -fsSL https://raw.githubusercontent.com/ankaboot-source/manjaro-skill/master/install.sh | bash
```

## Before / After Example

**Before** (what most AI assistants do by default):
```
sudo pip install httpie
```

**After** (with the skill):
```
sudo pacman -S httpie
```

Or if not in repos:
```
yay -S python-httpie
```

## Demo

The skill adds a `/manjaro` slash command:
```
/manjaro check        # System health check
/manjaro install htop # Smart install (pacman → AUR)
/manjaro rescue       # Guided troubleshooting
```

## More info

- GitHub: https://github.com/ankaboot-source/manjaro-skill
- SkillsHub: https://skillshub.wtf/ankaboot/manjaro-system-administration
- LobeHub: https://lobehub.com/skills/ankaboot-source/manjaro-skill
- Registry: Skills.sh (npx skills add ankaboot-source/manjaro-skill)

It's MIT licensed, works with OpenCode, Claude Code, Codex, and Cursor. The skill is in `~/.config/opencode/skills/manjaro/` after install.

Would love feedback from the community — especially if you find places where the troubleshooting flows need improvement!

---

*TL;DR: One-line install fixes AI assistants that keep suggesting wrong package managers on Manjaro.*
