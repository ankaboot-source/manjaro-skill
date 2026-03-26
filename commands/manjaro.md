---
description: "Manjaro system admin: health check, smart install, troubleshooting"
allowed-tools: ["Bash", "Read"]
---

# /manjaro

Unified Manjaro Linux system administration command. Parse `$ARGUMENTS` to determine
which subcommand to run.

## Routing

- **No arguments or `help`**: Show the help message below and stop.
- **`check`**: Run the [System Health Check](#check).
- **`install <package>`**: Run the [Smart Installer](#install).
- **`rescue <symptoms>`**: Run the [Guided Troubleshooting](#rescue).
- **Anything else**: Show the help message and suggest the closest subcommand.

## Help Message

```
/manjaro — Manjaro Linux system administration

Subcommands:
  /manjaro check                System health check (disk, services, updates, kernels)
  /manjaro install <package>    Smart package installer (pacman/AUR-first)
  /manjaro rescue <symptoms>    Guided troubleshooting from symptom description
  /manjaro help                 Show this message
```

---

## check

Run these commands and present results as a formatted health summary:

```bash
# OS and kernel
uname -r
grep PRETTY_NAME /etc/os-release

# Disk usage (warn if any partition >85%)
df -h / /home /boot /boot/efi 2>/dev/null

# Failed systemd units
systemctl --failed --no-pager

# Pending updates
checkupdates 2>/dev/null | wc -l

# Orphaned packages
pacman -Qtdq 2>/dev/null | wc -l

# Journal disk usage (warn if >500MB)
journalctl --disk-usage 2>/dev/null

# Installed kernels
mhwd-kernel -li 2>/dev/null

# Timeshift snapshots (last one, warn if >7 days old)
sudo timeshift --list 2>/dev/null | tail -5
```

Format output as a summary table with status indicators:
- Items in good shape: state the value
- Items needing attention: flag them and suggest the fix command

Example suggestions:
- Orphans > 0: "Run `sudo pacman -Rns $(pacman -Qtdq)` to clean up"
- Journal > 500MB: "Run `sudo journalctl --vacuum-size=500M`"
- No recent snapshot: "Run `sudo timeshift --create --comments 'periodic'`"
- Updates available: "Run `sudo pacman -Syu` (create a snapshot first)"
- Failed services: list them and suggest `journalctl -u <unit> -b` for each

---

## install

Smart package installer that enforces the pacman/AUR-first resolution hierarchy.

Given `$ARGUMENTS` with `install` removed, the remaining text is the package name(s).

### Step 1: Search official repos

```bash
pacman -Ss <package>
```

Present any matches found, highlighting exact name matches.

### Step 2: Search AUR

```bash
yay -Ss <package>
```

Present AUR results separately from repo results.

### Step 3: Present findings and recommend

Show results organized by source:

```
Found in official repos:
  extra/package-name 1.2.3 — Description
  
Found in AUR:
  aur/package-name-bin 1.2.3 — Description (votes: 42, popularity: 1.5)
```

Recommend the best option following this priority:
1. Official repo match (prefer `extra` over `community`)
2. AUR match (prefer `-bin` variants for large packages)

If nothing found in repos or AUR, suggest the language-specific alternative with
proper isolation:
- Python: `python -m venv .venv && source .venv/bin/activate && pip install <pkg>`
- Node.js: `npm install <pkg>` (local only, never `-g`)
- Other: explain the isolated install approach

### Step 4: Confirm and install

Ask the user to confirm which package to install. Only after confirmation, run:

```bash
# For repo packages:
sudo pacman -S <package>

# For AUR packages:
yay -S <package>
```

If the user wants multiple packages, handle them in a single command.

---

## rescue

Guided troubleshooting based on free-text symptom description.

### Step 1: Read the troubleshooting guide

Read `references/troubleshooting.md` from the manjaro skill directory.

### Step 2: Match symptoms

Interpret the user's symptom description and match it to the closest issue in the
troubleshooting guide. The 12 documented issues are:

1. Broken system after update (partial upgrade, library errors)
2. No GUI after reboot (GPU/driver issues, black screen)
3. pacman lock file stuck
4. Filesystem corruption (read-only, I/O errors)
5. Boot failures (GRUB rescue, kernel panic)
6. Dependency conflicts (file conflicts, version conflicts)
7. Keyring / signature errors
8. No sound after update
9. Network not working
10. Broken permissions
11. Disk space full
12. Time/clock issues

### Step 3: Walk through the fix

Follow the structured flow from the guide:
1. Confirm the symptoms match
2. Run the diagnostic commands
3. Present the diagnosis
4. Walk through the fix steps one at a time
5. Verify the fix worked

If symptoms don't clearly match any documented issue, run the general diagnostic
commands from the guide and help narrow down the problem interactively.
