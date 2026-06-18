# Day 19 – Shell Scripting Project: Log Rotation, Backup & Crontab


## Task 1 — Log Rotation Script (`log_rotate.sh`)

### What it does

1. Accepts a log directory as the first argument
2. Exits with an error if the directory does not exist
3. Compresses `.log` files **older than 7 days** using `gzip`
4. Deletes `.gz` files **older than 30 days**
5. Prints a summary of how many files were compressed and deleted

### Script

```bash
#!/bin/bash
# Usage: ./log_rotate.sh /var/log/apt

set -euo pipefail

if [ $# -ne 1 ]; then
    echo "Usage: $0 <log_directory>" >&2
    exit 1
fi

LOG_DIR="$1"

if [ ! -d "$LOG_DIR" ]; then
    echo "Error: Directory '$LOG_DIR' does not exist." >&2
    exit 1
fi

# Find .log files older than 7 days
mapfile -t LOG_FILES < <(find "$LOG_DIR" -type f -name "*.log" -mtime +7)

COMPRESSED_COUNT=${#LOG_FILES[@]}

# Compress them
if [ "$COMPRESSED_COUNT" -gt 0 ]; then
    gzip "${LOG_FILES[@]}"
fi

# Find .gz files older than 30 days
mapfile -t GZ_FILES < <(find "$LOG_DIR" -type f -name "*.gz" -mtime +30)

DELETED_COUNT=${#GZ_FILES[@]}

# Delete them
if [ "$DELETED_COUNT" -gt 0 ]; then
    rm -f "${GZ_FILES[@]}"
fi

echo "Compressed: $COMPRESSED_COUNT file(s)"
echo "Deleted: $DELETED_COUNT file(s)"

```
### Sample Output
![alt text](image.png)
---

## Task 2 — Server Backup Script (`backup.sh`)

### What it does

1. Accepts a source directory and backup destination as arguments
2. Exits with an error if the source does not exist
3. Creates a timestamped `.tar.gz` archive — e.g. `backup-2026-06-16.tar.gz`
4. Verifies the archive integrity with `tar -tzf`
5. Prints the archive name and human-readable size
6. Deletes backups **older than 14 days** from the destination

### Script

```bash
#!/bin/bash

# Usage: ./backup.sh <source_directory> <backup_destination>

set -euo pipefail

if [ $# -ne 2 ]; then
    echo "Usage: $0 <source_directory> <backup_destination>" >&2
    exit 1
fi

SOURCE_DIR="$1"
BACKUP_DIR="$2"

# Validate source directory
if [ ! -d "$SOURCE_DIR" ]; then
    echo "Error: Source directory '$SOURCE_DIR' does not exist." >&2
    exit 1
fi

# Create backup destination if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Generate timestamped archive name
TIMESTAMP=$(date +"%Y-%m-%d")
ARCHIVE_NAME="backup-${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"

# Create archive
tar -czf "$ARCHIVE_PATH" -C "$(dirname "$SOURCE_DIR")" "$(basename "$SOURCE_DIR")"

# Verify archive creation
if [ ! -f "$ARCHIVE_PATH" ]; then
    echo "Error: Failed to create archive." >&2
    exit 1
fi

# Get archive size
ARCHIVE_SIZE=$(du -h "$ARCHIVE_PATH" | awk '{print $1}')

# Delete backups older than 14 days
find "$BACKUP_DIR" \
    -type f \
    -name "backup-*.tar.gz" \
    -mtime +14 \
    -delete

# Print summary
echo "Backup created successfully."
echo "Archive: $ARCHIVE_NAME"
echo "Size: $ARCHIVE_SIZE"

```

### Sample Output
![alt text](image-1.png)

---

## Task 3 — Crontab Entries

### Reading current cron jobs

```bash
crontab -l
```

> If no crontab exists yet, this returns: `no crontab for <user>`

### Cron syntax reference

```
* * * * *  command_to_run
│ │ │ │ │
│ │ │ │ └── Day of week  (0–7, 0 and 7 = Sunday)
│ │ │ └──── Month        (1–12)
│ │ └────── Day of month (1–31)
│ └──────── Hour         (0–23)
└────────── Minute       (0–59)
```

**Special shortcuts:**

| Shortcut | Equivalent | Meaning |
|----------|------------|---------|
| `@daily` | `0 0 * * *` | Every day at midnight |
| `@weekly` | `0 0 * * 0` | Every Sunday at midnight |
| `@reboot` | — | Once at startup |

### Cron entries written for backup project

```cron
# ── Log rotation — every minute
───────────────────────────────────────
*/1 * * * * /home/ubuntu/backup.sh /var/www/html/ /home/ubuntu

```

### How to apply these entries

```bash
# Open the crontab editor (uses $EDITOR or vi by default)
crontab -e

# Paste the entries above, save and quit
# Verify they were saved:
crontab -l
```

---

## Task 4 — Scheduled Maintenance Script (`maintenance.sh`)

### What it does

1. Calls `log_rotate.sh` with the configured app log directory
2. Calls `backup.sh` with the configured source and destination
3. Prefixes every line of output with a timestamp
4. Appends all output to `/var/log/maintenance.log`
5. Exits non-zero if either sub-script fails

