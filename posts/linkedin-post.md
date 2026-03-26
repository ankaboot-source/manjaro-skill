# LinkedIn Post

## Format: Text post with code blocks

## Content:

🔧 If you manage Linux systems and use AI coding assistants, this one's for you.

AI assistants trained on internet data default to the wrong package manager on Arch-based systems.

Ask it to install software → it suggests `pip install --global`, `npm -g`, `snap install`, or `brew install`.

On Ubuntu? Fine. On Manjaro or Arch? It bypasses pacman, creates conflicts, breaks upgrades.

I built a skill that fixes this. Installation:

```
npx skills add ankaboot-source/manjaro-skill
```

Or manual:
```
git clone https://github.com/ankaboot-source/manjaro-skill.git
cp -r manjaro-skill ~/.config/opencode/skills/manjaro
```

Now your AI thinks in pacman first, yay for AUR, and reserves pip/npm for isolated environments only. On Manjaro, it launches the Pamac GUI for installation confirmation — you see what will be installed before anything runs.

What it covers:
▸ Package management (pacman, yay, pamac-installer)
▸ Systemd services & timers
▸ Docker workflow
▸ Timeshift / Btrfs snapshots
▸ 12 troubleshooting flows for common Arch issues
▸ /manjaro slash command (check, install, rescue)

Works with: Claude Code, OpenCode, Codex, Cursor.

Open source (GPL-3.0) → github.com/ankaboot-source/manjaro-skill

Have you run into this issue with AI assistants on Linux? Would love to hear how others are handling it.

#Linux #Manjaro #ArchLinux #DevOps #SysAdmin #AI #Claude #OpenCode

---

## Image suggestion:
Screenshot of "Before/After" — terminal showing `sudo pip install` crossed out, `sudo pacman -S` highlighted
