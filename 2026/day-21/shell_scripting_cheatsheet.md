# Shell Scripting Cheat Sheet

> A practical quick-reference guide for DevOps engineers. Focus: real examples, minimal theory.

---

## Quick Reference Table

| Topic      | Key Syntax                    | Example                              |
|------------|-------------------------------|--------------------------------------|
| Variable   | `VAR="value"`                 | `NAME="DevOps"`                      |
| Argument   | `$1`, `$2`                    | `./script.sh arg1`                   |
| If         | `if [ condition ]; then`      | `if [ -f file ]; then`               |
| For loop   | `for i in list; do`           | `for i in 1 2 3; do`                 |
| Function   | `name() { ... }`              | `greet() { echo "Hi"; }`             |
| Grep       | `grep pattern file`           | `grep -i "error" log.txt`            |
| Awk        | `awk '{print $1}' file`       | `awk -F: '{print $1}' /etc/passwd`   |
| Sed        | `sed 's/old/new/g' file`      | `sed -i 's/foo/bar/g' config.txt`    |
| Exit code  | `$?`                          | `echo $?` → `0` = success            |
| Trap       | `trap 'fn' EXIT`              | `trap 'cleanup' EXIT`                |

---

## 1. Basics

### Shebang
Tells the OS which interpreter to use. Must be the first line of the script.
```bash
#!/bin/bash
```

### Running a Script
```bash
chmod +x script.sh    # Make executable
./script.sh           # Run directly
bash script.sh        # Run with bash explicitly (no chmod needed)
```

### Comments
```bash
# This is a full-line comment
echo "Hello"  # This is an inline comment
```

### Variables
```bash
NAME="DevOps"          # Declare (no spaces around =)
echo $NAME             # Use (unquoted — word splitting applies)
echo "$NAME"           # Use (quoted — preserves spaces, preferred)
echo '$NAME'           # Literal — prints: $NAME (no expansion)
```

### Reading User Input
```bash
read -p "Enter your name: " USERNAME
echo "Hello, $USERNAME"

read -s -p "Password: " PASS   # -s = silent (for passwords)
```

### Command-Line Arguments
```bash
$0    # Script name
$1    # First argument
$2    # Second argument
$#    # Number of arguments
$@    # All arguments (as separate words)
$?    # Exit code of last command
```

```bash
#!/bin/bash
echo "Script: $0"
echo "First arg: $1"
echo "All args: $@"
echo "Count: $#"
```

---

## 2. Operators and Conditionals

### String Comparisons
```bash
[ "$A" = "$B" ]     # Equal
[ "$A" != "$B" ]    # Not equal
[ -z "$A" ]         # True if empty (zero length)
[ -n "$A" ]         # True if not empty
```

### Integer Comparisons
```bash
[ $A -eq $B ]    # Equal
[ $A -ne $B ]    # Not equal
[ $A -lt $B ]    # Less than
[ $A -gt $B ]    # Greater than
[ $A -le $B ]    # Less than or equal
[ $A -ge $B ]    # Greater than or equal
```

### File Test Operators
```bash
[ -f file ]    # Exists and is a regular file
[ -d dir ]     # Exists and is a directory
[ -e path ]    # Exists (file or dir)
[ -r file ]    # Readable
[ -w file ]    # Writable
[ -x file ]    # Executable
[ -s file ]    # Exists and is non-empty
```

### if / elif / else
```bash
if [ "$1" = "start" ]; then
  echo "Starting..."
elif [ "$1" = "stop" ]; then
  echo "Stopping..."
else
  echo "Unknown command"
fi
```

### Logical Operators
```bash
[ -f file ] && echo "exists"       # AND — run if previous succeeds
[ -f file ] || echo "not found"    # OR  — run if previous fails
[ ! -f file ] && echo "missing"    # NOT
```

### Case Statement
```bash
case "$ENV" in
  prod)
    echo "Production"
    ;;
  dev|staging)
    echo "Non-prod"
    ;;
  *)
    echo "Unknown"
    ;;
esac
```

