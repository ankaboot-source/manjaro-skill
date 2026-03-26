# systemd Recipes

Unit file templates, timer syntax, journal management, boot analysis, and hardening.

## Table of Contents

1. [Service Types](#service-types)
2. [Unit File Templates](#unit-file-templates)
3. [User Services](#user-services)
4. [Timer Units](#timer-units)
5. [Journal Management](#journal-management)
6. [Boot Analysis](#boot-analysis)
7. [Service Hardening](#service-hardening)
8. [Drop-In Overrides](#drop-in-overrides)
9. [Dependency and Ordering](#dependency-and-ordering)
10. [Other Unit Types](#other-unit-types)

---

## Service Types

| Type       | Behavior                                                         |
|------------|------------------------------------------------------------------|
| `simple`   | Default. ExecStart process IS the main process.                  |
| `exec`     | Like simple, but waits for binary to execute (not just fork).    |
| `forking`  | Process forks and parent exits. Use PIDFile to track.            |
| `oneshot`  | Runs to completion. Good for scripts.                            |
| `notify`   | Process sends sd_notify() when ready. Best for aware daemons.    |
| `dbus`     | Ready when BusName appears on D-Bus.                             |
| `idle`     | Like simple, delayed until all jobs are done.                    |

---

## Unit File Templates

### Basic Daemon (simple)

```ini
# /etc/systemd/system/my-daemon.service
[Unit]
Description=My Custom Daemon
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
ExecStart=/usr/local/bin/my-daemon --config /etc/my-daemon.conf
Restart=on-failure
RestartSec=5
User=myuser
Group=mygroup

NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/var/lib/my-daemon

[Install]
WantedBy=multi-user.target
```

### One-Shot (run once)

```ini
# /etc/systemd/system/my-task.service
[Unit]
Description=Run a one-time task
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/my-script.sh
RemainAfterExit=no
User=root

[Install]
WantedBy=multi-user.target
```

### Forking Daemon (legacy)

```ini
# /etc/systemd/system/legacy-daemon.service
[Unit]
Description=Legacy Forking Daemon
After=network.target

[Service]
Type=forking
PIDFile=/var/run/legacy-daemon.pid
ExecStart=/usr/sbin/legacy-daemon -d
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

### Web Application (Node.js / Go / Python)

```ini
# /etc/systemd/system/webapp.service
[Unit]
Description=My Web Application
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=webapp
Group=webapp
WorkingDirectory=/opt/webapp
ExecStart=/opt/webapp/server --port 8080
Restart=always
RestartSec=5

Environment=NODE_ENV=production
EnvironmentFile=-/opt/webapp/.env

LimitNOFILE=65536

NoNewPrivileges=true
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/webapp/data /var/log/webapp
PrivateTmp=true

StandardOutput=journal
StandardError=journal
SyslogIdentifier=webapp

[Install]
WantedBy=multi-user.target
```

### Docker Container as Service

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
ExecStartPre=-/usr/bin/docker stop my-container
ExecStartPre=-/usr/bin/docker rm my-container
ExecStart=/usr/bin/docker run --name my-container \
    -p 8080:8080 \
    -v /opt/data:/data \
    --rm \
    my-image:latest
ExecStop=/usr/bin/docker stop my-container

[Install]
WantedBy=multi-user.target
```

---

## User Services

Place in `~/.config/systemd/user/`. No sudo needed.

### Template

```ini
# ~/.config/systemd/user/my-app.service
[Unit]
Description=My User Application
After=default.target

[Service]
Type=simple
ExecStart=%h/bin/my-app
Restart=on-failure
RestartSec=5
Environment=HOME=%h
Environment=MY_VAR=value

[Install]
WantedBy=default.target
```

### Management

```bash
systemctl --user daemon-reload               # reload after editing
systemctl --user enable --now my-app.service # enable + start
systemctl --user start/stop/restart my-app   # control
systemctl --user status my-app               # status
journalctl --user -u my-app -f              # follow logs
```

### Linger (keep running after logout)

```bash
sudo loginctl enable-linger $USER            # enable
sudo loginctl disable-linger $USER           # disable
loginctl show-user $USER | grep Linger       # check
```

---

## Timer Units

Each timer needs a matching `.service` unit with the same name.

### Periodic Timer

```ini
# ~/.config/systemd/user/backup.timer
[Unit]
Description=Run backup every 6 hours

[Timer]
OnCalendar=*-*-* 00/6:00:00
Persistent=true
RandomizedDelaySec=300

[Install]
WantedBy=timers.target
```

```ini
# ~/.config/systemd/user/backup.service
[Unit]
Description=Backup task

[Service]
Type=oneshot
ExecStart=%h/scripts/backup.sh
```

### OnCalendar Syntax

```
*-*-* 00:00:00           # daily at midnight
Mon *-*-* 09:00:00       # every Monday at 9am
*-*-01 00:00:00          # first day of every month
*-*-* *:00/15:00         # every 15 minutes
hourly                   # shorthand
daily                    # shorthand
weekly                   # shorthand (Mon 00:00)
monthly                  # shorthand (1st 00:00)
```

```bash
# Test expressions
systemd-analyze calendar "Mon *-*-* 09:00:00"
systemd-analyze calendar --iterations=5 "hourly"
```

### Monotonic Timer (relative to boot)

```ini
[Timer]
OnBootSec=15min
OnUnitActiveSec=1h
Persistent=true
```

### Timer Fields

| Field                  | Description                                    |
|------------------------|------------------------------------------------|
| `OnCalendar=`          | Wallclock schedule                             |
| `OnBootSec=`           | Time after boot                                |
| `OnStartupSec=`        | Time after systemd started                     |
| `OnUnitActiveSec=`     | Time after service last activated              |
| `OnUnitInactiveSec=`   | Time after service last deactivated            |
| `Persistent=true`      | Catch up missed runs                           |
| `RandomizedDelaySec=`  | Random delay (avoid thundering herd)           |
| `AccuracySec=`         | Timer accuracy (default 1min)                  |

### Managing Timers

```bash
systemctl list-timers --all                  # all timers with next/last
systemctl --user list-timers                 # user timers
systemctl enable --now backup.timer          # enable + start
systemctl start backup.service               # trigger manually
```

---

## Journal Management

### Viewing Logs

```bash
# By unit
journalctl -u <unit>                        # all logs
journalctl -u <unit> -f                     # follow (tail)
journalctl -u <unit> -n 50                  # last 50 lines
journalctl -u <unit> --since "1 hour ago"   # time-filtered

# By priority
journalctl -p err                            # errors and above
journalctl -p warning                        # warnings and above

# By boot
journalctl -b                                # current boot
journalctl -b -1                             # previous boot
journalctl --list-boots                      # all boots

# Kernel messages
journalctl -k                                # like dmesg
journalctl -k -b -1                          # kernel msgs from last boot

# By process
journalctl _PID=1234
journalctl _EXE=/usr/bin/nginx
journalctl _UID=1000

# Output formats
journalctl -o json-pretty                    # JSON
journalctl -o short-iso                      # ISO timestamps
journalctl -o cat                            # message only
```

### Disk Management

```bash
journalctl --disk-usage                      # current size
sudo journalctl --vacuum-size=500M           # shrink to 500MB
sudo journalctl --vacuum-time=2weeks         # remove older than 2 weeks
sudo journalctl --rotate                     # force rotation
```

### Persistent Config (`/etc/systemd/journald.conf`)

```ini
[Journal]
SystemMaxUse=500M
SystemMaxFileSize=50M
MaxRetentionSec=1month
Compress=yes
Storage=persistent
```

After editing: `sudo systemctl restart systemd-journald`

---

## Boot Analysis

```bash
systemd-analyze                              # total boot time
systemd-analyze blame                        # time per unit (slowest first)
systemd-analyze critical-chain               # critical path
systemd-analyze critical-chain sshd.service  # what delayed specific service
systemd-analyze plot > boot.svg              # visual boot chart
systemd-analyze verify my.service            # validate unit file
systemd-analyze security my.service          # security audit
```

---

## Service Hardening

Apply in the `[Service]` section:

```ini
# Filesystem
ProtectSystem=strict                # / as read-only
ProtectHome=true                    # hide /home
ReadWritePaths=/var/lib/myapp       # whitelist writable
PrivateTmp=true                     # isolated /tmp

# Privileges
NoNewPrivileges=true                # prevent escalation
CapabilityBoundingSet=CAP_NET_BIND_SERVICE

# Network
PrivateNetwork=true                 # no network
RestrictAddressFamilies=AF_INET AF_INET6

# System calls
SystemCallFilter=@system-service
SystemCallArchitectures=native

# Other
ProtectKernelTunables=true
ProtectKernelModules=true
ProtectControlGroups=true
MemoryDenyWriteExecute=true
LockPersonality=true
```

Audit: `systemd-analyze security my.service` (score 0=best, 10=worst).

---

## Drop-In Overrides

Override parts of a unit without editing the original:

```bash
sudo systemctl edit my.service               # creates drop-in
# Creates: /etc/systemd/system/my.service.d/override.conf
```

```ini
[Service]
Environment=MY_VAR=new-value
RestartSec=10
```

To replace a field, clear it first:

```ini
[Service]
ExecStart=                                   # clear original
ExecStart=/new/path/to/binary                # set new
```

---

## Dependency and Ordering

```ini
[Unit]
# Ordering
After=network-online.target          # start after
Before=httpd.service                 # start before

# Dependencies
Requires=postgresql.service          # hard dep (fail if postgres fails)
Wants=redis.service                  # soft dep (don't fail)
BindsTo=docker.service               # stop if docker stops
PartOf=app.target                    # stop/restart with target

# Conflict
Conflicts=other.service              # cannot coexist
```

---

## Other Unit Types

### Mount Unit

```ini
# /etc/systemd/system/mnt-data.mount
# Name must match path: mnt-data = /mnt/data
[Unit]
Description=Mount Data Drive

[Mount]
What=/dev/disk/by-uuid/xxxx
Where=/mnt/data
Type=ext4
Options=defaults,noatime

[Install]
WantedBy=multi-user.target
```

### Path Unit (file watcher)

```ini
# /etc/systemd/system/deploy-watch.path
[Unit]
Description=Watch for deploy trigger

[Path]
PathChanged=/opt/deploy/trigger
MakeDirectory=yes

[Install]
WantedBy=multi-user.target
```

### Socket Activation

```ini
# /etc/systemd/system/my-app.socket
[Unit]
Description=My App Socket

[Socket]
ListenStream=8080
Accept=no

[Install]
WantedBy=sockets.target
```

Service starts only when a connection arrives on port 8080 — zero resources when idle.

### Custom Target (group services)

```ini
# /etc/systemd/system/my-stack.target
[Unit]
Description=My Application Stack
Requires=webapp.service worker.service
After=webapp.service worker.service

[Install]
WantedBy=multi-user.target
```
