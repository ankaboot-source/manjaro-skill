# Article linuxfr.org — Journal

## Format: Journal LinuxFR

---

## Titre :

Journal: Un skill pour apprendre à l'IA à utiliser pacman sur Manjaro

---

## Contenu :

Salut lesgens,

Je viens de publier un "skill" pour assistants IA (Claude Code, OpenCode, Codex, Cursor) qui leur apprend à utiliser pacman et yay sur Manjaro (et plus généralement Arch).

## Le problème

Vous utilisez un assistant IA sur Manjaro ? Vous avez remarqué qu'il suggère `pip install --global`, `npm -g`, `snap install` ou `brew install` ?

Ça fonctionne, mais ça bypass pacman, ça crée des conflits, et boom — une mise à jour qui pète tout.

L'IA ne "connaît" pas pacman par défaut. Elle a été entraînée sur des données dominées par Ubuntu/Debian.

## La solution

J'ai créé un skill (~15KB) qui impose la hiérarchie correcta :

```
1. pacman (dépôts officiels)
2. yay (AUR)  
3. pip/npm UNIQUEMENT en isolation (venv, node_modules)
   JAMAIS: sudo pip install, npm -g, snap, brew
```

Maintenant, quand je demande à l'IA d'installer `htop` sur Manjaro :

```
Avant : sudo pip install htop  # 😱
Après : sudo pacman -S htop    # 😎
```

## Ce que ça couvre

- Gestion des paquets (pacman, yay, makepkg, PKGBUILD)
- Services systemd (systemctl, journalctl, timers, sockets)
- Configuration (pacman.conf, mirrorlist, mhwd)
- Docker
- Timeshift / Btrfs
- 12 flows de dépannage
- Commande `/manjaro` intégrée

## Installation

```bash
npx skills add ankaboot-source/manjaro-skill
```

Ou via le script :

```bash
curl -fsSL https://raw.githubusercontent.com/ankaboot-source/manjaro-skill/master/install.sh | bash
```

## Pourquoi j'ai fait ça

Je suis utilisateur Linux depuis 2000 (époque Mandrake, oui je suis vieux). Aujourd'hui je suis Product Manager / Professional Service Manager.

J'utilise Manjaro parce que j'aime le rolling release et la philosophie Arch, mais j'ai plus vraiment envie de passer mes soirées à débugger des conflits de dépendances.

Ce skill me permet de garder Manjaro sans les migraines. L'IA fait le travail fastidieux, je reste productif.

## Liens

- GitHub : https://github.com/ankaboot-source/manjaro-skill
- SkillsHub : https://skillshub.wtf/ankaboot/manjaro-system-administration
- LobeHub : https://lobehub.com/skills/ankaboot-source/manjaro-skill

GPL-3.0, contributions bienvenues.

---

## Tags suggérés :

- manjaro
- archlinux
- pacman
- ia
- assistant

## Catégories LinuxFR :

- Logicerie
- Linux
- Developpement
