---
name: manjaro
description: >-
  Manjaro Linux system administration skill. Use this skill whenever the user asks about
  installing packages, managing services, configuring their system, maintaining or
  troubleshooting Manjaro or Arch Linux, or when you detect the host is Manjaro/Arch.
  Trigger on mentions of pacman, yay, makepkg, PKGBUILD, systemctl, journalctl, mhwd,
  mkinitcpio, grub, manjaro-chroot, arch-chroot, timeshift, btrfs snapshots, pamac,
  pacman.conf, mirrorlist, or any Arch/Manjaro system task. Also trigger when the user
  wants to install software (npm/pip/cargo global tools, CLI utilities, system packages)
  on a Manjaro system — this skill enforces pacman/AUR-first package resolution.
---

# Manjaro Linux System Administration

Manjaro is a rolling-release distribution based on Arch Linux. It uses pacman for package
management, systemd for services, and adds its own tools for hardware detection (mhwd)
and kernel management. This skill ensures you always prefer native Manjaro tools over
generic cross-platform alternatives.

## ⚠️ Safety Principle: User Control

**This skill helps the AI suggest correct Manjaro commands. You retain full control.**

### Permission Configuration (Recommended)

Add this to your OpenCode config (`~/.config/opencode/opencode.json`) to require approval for system changes:

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
- `sudo pacman -S ...`, `yay -S ...` → **requires approval** ("ask")
- Search queries (`pacman -Ss`, `yay -Ss`) → **auto-allow**
- Status checks, logs, git → **auto-allow**

### General Safety Guidelines

When suggesting commands that modify the system:

1. **Always explain** what the command will do before running it
2. **Warn about consequences** (e.g., "This will remove package X and its dependencies")
3. **Create snapshots** before risky operations (see Timeshift section)
4. **Prefer reversible operations** when possible

## Core Principle: Pacman First

On a Manjaro system, **always prefer native package management** over language-specific
installers. This avoids version conflicts, ensures system-wide updates catch everything,
and keeps the system clean.

### Package Resolution Decision Tree

When the user needs to install software, follow this order:

```
1. Is it available via pacman?
   $ pacman -Ss <name>
   YES -> sudo pacman -S <package>
   NO  -> go to step 2

2. Is it available in the AUR?
   $ yay -Ss <name>
   YES -> yay -S <package>
   NO  -> go to step 3

3. Use language-specific installer IN ISOLATION ONLY:
   - pip:   python -m venv .venv && source .venv/bin/activate && pip install <pkg>
   - npm:   npm install <pkg>            (local node_modules, NEVER npm -g)
   - cargo: cargo install <pkg>          (goes to ~/.cargo/bin)
   - go:    go install <pkg>@latest      (goes to ~/go/bin)

NEVER: sudo pip install, sudo npm install -g, or any global language-specific install.
Global CLI tools MUST come from pacman or AUR.
```

### Common Equivalence: Generic -> Manjaro

| Instead of...                | Use...                          |
|-----------------------------|----------------------------------|
| `brew install htop`         | `sudo pacman -S htop`           |
| `snap install code`         | `yay -S visual-studio-code-bin`  |
| `curl -fsSL ... \| sh`     | Check `pacman -Ss` / `yay -Ss` first |
| `npm -g install neovim`    | `sudo pacman -S neovim`         |
| `cargo install fd`          | `sudo pacman -S fd`              |
| `pip install httpie`       | `sudo pacman -S httpie`          |

For the full equivalence table and command reference, read `references/packages.md`.

## Package Management Quick Reference