---

## 3. Loops

### For Loop — List-Based
```bash
for color in red green blue; do
  echo "$color"
done
```

### For Loop — C-Style
```bash
for (( i=1; i<=5; i++ )); do
  echo "Count: $i"
done
```

### While Loop
```bash
COUNT=0
while [ $COUNT -lt 5 ]; do
  echo "$COUNT"
  (( COUNT++ ))
done
```

### Until Loop
```bash
until [ $COUNT -ge 5 ]; do
  echo "$COUNT"
  (( COUNT++ ))
done
```

### Loop Control
```bash
break       # Exit the loop immediately
continue    # Skip to next iteration
```

### Loop Over Files
```bash
for file in *.log; do
  echo "Processing: $file"
done
```

### Loop Over Command Output
```bash
cat servers.txt | while read line; do
  echo "Pinging $line"
  ping -c 1 "$line"
done
```

---

## 4. Functions

### Defining a Function
```bash
greet() {
  echo "Hello, $1!"
}
```

### Calling a Function
```bash
greet "DevOps"    # Output: Hello, DevOps!
```

### Passing Arguments
```bash
add() {
  local RESULT=$(( $1 + $2 ))
  echo $RESULT
}
add 3 5    # Output: 8
```

### Return Values
```bash
# return only returns an exit code (0–255)
is_even() {
  [ $(( $1 % 2 )) -eq 0 ] && return 0 || return 1
}
is_even 4 && echo "even" || echo "odd"

# Use echo to return a string/value
get_date() {
  echo "$(date +%Y-%m-%d)"
}
TODAY=$(get_date)
```

### Local Variables
```bash
counter() {
  local COUNT=0    # Scoped to this function only
  (( COUNT++ ))
  echo $COUNT
}
```

---

## 5. Text Processing Commands

### grep — Search Patterns
```bash
grep "error" app.log          # Basic search
grep -i "error" app.log       # Case-insensitive
grep -r "TODO" ./src/         # Recursive search in dir
grep -c "error" app.log       # Count matching lines
grep -n "error" app.log       # Show line numbers
grep -v "debug" app.log       # Invert — show non-matching lines
grep -E "err|warn" app.log    # Extended regex (alternation)
```

### awk — Column Processing
```bash
awk '{print $1}' file               # Print first column
awk '{print $1, $3}' file           # Print columns 1 and 3
awk -F: '{print $1}' /etc/passwd    # Use : as field separator
awk '$3 > 100 {print $1}' data      # Print col 1 where col 3 > 100
awk 'BEGIN {print "Start"} {print} END {print "Done"}' file
```

### sed — Stream Editor
```bash
sed 's/old/new/' file          # Replace first occurrence per line
sed 's/old/new/g' file         # Replace all occurrences
sed -i 's/foo/bar/g' file      # In-place edit (modifies file)
sed '3d' file                  # Delete line 3
sed '/pattern/d' file          # Delete lines matching pattern
sed -n '5,10p' file            # Print lines 5–10 only
```

### cut — Extract Columns
```bash
cut -d: -f1 /etc/passwd        # Field 1, delimiter :
cut -d, -f2,4 data.csv         # Fields 2 and 4 from CSV
cut -c1-10 file                # Characters 1–10 of each line
```

### sort
```bash
sort file                      # Alphabetical (ascending)
sort -r file                   # Reverse order
sort -n numbers.txt            # Numerical sort
sort -u file                   # Sort and remove duplicates
sort -k2 -t: file              # Sort by field 2 with : delimiter
```

### uniq — Deduplicate (input must be sorted)
```bash
sort file | uniq               # Remove duplicate lines
sort file | uniq -c            # Count occurrences
sort file | uniq -d            # Show only duplicates
```

### tr — Translate / Delete Characters
```bash
echo "hello" | tr 'a-z' 'A-Z'    # Lowercase to uppercase
echo "a:b:c" | tr ':' ','         # Replace : with ,
echo "hello" | tr -d 'l'          # Delete all l characters
```