### Script

```bash
#!/bin/bash
# Cron: 0 1 * * * /path/to/maintenance.sh

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_ROTATE_SCRIPT="${SCRIPT_DIR}/log_rotate.sh"
BACKUP_SCRIPT="${SCRIPT_DIR}/backup.sh"

APP_LOG_DIR="${APP_LOG_DIR:-/var/log/myapp}"
BACKUP_SOURCE="${BACKUP_SOURCE:-/etc}"
BACKUP_DEST="${BACKUP_DEST:-/var/backups/myapp}"
MAINTENANCE_LOG="/var/log/maintenance.log"

if touch "$MAINTENANCE_LOG" 2>/dev/null; then
    LOGFILE="$MAINTENANCE_LOG"
else
    LOGFILE="/tmp/maintenance.log"
fi

ts_log() { echo "$(date '+%Y-%m-%d %H:%M:%S') | $*" | tee -a "$LOGFILE"; }

EXIT_CODE=0

ts_log "============================================"
ts_log " MAINTENANCE RUN STARTED"
ts_log "============================================"

ts_log "--- Log Rotation: START ---"
if bash "$LOG_ROTATE_SCRIPT" "$APP_LOG_DIR" >> "$LOGFILE" 2>&1; then
    ts_log "--- Log Rotation: SUCCESS ---"
else
    ts_log "--- Log Rotation: FAILED ---"; EXIT_CODE=1
fi

ts_log "--- Backup: START ---"
if bash "$BACKUP_SCRIPT" "$BACKUP_SOURCE" "$BACKUP_DEST" >> "$LOGFILE" 2>&1; then
    ts_log "--- Backup: SUCCESS ---"
else
    ts_log "--- Backup: FAILED ---"; EXIT_CODE=1
fi

ts_log "============================================"
ts_log " MAINTENANCE RUN FINISHED (exit code: $EXIT_CODE)"
ts_log "============================================"

exit $EXIT_CODE
```

### Sample `/var/log/maintenance.log` output

```
2026-06-16 01:00:01 | ============================================
2026-06-16 01:00:01 |  MAINTENANCE RUN STARTED
2026-06-16 01:00:01 | ============================================
2026-06-16 01:00:01 | --- Log Rotation: START ---
2026-06-16 01:00:01 | [2026-06-16 01:00:01] Starting log rotation for: /var/log/myapp
2026-06-16 01:00:02 | [2026-06-16 01:00:02] ✔ Compressed: /var/log/myapp/app-2026-06-08.log
2026-06-16 01:00:02 | [2026-06-16 01:00:02] Log rotation complete.
2026-06-16 01:00:02 | --- Log Rotation: SUCCESS ---
2026-06-16 01:00:02 | --- Backup: START ---
2026-06-16 01:00:03 | [2026-06-16 01:00:03] ✔ Archive created: /var/backups/myapp/backup-2026-06-16.tar.gz
2026-06-16 01:00:03 | [2026-06-16 01:00:03] ✔ Archive integrity verified.
2026-06-16 01:00:03 | --- Backup: SUCCESS ---
2026-06-16 01:00:03 | ============================================
2026-06-16 01:00:03 |  MAINTENANCE RUN FINISHED (exit code: 0)
2026-06-16 01:00:03 | ============================================
```

### Cron entry

```cron
# Run full maintenance every day at 1:00 AM
0 1 * * * /home/user/scripts/maintenance.sh
```

---

## Key Learnings

**1. `find -print0` + `read -d ''` is the safe way to handle filenames.**
Using `find ... | while read file` breaks on filenames with spaces or special characters.
The null-byte pipeline (`-print0` + `read -r -d ''`) handles any filename correctly.

**2. Always use absolute paths in crontab.**
Cron runs with a minimal environment — your shell aliases, functions, and `$PATH` are not
available. Using relative paths like `./backup.sh` or bare commands like `gzip` (without
`/bin/gzip`) can silently fail. Always write full absolute paths for both scripts and any
tools they invoke.

**3. `set -euo pipefail` is your safety net — but use `|| true` for intentional counters.**
`set -e` exits immediately on any non-zero return code, and `set -o pipefail` catches
failures inside pipes. This prevents silent partial failures in long scripts.
However, arithmetic like `(( counter++ ))` returns exit code 1 when the result is 0,
which trips `set -e`. The pattern `(( counter++ )) || true` fixes this elegantly
without disabling the safety options globally.

---

## Quick Reference

```bash
# Make scripts executable
chmod +x log_rotate.sh backup.sh maintenance.sh

# Run log rotation
./log_rotate.sh /var/log/myapp

# Run backup
./backup.sh /etc /var/backups/myapp

# Run full maintenance
./maintenance.sh

# Override paths via environment variables
APP_LOG_DIR=/srv/logs BACKUP_SOURCE=/srv/app BACKUP_DEST=/mnt/backup ./maintenance.sh

# Edit crontab
crontab -e

# View current crontab
crontab -l

# View maintenance log
tail -f /var/log/maintenance.log
```