# Article LinkedIn — Version Française

## Format: Article LinkedIn (publication longue)

---

## Titre :

Je ne suis plus développeur, mais j'aide les développeurs à mieux coder — avec l'IA

---

## Contenu :

Il fut un temps où je codais. Du PHP, du Java, du Perl, un peu de Python. J'étais développeur, on va dire "full-stack" même si ce terme n'existait pas encore en 2005.

Aujourd'hui, je suis Product Manager. Ou Professional Service Manager. Ça dépend de comment on voit les choses.

Mais ce qui n'a pas changé depuis 2000 ? Mon amour pour Linux.

## Le problème avec l'IA et Linux

J'utilise Manjaro Linux. Rolling release, pacman, yay pour l'AUR, systemd — tout ce qui va bien.

Mais voila le problème : quand je demande à un assistant IA d'installer quelque chose sur Manjaro, il me suggère `pip install --global`, `npm -g`, ou pire, `snap install`.

Sur Ubuntu ? Pas de problème.
Sur Manjaro ? Ça bypass tout le système de paquets, ça crée des conflits, et hop — une mise à jour qui casse tout.

L'IA ne "connaît" pas pacman. Elle a été entraînée sur des données où Ubuntu domine.

## La solution

J'ai créé un "skill" — une compétence pour assistant IA — qui enseigne la hiérarchie pacman :

```
1. pacman (dépôts officiels) → pamac-installer
2. yay (AUR) → pamac-installer --build
3. pip/npm UNIQUEMENT en isolation (venv, node_modules)
   JAMAIS : sudo pip install, npm -g, snap, brew
```

Désormais, quand je demande à mon IA d'installer `htop` sur Manjaro, elle lance Pamac :

```
pamac-installer htop
```

L'IA ouvre l'interface graphique Manjaro — vous voyez ce qui sera installé et vous confirmez avant que quoi que ce soit ne soit exécuté.

## Ce que couvre le skill

- Gestion des paquets (pacman, yay, makepkg)
- Services systemd (systemctl, journalctl, timers)
- Docker et Timeshift
- 12 flows de dépannage pour problèmes courants
- Commande `/manjaro` intégrée (check, install, rescue)

## Pourquoi c'est important

Je suis peut-être "old school" (Mandrake en 2000, c'est dire), mais je n'ai plus envie de passer mes soirées à debugger des conflits de dépendances.

Ce skill me permet de rester sur Manjaro — une distro que j'aime — sans les migraines.

## Le lien avec mon travail

En tant que PM/PSM, je travaille avec des développeurs qui utilisent aussi Linux. Ce skill n'est pas juste pour moi — c'est un outil pour tous ceux qui veulent utiliser l'IA avec un système Arch-based sans avoir à corriger les bêtises de l CLI à chaque commande.

## Et sinon...

Je suis aussi l'auteur de [leadminer.io](https://leadminer.io) — une interface d'administration pour la génération de leads B2B.

---

**Le skill est open source (GPL-3.0) :**

🔗 [github.com/ankaboot-source/manjaro-skill](https://github.com/ankaboot-source/manjaro-skill)
📦 `npx skills add ankaboot-source/manjaro-skill`

---

#linux #manjaro #archlinux #ia #ai #productmanagement #opensources #développement
