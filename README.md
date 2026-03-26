# Manjaro Skill for AI Coding Assistants

A unified Manjaro Linux system administration skill for AI coding assistants (OpenCode, Claude Code, Codex). Makes AI agents prefer native Manjaro tools — pacman, yay, systemd — over generic cross-platform alternatives.

## Features

- **Pacman-first package resolution** — Decision tree that enforces official repos → AUR → language-specific installers (only in isolation)
- **Unified `/manjaro` command** — Slash command with subcommands: `check`, `install`, `rescue`
- **Systemd recipes** — Unit file templates for daemons, timers, user services, Docker containers, socket activation
- **Docker & Timeshift** — Native Docker workflow, snapshot workflow before risky operations
- **12 troubleshooting flows** — Structured diagnosis → fix for broken updates, GPU issues, boot failures, and more
- **Equivalence tables** — Maps generic commands (pip, npm, snap, brew) to Manjaro equivalents

## Compatibility

- **OpenCode** — Drop into `~/.config/opencode/skills/manjaro/`
- **Claude Code** — Drop into `~/.claude/skills/`
- **Claude.ai** — Via Claude Code plugin format

## Quick Start

### Install

**OpenCode:**
```bash
cp -r manjaro ~/.config/opencode/skills/
```

**Claude Code:**
```bash
cp -r manjaro ~/.claude/skills/
```

**Or install via marketplace (Claude Code):**
```bash
claude install baderdean/manjaro-skill
```

### Use

Once installed, the skill triggers automatically when you mention Manjaro, Arch, pacman, systemd, or any system administration task on a Manjaro host.

**Slash command:**
```
/manjaro check                System health check
/manjaro install <package>    Smart package installer (pacman/AUR-first)
/manjaro rescue <symptoms>    Guided troubleshooting
```

## Package Resolution

When you ask to install software on a Manjaro system, this skill enforces:

```
1. pacman (official repos)
2. yay (AUR)
3. Language-specific installers ONLY in isolation (venv, node_modules, etc.)
   NEVER: sudo pip install, npm -g, or any global install
```

Example equivalences:

| Instead of...                  | Use...                  |
|-------------------------------|-------------------------|
| `sudo pip install black`      | `sudo pacman -S python-black` |
| `sudo npm install -g prettier`| `yay -S prettier`       |
| `snap install code`           | `yay -S visual-studio-code-bin` |
| `brew install htop`           | `sudo pacman -S htop`  |

## Contents

```
manjaro/
├── SKILL.md                              # Core skill (auto-loaded)
├── commands/
│   └── manjaro.md                        # /manjaro slash command
└── references/
    ├── packages.md                       # Full pacman/yay reference + equivalence tables
    ├── systemd-recipes.md                # Unit templates, timers, hardening
    └── troubleshooting.md               # 12 common issues with fix flows
```

## License

[GPL-3.0](./LICENSE)
