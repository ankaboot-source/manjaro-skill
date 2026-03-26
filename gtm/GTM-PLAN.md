# Manjaro Skill — Go-To-Market Plan

## Context

**What:** An AI agent skill that makes any AI coding assistant (OpenCode, Claude Code, Codex, Cursor) prefer native Manjaro/Arch tools (pacman, yay, systemd) over generic cross-platform alternatives.

**Why it matters:** AI assistants trained on internet data default to Ubuntu/Debian commands. When asked to install software on Manjaro, they suggest `pip install --global`, `npm -g`, `snap install`, `brew install`. This skill fixes that.

**Target users:** Manjaro users who work with AI coding assistants, B2B freelancers, Linux sysadmins, developers who dual-boot or use VMs.

**Channels:** Manjaro community (forum, Discord, Reddit), Arch ecosystem, AI agent community.

---

## Community Channels

### 1. Reddit — r/ManjaroLinux (~68K members)
**When:** Post once, engage with comments
**Format:** Text post with demo, code blocks, install command
**Draft:** `../posts/reddit-manjaro-linux.md`
**Tag:** `flair: News & Announcements` if available, else `General`

### 2. Manjaro Forum — forum.manjaro.org
**When:** Post in Development or Tutorials section
**Format:** Forum post with example use cases, code blocks
**Draft:** `../posts/forum-manjaro.md`
**Note:** Forum requires account, anti-spam measures

### 3. Manjaro Discord — Official Community (4K members)
**When:** Share in #general or #development channel
**Format:** Short message + install command
**Draft:** `../posts/discord-message.md`
**Invite:** https://discord.gg/manjaro-linux-382188421831065621

### 4. Arch Linux Subreddit — r/archlinux
**When:** Post if skill is Arch-compatible (it is)
**Format:** Text post framed as "works for Arch too"
**Draft:** `../posts/reddit-archlinux.md`

---

## Tech Content

### 5. DEV.to Article
**Title:** "Give Your AI Assistant Manjaro Superpowers: The Skill That Fixes Pacman-First Package Resolution"
**Format:** Tutorial with before/after examples, code blocks, install commands
**Draft:** `../posts/devto-article.md`
**Tags:** #manjaro #archlinux #linux #ai #chatgpt #claude

### 6. Lobsters / Hacker News
**If trending:** Submit to HN, Lobsters if article gains traction

---

## Arch Ecosystem Outreach

### 7. Arch Wiki
**Action:** Open GitHub issue or PR to Arch Wiki suggesting AI tooling resources
**Draft:** `../posts/arch-wiki-pr.md`

### 8. yay AUR Package Page
**Action:** Comment on yay package page (awna/aur), engage with comments about tooling
**Note:** AUR has comment system at https://aur.archlinux.org/packages/yay

### 9. EndeavourOS Forum
**Target:** EndeavourOS users (Arch-based, similar audience)
**Draft:** `../posts/endeavouros-forum.md`

---

## Social

### 10. Twitter/X
**Format:** Thread or single tweet
**Hashtags:** #Manjaro #ArchLinux #Linux #AI #ChatGPT #OpenCode #Claude
**Draft:** `../posts/twitter-thread.md`

### 11. LinkedIn
**Format:** Post in Linux Admins, DevOps, AI/ML groups
**Draft:** `../posts/linkedin-post.md`

---

## Repository Stats to Track

Set up after GTM launch:
- GitHub stars on ankaboot-source/manjaro-skill
- Skills.sh install count (via telemetry)
- SkillsHub fetch count
- LobeHub installs

---

## Metrics

| Metric | Baseline (Day 0) | Target (Week 1) | Target (Month 1) |
|--------|-----------------|-----------------|-------------------|
| GitHub Stars | 0 | 10+ | 50+ |
| Skills.sh installs | 0 | 5+ | 25+ |
| Reddit upvotes | — | 10+ | 50+ |
| Forum replies | — | 3+ | 10+ |

---

## Execution Order

1. Reddit post (r/ManjaroLinux) — highest reach
2. DEV.to article — evergreen content, SEO
3. Manjaro Forum post
4. Discord message
5. Twitter thread
6. Arch ecosystem outreach (yay, wiki)
7. LinkedIn post