### wc — Word / Line / Char Count
```bash
wc -l file       # Line count
wc -w file       # Word count
wc -c file       # Byte count
wc -m file       # Character count
```

### head / tail
```bash
head -n 20 file           # First 20 lines
tail -n 20 file           # Last 20 lines
tail -f /var/log/syslog   # Follow mode — stream new lines live
tail -f app.log | grep -i "error"    # Follow and filter
```

---

## 6. Useful Patterns and One-Liners

```bash
# Find and delete files older than 30 days
find /tmp -type f -mtime +30 -delete

# Count total lines across all .log files
wc -l *.log | tail -1

# Replace a string across multiple files
grep -rl "old_string" ./configs/ | xargs sed -i 's/old_string/new_string/g'

# Check if a service is running
systemctl is-active --quiet nginx && echo "nginx is UP" || echo "nginx is DOWN"

# Monitor disk usage and alert if above 80%
df -h / | awk 'NR==2 {gsub("%","",$5); if($5>80) print "ALERT: Disk at "$5"%"}'

# Tail a log and filter for errors in real time
tail -f /var/log/app.log | grep --line-buffered -i "error"

# Extract unique IPs from an access log
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -rn | head -20

# Parse JSON from command line (requires jq)
curl -s https://api.example.com/data | jq '.items[].name'

# List top 10 largest files in a directory
find /var -type f -exec du -sh {} + 2>/dev/null | sort -rh | head -10

# Backup and timestamp a config file before editing
cp nginx.conf "nginx.conf.bak.$(date +%Y%m%d_%H%M%S)"
```

---

## 7. Error Handling and Debugging

### Exit Codes
```bash
$?          # Exit code of the last command (0 = success, non-zero = failure)
exit 0      # Exit script with success
exit 1      # Exit script with failure
```

```bash
cp src.txt dest.txt
if [ $? -ne 0 ]; then
  echo "Copy failed!"
  exit 1
fi
```

### set Options — Put at Top of Script
```bash
set -e            # Exit immediately if any command fails
set -u            # Treat unset variables as errors
set -o pipefail   # Catch failures inside pipes (e.g., cmd1 | cmd2)
set -x            # Debug mode — prints each command before executing
```

```bash
#!/bin/bash
set -euo pipefail   # Combine all three (common production pattern)
```

### trap — Cleanup on Exit
```bash
cleanup() {
  echo "Cleaning up temp files..."
  rm -f /tmp/myapp_*
}
trap cleanup EXIT         # Runs cleanup() on any exit

trap 'echo "Interrupted"' INT     # Catch Ctrl+C
trap 'echo "Error on line $LINENO"' ERR    # Catch errors
```

### Debugging Tips
```bash
bash -x script.sh          # Run script in debug mode (no chmod needed)
bash -n script.sh          # Syntax check only — don't execute

# Enable/disable debug for a section only
set -x
  ... risky commands ...
set +x
```

---

## 8. Tips and Best Practices

```bash
# Always quote variables to avoid word-splitting issues
cp "$SOURCE" "$DEST"       # Good
cp $SOURCE $DEST           # Dangerous if paths have spaces

# Use [[ ]] instead of [ ] for safer conditionals in bash
[[ "$VAR" == "value" ]]    # Supports regex, no word splitting
[[ -f "$FILE" && -r "$FILE" ]]

# Use $(command) instead of backticks
DATE=$(date +%Y-%m-%d)     # Preferred — nestable
DATE=`date +%Y-%m-%d`      # Avoid — hard to nest and read

# Check if a variable is set before using it
: "${REQUIRED_VAR:?ERROR: REQUIRED_VAR is not set}"

# Default value if variable is unset
DB_HOST="${DB_HOST:-localhost}"

# Redirect both stdout and stderr to a log
./deploy.sh > deploy.log 2>&1

# Discard all output (silent run)
./check.sh > /dev/null 2>&1
```

---

*Generated for DevOps Day 21 — Shell Scripting Revision*