# Manjaro/Arch Troubleshooting Guide

Structured diagnosis-to-fix flows for common issues.

## Table of Contents

1. [Broken System After Update](#1-broken-system-after-update)
2. [No GUI After Reboot (GPU)](#2-no-gui-after-reboot-gpu)
3. [pacman Lock File Stuck](#3-pacman-lock-file-stuck)
4. [Filesystem Corruption](#4-filesystem-corruption)
5. [Boot Failures](#5-boot-failures)
6. [Dependency Conflicts](#6-dependency-conflicts)
7. [Keyring / Signature Errors](#7-keyring--signature-errors)
8. [No Sound After Update](#8-no-sound-after-update)
9. [Network Not Working](#9-network-not-working)
10. [Broken Permissions](#10-broken-permissions)
11. [Disk Space Full](#11-disk-space-full)
12. [Time/Clock Issues](#12-timeclock-issues)
13. [General Diagnostic Commands](#general-diagnostic-commands)

---

## 1. Broken System After Update

**Symptoms:** Libraries not found, apps crash, `error while loading shared libraries`,
package conflicts during upgrade.

**Cause:** `pacman -Sy <package>` (partial upgrade) or interrupted upgrade.

**Fix (if bootable):**

```bash
sudo pacman -Syu                             # complete full upgrade
# If conflicts:
sudo pacman -Syu --overwrite '*'             # force overwrite (last resort)
```

**Fix (from live USB):**

```bash
sudo manjaro-chroot -a                       # auto-detect and chroot
pacman -Syu                                  # complete upgrade
exit && reboot
```

**Persistent conflicts:**

```bash
# Identify conflict
sudo pacman -Syu 2>&1 | grep "conflicting"

# Remove conflicting package, then upgrade
sudo pacman -Rdd <conflicting-pkg>
sudo pacman -Syu
```

---

## 2. No GUI After Reboot (GPU)

**Symptoms:** Black screen, dropped to TTY, display manager fails.

**Diagnosis (from TTY: Ctrl+Alt+F2):**

```bash
systemctl status sddm                        # or gdm, lightdm
journalctl -u sddm -b
mhwd -li                                     # installed drivers
lspci -k | grep -A 3 VGA                     # GPU + loaded module
```

**Fix NVIDIA:**

```bash
sudo mhwd -r pci video-nvidia               # remove broken driver
sudo mhwd -a pci nonfree 0300               # auto-detect + install
sudo mkinitcpio -P                           # rebuild initramfs
sudo reboot
# Verify: nvidia-smi
```

**Fix AMD:**

```bash
sudo mhwd -r pci video-amdgpu               # remove if installed
sudo mhwd -i pci video-linux                 # open-source driver
sudo mkinitcpio -P && sudo reboot
```

**Fallback (software rendering):**

```bash
sudo mhwd -r pci <installed-driver>
sudo mhwd -i pci video-linux
sudo reboot
```

**Wayland issues (fall back to Xorg):**

```bash
# SDDM/KDE: set DisplayServer=x11 in /etc/sddm.conf.d/10-wayland.conf
# GDM/GNOME: set WaylandEnable=false in /etc/gdm/custom.conf
```

---

## 3. pacman Lock File Stuck

**Symptoms:** `unable to lock database`, `/var/lib/pacman/db.lck exists`.

**Fix:**

```bash
# Verify no pacman/pamac is running
ps aux | grep -i pacman
ps aux | grep -i pamac

# If nothing running, remove lock
sudo rm /var/lib/pacman/db.lck
```

**If database corrupted after forced kill:**

```bash
sudo rm -r /var/lib/pacman/sync/
sudo pacman -Syy
```

---

## 4. Filesystem Corruption

**Symptoms:** Read-only filesystem, I/O errors, `structure needs cleaning`.

**ext4 (must be unmounted):**

```bash
sudo umount /dev/sdXn
sudo fsck.ext4 -f /dev/sdXn                  # force check
sudo fsck.ext4 -fy /dev/sdXn                 # auto-repair
```

**Btrfs:**

```bash
sudo btrfs check /dev/sdXn                   # read-only check (safe)
sudo btrfs check --repair /dev/sdXn          # repair (BACKUP FIRST)
sudo btrfs scrub start /                     # integrity scan (runs on mounted fs)
sudo btrfs scrub status /
```

**Root partition read-only — temporary fix:**

```bash
sudo mount -o remount,rw /                   # then run fsck from live USB
```

---

## 5. Boot Failures

### GRUB Rescue

**Symptoms:** `grub rescue>` prompt.

```bash
# From GRUB rescue
ls                                           # list partitions
ls (hd0,gpt2)/boot/grub/                     # find grub
set root=(hd0,gpt2)
set prefix=(hd0,gpt2)/boot/grub
insmod normal
normal                                        # load GRUB menu
```

**Reinstall GRUB from live USB:**

```bash
sudo manjaro-chroot -a
# UEFI:
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=manjaro
grub-mkconfig -o /boot/grub/grub.cfg
# BIOS/MBR:
grub-install --target=i386-pc /dev/sdX
grub-mkconfig -o /boot/grub/grub.cfg
exit && reboot
```

### Kernel Panic

**Symptoms:** `Kernel panic`, `VFS: Unable to mount root fs`.

**Fix:**

```bash
# Boot older kernel from GRUB advanced options
# Then rebuild initramfs:
sudo mkinitcpio -P

# Check /etc/mkinitcpio.conf
# HOOKS should include: base udev autodetect modconf block filesystems keyboard fsck
# MODULES: add 'btrfs' for Btrfs root, 'nvme' for NVMe root

# If kernel broken, install a good one:
sudo mhwd-kernel -i linux610
grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
```

---

## 6. Dependency Conflicts

### File Conflicts

```bash
# "/usr/lib/file exists in filesystem"
pacman -Qo /usr/lib/conflicting-file         # find owner

# If owned by another package — upgrade everything
sudo pacman -Syu

# If owned by no package (manual install)
sudo pacman -S <pkg> --overwrite '/usr/lib/conflicting-file'
```

### Version Conflicts

```bash
# "requires libfoo>=2.0 but installed is 1.9"
sudo pacman -Syu                             # upgrade everything

# Circular dependency:
sudo pacman -Rdd <pkg-with-old-dep>          # force remove
sudo pacman -Syu                             # upgrade
sudo pacman -S <removed-pkg>                 # reinstall
```

---

## 7. Keyring / Signature Errors

**Symptoms:** `invalid or corrupted package`, `GPGME error`, signature failures.

```bash
sudo pacman -Sy archlinux-keyring manjaro-keyring
sudo pacman-key --init
sudo pacman-key --populate archlinux manjaro
sudo pacman-key --refresh-keys
sudo pacman -Syu
```

**If that fails:**

```bash
sudo rm -r /etc/pacman.d/gnupg/
sudo pacman-key --init
sudo pacman-key --populate archlinux manjaro
sudo pacman -Syu
```

---

## 8. No Sound After Update

**Symptoms:** No audio output, PipeWire/PulseAudio crash.

```bash
# Check audio system
pactl info
systemctl --user status pipewire

# Restart PipeWire stack
systemctl --user restart pipewire pipewire-pulse wireplumber

# Check ALSA
aplay -l                                     # list sound cards
alsamixer                                    # check mute/volume

# If PipeWire replaced PulseAudio during update:
sudo pacman -S pipewire-pulse wireplumber
systemctl --user enable --now pipewire pipewire-pulse wireplumber
```

---

## 9. Network Not Working

```bash
# Check NetworkManager
systemctl status NetworkManager
sudo systemctl enable --now NetworkManager

# Check interfaces
ip link show
nmcli device status

# Wi-Fi driver missing after kernel update
lspci -k | grep -A 3 Network
dmesg | grep -i wifi
dmesg | grep -i firmware

# Reinstall firmware
sudo pacman -S linux-firmware
# Broadcom:
sudo pacman -S broadcom-wl-dkms

# DNS issues
resolvectl status
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf  # temporary
```

---

## 10. Broken Permissions

**Symptoms:** Programs fail, `permission denied` on system binaries.

**Cause:** Accidental `chown -R` or `chmod -R` on system directories.

```bash
# Reinstall all packages to restore permissions
sudo pacman -S $(pacman -Qqn)

# Fix specific critical files
sudo chown root:root /usr/bin/sudo
sudo chmod 4755 /usr/bin/sudo

# From live USB if sudo is broken
sudo manjaro-chroot -a
pacman -S $(pacman -Qqn)
exit
```

---

## 11. Disk Space Full

**Symptoms:** `No space left on device`, install fails.

```bash
# Diagnose
df -h
du -sh /* 2>/dev/null | sort -rh | head -20
ncdu /                                       # interactive

# Common hogs
du -sh /var/cache/pacman/pkg/                # pacman cache
du -sh /var/log/journal/                     # journal
du -sh ~/.cache/                             # user cache

# Clean up
sudo paccache -rk 1                          # keep only latest version
sudo journalctl --vacuum-size=100M
sudo pacman -Rns $(pacman -Qtdq) 2>/dev/null # remove orphans
rm -rf ~/.cache/yay/                         # AUR build cache

# Find large files
find / -type f -size +100M 2>/dev/null | head -20
```

---

## 12. Time/Clock Issues

**Symptoms:** Wrong time, dual-boot with Windows shows wrong time.

```bash
timedatectl status

# Enable NTP
sudo timedatectl set-ntp true

# Set timezone
sudo timedatectl set-timezone Europe/Paris
timedatectl list-timezones | grep Europe

# Dual-boot with Windows
# Option A (easiest): tell Linux to use localtime
sudo timedatectl set-local-rtc 1
# Option B (better): tell Windows to use UTC
# Registry: HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation
# Add DWORD: RealTimeIsUniversal = 1
```

---

## General Diagnostic Commands

```bash
# System info
uname -a                                     # kernel version
cat /etc/os-release                          # distro info
hostnamectl                                  # hostname + OS
lscpu                                        # CPU
free -h                                      # memory
uptime                                       # uptime + load

# Hardware
lspci                                        # PCI devices
lsusb                                        # USB devices
lsblk -f                                     # block devices + filesystems
dmesg | tail -50                             # recent kernel messages

# Services
systemctl --failed                           # failed services
systemctl list-units --state=running         # running services

# Logs
journalctl -p err -b                         # errors since boot
journalctl -xe                               # last entries with explanation
```