```bash
# Install / Remove
sudo pacman -S <pkg>                # install from repos
sudo pacman -S --needed <pkg>       # skip if already current (idempotent)
sudo pacman -Rs <pkg>               # remove + unused deps
sudo pacman -Rns <pkg>              # remove + deps + config (cleanest)

# Search / Info
pacman -Ss <query>                  # search remote repos
pacman -Qs <query>                  # search installed
pacman -Qi <pkg>                    # installed package info
pacman -Qo /path/to/file           # which package owns this file

# System Update (ALWAYS full upgrade, never partial)
sudo pacman -Syu                    # sync + full upgrade
sudo pacman -Syyu                   # force refresh + upgrade (after mirror change)

# AUR with yay
yay -S <pkg>                        # install from AUR or repos
yay -Ss <query>                     # search repos + AUR
yay -Sua                            # upgrade AUR packages only
yay -Syu                            # upgrade everything
```

**Critical rule:** Never run `pacman -Sy <package>` — this causes partial upgrades and
breaks shared library dependencies. Always use `-Syu`.

## systemd Services

```bash
sudo systemctl start/stop/restart <unit>     # immediate control
sudo systemctl enable --now <unit>           # enable at boot + start now
sudo systemctl disable <unit>                # disable at boot
systemctl status <unit>                      # status + recent logs
systemctl --failed                           # list failed units
journalctl -u <unit> -f                      # follow logs for a unit
journalctl -p err -b                         # all errors since boot
```

For unit file templates (daemon, oneshot, timer, user service, Docker container, socket
activation), hardening directives, and timer syntax, read `references/systemd-recipes.md`.

## Docker

Docker is the container runtime on this system. Do NOT suggest Podman.

### Setup

```bash
sudo pacman -S docker docker-compose
sudo systemctl enable --now docker
sudo usermod -aG docker $USER
# Log out and back in for group membership to take effect
```

### Common Operations

```bash
docker ps                                    # running containers
docker compose up -d                         # start stack (detached)
docker compose down                          # stop stack
docker compose logs -f <service>             # follow service logs
docker system prune -a                       # reclaim disk space
docker volume ls                             # list volumes
```

### Docker as systemd Service

To run a container as a system service, create a unit file:

```ini
# /etc/systemd/system/my-container.service
[Unit]
Description=My Docker Container
After=docker.service
Requires=docker.service

[Service]
Type=simple
Restart=always
RestartSec=10
ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStart=/usr/bin/docker run --name %n \
    -p 8080:8080 \
    -v /opt/data:/data \
    --rm \
    my-image:latest
ExecStop=/usr/bin/docker stop %n

[Install]
WantedBy=multi-user.target
```

## Timeshift & Btrfs Snapshots

This system uses Timeshift on Btrfs for snapshots.

### Create Snapshots

```bash
# Manual snapshot (always before risky operations)
sudo timeshift --create --comments "before update"

# List existing snapshots
sudo timeshift --list

# Restore a snapshot (interactive)
sudo timeshift --restore
```

### Btrfs Direct Operations

```bash
sudo btrfs subvolume list /                  # list subvolumes
sudo btrfs subvolume snapshot / /mnt/@snap-$(date +%F)  # manual snapshot
sudo btrfs scrub start /                     # verify data integrity
sudo btrfs filesystem usage /                # detailed space report
```

### When to Snapshot

Always create a snapshot before:
- System updates (`pacman -Syu`)
- Kernel changes (`mhwd-kernel -i/-r`)
- GPU driver changes (`mhwd -i/-r`)
- Major configuration changes (GRUB, mkinitcpio, fstab)

## System Configuration

### pacman.conf (`/etc/pacman.conf`)

Key settings to know:

```ini
[options]
ParallelDownloads = 5          # concurrent downloads (default 1)
Color                          # colorized output
CheckSpace                     # verify disk space before install
IgnorePkg = <pkg1> <pkg2>      # hold packages from upgrading
```

Enable `[multilib]` for 32-bit support (Steam, Wine).

### Mirror Management

```bash
sudo pacman-mirrors --fasttrack 5           # top 5 fastest mirrors
sudo pacman-mirrors --geoip                 # mirrors by geolocation
sudo pacman -Syyu                           # ALWAYS refresh after mirror change
```

