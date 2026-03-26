---
title: "Give Your AI Assistant Manjaro Superpowers: The Skill That Fixes Pacman-First Package Resolution"
published: true
tags: [manjaro, archlinux, linux, ai, chatgpt, claude]
canonical_url: https://github.com/ankaboot-source/manjaro-skill
description: "Stop your AI coding assistant from suggesting pip install on Manjaro. Install a skill that teaches pacman-first package management."
cover_image: ""
---

If you've ever used an AI coding assistant on Manjaro, you've probably noticed something frustrating: it defaults to the wrong package manager.

Ask it to install `htop` → it suggests `brew install htop`.
Ask it to install `black` → it suggests `pip install black`.
Ask it to install VS Code → it suggests `snap install code`.

None of these are wrong on Ubuntu, but on Manjaro? They bypass your entire package management system, create conflicts, and leave you with broken upgrades.

## The Root Problem

AI assistants are trained on internet data where Ubuntu/Debian examples dominate. They don't natively "know" pacman, yay, or Arch conventions — even when the system running them is Manjaro.

The fix isn't to lecture the AI every time. The fix is to give it a **skill** — a reusable instruction set that changes its default behavior.

## Introducing the Manjaro Skill

A ~15KB instruction set that teaches any AI coding assistant (Claude Code, OpenCode, Codex, Cursor) to think in pacman first.

### The Package Resolution Hierarchy

```
1. pacman (official repos)
2. yay (AUR)
3. Language-specific installers ONLY in isolation
   (pip in venv, npm in node_modules)
   
NEVER: sudo pip install, npm -g, snap install, brew install
```

### What It Covers

| Domain | Coverage |
|--------|----------|
| Package management | pacman, yay, makepkg, PKGBUILD |
| System services | systemctl, journalctl, timers, sockets |
| Configuration | pacman.conf, mirrorlist, mhwd, mkinitcpio |
| Docker | Compose, containers, networking |
| Snapshots | Timeshift / Btrfs workflow |
| Maintenance | Cache, orphans, kernel cleanup |
| Troubleshooting | 12 structured diagnosis → fix flows |

## Installation

```bash
# Via skills.sh (works with Claude Code, Codex, Cursor, OpenCode)
npx skills add ankaboot-source/manjaro-skill

# Or manual install
git clone https://github.com/ankaboot-source/manjaro-skill.git
cp -r manjaro-skill ~/.config/opencode/skills/manjaro
```

That's it. The skill installs to `~/.config/opencode/skills/manjaro/` and activates automatically.

## Before / After

### Before (without the skill)

```
You: Install htop on my Manjaro system
AI:  brew install htop
```

### After (with the skill)

```
You: Install htop on my Manjaro system
AI:  pamac-installer htop
```

The skill launches Manjaro's native Pamac GUI — you see what will be installed and confirm before anything runs.

## The /manjaro Slash Command

The skill adds a built-in command interface:

```bash
/manjaro check              # System health check
/manjaro install <package>  # Smart install (pacman → AUR)
/manjaro rescue <symptoms>  # Guided troubleshooting
```

## Example: Debugging a Broken Update

```
You: My Manjaro system failed to update and now has conflicts
AI:  (loads manjaro skill)
/manjaro rescue

→ Diagnosis flow:
  1. Check pacman log: journalctl -b -u pacman
  2. Identify conflict type (filesystem, signature, dependency)
  3. Run: sudo pacman -Syu --overwrite '*'
  4. If AUR conflicts: yay -Syu --mflags "--nocheck"
  5. If still broken: snapshot with timeshift before force-resolving
```

## Why It Matters for Manjaro Users

Manjaro occupies a unique position: it's the friendly face of Arch, with sensible defaults and graphical tools, but underneath it's pure rolling-release Arch. Users who rely on AI assistants need tooling that respects that distinction.

This skill bridges the gap between what AI assistants naturally know (Debian/Ubuntu patterns) and what Manjaro users actually need (pacman/AUR patterns).

## Compatibility

| Agent | Status |
|-------|--------|
| OpenCode | ✅ Native |
| Claude Code | ✅ Via skills.sh or plugin |
| Codex | ✅ Via skills.sh |
| Cursor | ✅ Via skills.sh |

## Open Source

GPL-3.0 licensed, contributions welcome:

- GitHub: [ankaboot-source/manjaro-skill](https://github.com/ankaboot-source/manjaro-skill)
- SkillsHub: [skillshub.wtf/ankaboot/manjaro-system-administration](https://skillshub.wtf/ankaboot/manjaro-system-administration)
- LobeHub: [lobehub.com/skills/ankaboot-source/manjaro-skill](https://lobehub.com/skills/ankaboot-source/manjaro-skill)

## TL;DR

One line fixes AI assistants that keep suggesting the wrong package manager on Manjaro:

```bash
npx skills add ankaboot-source/manjaro-skill
```

Happy rolling! 🎯
