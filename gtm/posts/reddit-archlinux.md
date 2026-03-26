# Reddit Post — r/archlinux

## Title:
"Works on Arch too: a skill that makes AI assistants use pacman instead of pip/npm"

## Body:

Hey r/archlinux — this is Manjaro-flavored but fully works on Arch.

If you've used AI coding assistants on Arch, you've probably noticed them defaulting to `pip install -g`, `npm -g`, etc. The fix is a skill that teaches pacman-first resolution.

## Quick demo

**Without skill:**
```
You: install neovim on my Arch system
AI:  pip install neovim  # wrong
```

**With skill:**
```
You: install neovim on my Arch system  
AI:  sudo pacman -S neovim
```

## Install

```bash
npx skills add ankaboot-source/manjaro-skill
```

Works with Claude Code, OpenCode, Codex, Cursor.

## What's inside

- pacman/yay/PKGBUILD workflow
- systemd templates (services, timers, sockets)
- Docker + Timeshift
- 12 troubleshooting flows
- /manjaro slash command

GitHub: https://github.com/ankaboot-source/manjaro-skill

(Yes, the name says Manjaro but it's pure Arch underneath)