### Kernel Management (Manjaro-specific)

```bash
mhwd-kernel -li                              # list installed kernels
mhwd-kernel -l                               # list available kernels
sudo mhwd-kernel -i linux610                 # install kernel 6.10
sudo mhwd-kernel -r linux66                  # remove old kernel
```

Always keep at least two kernels installed as fallback.

### Hardware Detection (mhwd)

```bash
mhwd -li                                     # installed drivers
mhwd -l                                      # available drivers
sudo mhwd -a pci nonfree 0300               # auto-install GPU driver
```

## System Maintenance

### Regular Maintenance Checklist

```bash
# 1. Create snapshot before updating
sudo timeshift --create --comments "pre-update"

# 2. Full system update
sudo pacman -Syu

# 3. Update AUR packages
yay -Sua

# 4. Remove orphaned packages
sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null

# 5. Clean package cache (keep last 3 versions)
paccache -r                                  # needs pacman-contrib

# 6. Check for failed services
systemctl --failed

# 7. Manage journal size
journalctl --disk-usage
sudo journalctl --vacuum-size=500M

# 8. Handle .pacnew config files
sudo pacdiff                                 # from pacman-contrib
```

### Health Check Commands

```bash
uname -r                                     # current kernel
df -h / /home /boot                          # disk usage
free -h                                      # memory
systemctl --failed                           # failed services
pacman -Qtdq | wc -l                         # orphan count
journalctl --disk-usage                      # journal size
checkupdates | wc -l                         # pending updates
```

## Pre-Destructive Operation Checklist

Before any operation that could break the system, run through this:

```
[ ] Timeshift snapshot created?
    sudo timeshift --create --comments "before <operation>"
[ ] At least 2 kernels installed?
    mhwd-kernel -li
[ ] Current state is bootable?
    Test with: systemctl is-system-running
[ ] Network available for recovery packages?
    ping -c 1 archlinux.org
[ ] Know how to chroot from live USB?
    Boot live USB -> sudo manjaro-chroot -a
```

**Operations that require this checklist:**
- `pacman -Syu` (major updates with kernel/driver changes)
- `mhwd-kernel -i/-r` (kernel install/remove)
- `mhwd -i/-r` (GPU driver changes)
- `grub-mkconfig`, `mkinitcpio -P`
- Editing `/etc/fstab`, `/etc/mkinitcpio.conf`, `/etc/default/grub`

## Troubleshooting Quick Reference

For full diagnosis-to-fix flows covering 12 common scenarios (broken updates, GPU issues,
lock files, filesystem corruption, boot failures, dependency conflicts, keyring problems,
sound/network issues, permissions, disk space, clock), read `references/troubleshooting.md`.

### Emergency Recovery (from live USB)

```bash
# 1. Boot Manjaro live USB
# 2. Auto-detect and chroot into installed system
sudo manjaro-chroot -a

# 3. Inside chroot — common fixes:
pacman -Syu                                  # complete interrupted upgrade
mkinitcpio -P                                # rebuild initramfs
grub-mkconfig -o /boot/grub/grub.cfg         # fix GRUB

# 4. Exit and reboot
exit
reboot
```

## Reference Files

Read these on-demand when you need detailed information:

- **`references/packages.md`** — Full pacman/yay command reference, advanced queries,
  cache management, makepkg config, package groups, downgrading, useful one-liners,
  complete generic-to-manjaro equivalence tables.
- **`references/systemd-recipes.md`** — Unit file templates for every service type,
  timer syntax and examples, journal management, boot analysis, security hardening,
  drop-in overrides, dependency ordering.
- **`references/troubleshooting.md`** — 12 common issues with structured
  symptoms/diagnosis/fix flows: broken updates, GPU, lock files, filesystem corruption,
  boot failures, dependency conflicts, keyring, sound, network, permissions, disk space,
  clock issues.
