# Article Medium

## Format: Medium Story

---

## Titre :

Je ne suis plus développeur, mais je reste un linuxien hardcore — Et j'ai créé un skill pour IA

---

## Sous-titre :

Depuis Mandrake 2000 jusqu'à Manjaro 2026 : comment j'ai appris à l'IA à utiliser pacman pour me faciliter la vie

---

## Contenu :

*Note: Cet article est en anglais pour le partage sur Medium. Version française disponible sur linuxfr.org.*

---

I used to be a developer. PHP, Java, Perl, a bit of Python. I was what you'd call a "full-stack" developer — even if that term didn't exist in 2005.

Today, I'm a Product Manager. Or a Professional Service Manager. It depends on how you look at it.

But one thing that hasn't changed since 2000? My love for Linux.

## The Linux Journey

I've been using Linux since the Mandrake era. Yes, Mandrake — the French distribution that later became Mandriva. That dates me, I know.

Over the years, I've used Red Hat, Fedora, Debian, Ubuntu, Arch. And for the past few years? Manjaro.

Why Manjaro? It's Arch made accessible. Rolling release, sensible defaults, and underneath it all — pure Arch Linux. The best of both worlds.

## The Problem with AI and Linux

Here's what happens when you use an AI coding assistant on Manjaro:

You ask it to install `htop`. It suggests `brew install htop`.

You ask it to install `neovim`. It suggests `npm install -g neovim`.

You ask it to install VS Code. It suggests `snap install code`.

On Ubuntu? Sure, no problem.

On Manjaro? This bypasses pacman entirely, creates dependency conflicts, and breaks your next system upgrade.

The AI doesn't "know" pacman. It was trained on internet data where Ubuntu/Debian examples dominate.

## The Solution

I created a "skill" — a reusable instruction set for AI assistants — that teaches the correct package hierarchy:

```
1. pacman (official repos) → pamac-installer
2. yay (AUR) → pamac-installer --build
3. pip/npm ONLY in isolation (venv, node_modules)
   NEVER: sudo pip install, npm -g, snap, brew
```

Now when I ask my AI to install `htop` on Manjaro:

```
Before: brew install htop    # 😱
After:  pamac-installer htop  # 😎
```

The skill launches Manjaro's native Pamac GUI — you see what will be installed and confirm before it runs.

## What the Skill Covers

| Domain | Coverage |
|--------|----------|
| Package management | pacman, yay, makepkg, PKGBUILD |
| System services | systemctl, journalctl, timers |
| Configuration | pacman.conf, mirrorlist, mhwd |
| Docker | Native workflow |
| Snapshots | Timeshift / Btrfs |
| Troubleshooting | 12 structured diagnosis → fix flows |

It also adds a `/manjaro` slash command:

```
/manjaro check              # System health
/manjaro install htop      # Smart install
/manjaro rescue            # Guided troubleshooting
```

## Why It Matters to Me

I'm probably "old school" (Mandrake in 2000, remember?). But I don't enjoy spending my evenings debugging dependency conflicts anymore.

This skill lets me stay on Manjaro — a distribution I love — without the headaches.

As a PM/PSM, I work with developers who also use Linux. This skill isn't just for me — it's for anyone who wants to use AI with Arch-based systems without having to fix the AI's mistakes every time.

## Installation

```bash
npx skills add ankaboot-source/manjaro-skill
```

Or manual install:

```bash
git clone https://github.com/ankaboot-source/manjaro-skill.git
cp -r manjaro-skill ~/.config/opencode/skills/manjaro
```

Works with: OpenCode, Claude Code, Codex, Cursor.

## Open Source

GPL-3.0 licensed, contributions welcome:

🔗 [github.com/ankaboot-source/manjaro-skill](https://github.com/ankaboot-source/manjaro-skill)
📦 [SkillsHub](https://skillshub.wtf/ankaboot/manjaro-system-administration)
🤖 [LobeHub](https://lobehub.com/skills/ankaboot-source/manjaro-skill)

---

*I'm also the author of [leadminer.io](https://leadminer.io) — a B2B lead generation admin interface.*

*French version of this article available on [linuxfr.org](https://linuxfr.org)*
