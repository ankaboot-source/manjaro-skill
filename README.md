---
name: Manjaro Skill for AI Coding Assistants
---

<!-- Header badges -->
[![Validate](https://github.com/ankaboot-source/manjaro-skill/actions/workflows/validate.yml/badge.svg)](https://github.com/ankaboot-source/manjaro-skill/actions)
[![GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)
[![Manjaro](https://img.shields.io/badge/Manjaro-Linux-orange.svg)](https://manjaro.org)
[![OpenCode](https://img.shields.io/badge/OpenCode-Compatible-green.svg)](https://opencode.ai)

# Manjaro Skill for AI Coding Assistants

> Give your AI coding assistant native fluency in Manjaro Linux.

This skill makes AI agents (OpenCode, Claude Code, Codex) prefer native Manjaro tools —
pacman, yay, systemd, mhwd — over generic cross-platform alternatives like `pip install`,
`npm -g`, or `snap`.

## What It Does

When your AI assistant handles a Manjaro system, it will automatically:

- **Install packages the right way** — `pacman` → AUR (`yay`) → language-specific installers only in isolation
- **Manage services with systemd** — create unit files, timers, user services, Docker containers as services
- **Troubleshoot intelligently** — 12 structured fix flows for broken updates, GPU failures, boot issues, and more
- **Create snapshots before risky changes** — integrates Timeshift/Btrfs into the update workflow
- **Answer manjaro-chroot, mkinitcpio, mhwd, pacman.conf, mirrorlist questions** — from memory, without guessing

Also ships with a **`/manjaro` slash command** for quick system health checks, smart package installation, and guided troubleshooting.

## One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/ankaboot-source/manjaro-skill/main/install.sh | bash
```

Or manually:

```bash
git clone https://github.com/ankaboot-source/manjaro-skill.git ~/.config/opencode/skills/manjaro
```

## Compatibility

| Platform | Install Path | Verified |
|----------|-------------|----------|
| **OpenCode** | `~/.config/opencode/skills/manjaro/` | ✅ |
| **Claude Code** | `~/.claude/skills/manjaro/` | ✅ |
| **Claude.ai** | Via Claude Code plugin | ✅ |

## Quick Start

Once installed, the skill **triggers automatically** when you mention:

- `manjaro`, `arch linux`, `pacman`, `yay`, `makepkg`
- `systemctl`, `journalctl`, `mkinitcpio`, `grub`
- `mhwd`, `btrfs`, `timeshift`, `manjaro-chroot`
- Any system administration task on a Manjaro/Arch host

### Slash Command

```
/manjaro check                System health check (disk, services, updates, kernels)
/manjaro install <package>   Smart installer — pacman first, AUR second, never global pip/npm
/manjaro rescue <symptoms>   Guided troubleshooting from natural-language symptom description
```

## The Core Principle: Pacman First

When you ask to install software on a Manjaro system, this skill enforces:

```
1. pacman  → official repos
2. yay     → AUR (Arch User Repository)
3. Language-specific installers → ONLY in isolation (venv, node_modules)
   NEVER: sudo pip install, npm -g, cargo install --global
```

| Instead of... | Use... |
|---|---|
| `sudo pip install ansible` | `sudo pacman -S ansible` |
| `sudo npm install -g prettier` | `yay -S prettier` |
| `snap install code` | `yay -S visual-studio-code-bin` |
| `curl -fsSL ... \| sh` | Search `pacman -Ss` first |
| `brew install htop` | `sudo pacman -S htop` |

See `references/packages.md` for the full equivalence table.

## Repository Structure

```
manjaro-skill/
├── SKILL.md                     # Core skill (auto-loaded on trigger)
├── commands/
│   └── manjaro.md               # /manjaro slash command (check, install, rescue)
├── references/
│   ├── packages.md              # pacman/yay commands + equivalence tables
│   ├── systemd-recipes.md       # Unit file templates, timers, hardening
│   └── troubleshooting.md       # 12 structured fix flows
├── install.sh                   # One-line installer
├── .github/
│   └── workflows/validate.yml   # CI validation
├── README.md
└── LICENSE                      # GPL-3.0
```

## Reference Guides

| File | Contents |
|------|----------|
| `references/packages.md` | Full pacman/yay/makepkg reference, generic-to-Manjaro equivalence tables, cache management, downgrading, one-liners |
| `references/systemd-recipes.md` | Unit file templates for daemon/oneshot/forking services, timers (OnCalendar syntax), Docker as service, socket activation, hardening directives, boot analysis |
| `references/troubleshooting.md` | 12 issues with diagnosis → fix flows: broken updates, GPU, lock files, filesystem corruption, boot failures, dependency conflicts, keyring, sound, network, permissions, disk space, clock |

## Topics

`manjaro` `arch-linux` `pacman` `aur` `yay` `systemd` `opencode` `claude-code` `ai-agent`
`linux-administration` `btrfs` `docker` `timeshift`

## Contributing

Issues and pull requests welcome. For major changes, open an issue first to discuss the proposal.

## License

[GPL-3.0](./LICENSE) — same license used by [manjaro](https://github.com/manjaro), [pamac](https://github.com/manjaro/pamac), and other Manjaro projects.
