# Forum Post — forum.manjaro.org

## Category: Development or Tutorials

## Title:
[Tool] Manjaro Skill for AI Assistants — pacman-first package resolution

## Body:

Hello Manjaro community!

I've released an open-source skill that teaches AI coding assistants (Claude Code, OpenCode, Codex, Cursor) to prefer pacman and yay over generic package managers.

## The Problem

Ask most AI assistants to install software on Manjaro → they suggest `pip install --global`, `npm -g`, `snap install`, or `brew install`. These work but bypass the Manjaro package management system entirely.

## The Solution

A skill (~15KB) that enforces the correct hierarchy:

```
1. pacman → 2. yay (AUR) → 3. pip/npm only in isolation
```

## What It Covers

- **Package management**: pacman, yay, makepkg, PKGBUILD
- **System services**: systemctl, journalctl, systemd timers
- **Configuration**: pacman.conf, mirrorlist, mhwd, mkinitcpio
- **Docker**: Native workflow, container management
- **Snapshots**: Timeshift / Btrfs workflow
- **Maintenance**: Cache cleanup, orphan removal, kernel management
- **Troubleshooting**: 12 structured diagnosis → fix flows

## Install

```bash
# Via skills.sh (works with Claude Code, Codex, Cursor, OpenCode)
npx skills add ankaboot-source/manjaro-skill

# Or via install script
curl -fsSL https://raw.githubusercontent.com/ankaboot-source/manjaro-skill/master/install.sh | bash
```

## Usage

After install, AI assistants automatically use pacman when you ask to install software. It also adds a `/manjaro` slash command:

```
/manjaro check         # System health
/manjaro install htop  # Smart install (pacman → AUR)
/manjaro rescue        # Guided troubleshooting
```

## Example

**Without skill:**
> `sudo pip install black`

**With skill:**
> `sudo pacman -S python-black`
> or if not in repos: `yay -S python-black`

## Resources

- GitHub: https://github.com/ankaboot-source/manjaro-skill
- SkillsHub: https://skillshub.wtf/ankaboot/manjaro-system-administration
- LobeHub: https://lobehub.com/skills/ankaboot-source/manjaro-skill

MIT licensed. Works on any Arch-based system, not just Manjaro.

Feedback and contributions welcome!
