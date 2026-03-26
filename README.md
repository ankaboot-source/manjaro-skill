# Manjaro Skill for AI Coding Assistants

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL%203.0-blue.svg)](https://opensource.org/licenses/GPL-3.0)
[![GitHub stars](https://img.shields.io/github/stars/ankaboot-source/manjaro-skill)](https://github.com/ankaboot-source/manjaro-skill/stargazers)
[![GitHub issues](https://img.shields.io/github/issues/ankaboot-source/manjaro-skill)](https://github.com/ankaboot-source/manjaro-skill/issues)
[![Skills.sh](https://img.shields.io/badge/Skills.sh-npx%20skills%20add%20ankaboot--source/manjaro--skill-blue)](https://skills.sh)
[![LobeHub](https://img.shields.io/badge/LobeHub-Registered-green)](https://lobehub.com/skills/ankaboot-source/manjaro-skill)
[![SkillsHub](https://img.shields.io/badge/SkillsHub-Listed-purple)](https://skillshub.wtf/ankaboot/manjaro-system-administration)

**Keywords:** manjaro, arch-linux, pacman, aur, yay, systemd, btrfs, timeshift, docker, opencode, claude-code, ai-agent, linux-administration

A unified Manjaro Linux system administration skill for AI coding assistants (OpenCode, Claude Code, Codex, Cursor). Makes AI agents prefer native Manjaro tools — pacman, yay, systemd — over generic cross-platform alternatives.

## The Problem

Ask any AI assistant to install software on Manjaro → it defaults to `pip install -g`, `npm -g`, `snap`, or `brew`. These bypass pacman and create dependency conflicts.

**This skill fixes that.**

## Features

- **Pacman-first package resolution** — Decision tree that enforces official repos → AUR → language-specific installers (only in isolation)
- **Unified `/manjaro` command** — Slash command with subcommands: `check`, `install`, `rescue`
- **Systemd recipes** — Unit file templates for daemons, timers, user services, Docker containers, socket activation
- **Docker & Timeshift** — Native Docker workflow, snapshot workflow before risky operations
- **12 troubleshooting flows** — Structured diagnosis → fix for broken updates, GPU issues, boot failures, and more
- **Equivalence tables** — Maps generic commands (pip, npm, snap, brew) to Manjaro equivalents

## Compatibility

| Agent | Path |
|-------|------|
| OpenCode | `~/.config/opencode/skills/manjaro/` |
| Claude Code | `~/.claude/skills/` |
| Codex | `~/.agents/skills/` |
| Cursor | `~/.cursor/skills/` |

## Install

### One-line (any terminal)
```bash
curl -fsSL https://raw.githubusercontent.com/ankaboot-source/manjaro-skill/master/install.sh | bash
```

### Via Package Manager
```bash
# Skills.sh (works with Claude Code, Codex, Cursor, OpenCode)
npx skills add ankaboot-source/manjaro-skill

# Claude Code
claude install ankaboot-source/manjaro-skill
```

### Manual
```bash
# OpenCode
cp -r manjaro ~/.config/opencode/skills/

# Claude Code
cp -r manjaro ~/.claude/skills/
```

## Use

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

### Before / After

| Instead of... | Use... |
|--------------|--------|
| `brew install htop` | `sudo pacman -S htop` |
| `snap install code` | `yay -S visual-studio-code-bin` |
| `curl ... \| sh` (arbitrary script) | `sudo pacman -S <package>` or `yay -S <package>` |
| `npm -g install neovim` | `sudo pacman -S neovim` |

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

## Resources

| Marketplace | Link |
|-------------|------|
| GitHub | https://github.com/ankaboot-source/manjaro-skill |
| Skills.sh | `npx skills add ankaboot-source/manjaro-skill` |
| LobeHub | https://lobehub.com/skills/ankaboot-source/manjaro-skill |
| SkillsHub | https://skillshub.wtf/ankaboot/manjaro-system-administration |

## ⚠️ Safety

**This skill helps AI suggest correct Manjaro commands. You always retain control.**

### Recommended OpenCode Configuration

Add this to `~/.config/opencode/opencode.json` to require approval before running system changes:

```json
{
  "permission": {
    "bash": {
      "*": "ask",
      "pacman -Ss *": "allow",
      "yay -Ss *": "allow",
      "systemctl status *": "allow",
      "journalctl *": "allow",
      "git *": "allow"
    }
  }
}
```

This ensures:
- `sudo pacman -S ...`, `yay -S ...` → **requires approval**
- Search queries, status checks, git → **auto-allow**

### Best Practices

- Always review commands before running, especially those with `sudo`
- Create Timeshift snapshots before major changes
- The AI *suggests* commands — you decide what runs

## License

[GPL-3.0](./LICENSE)
