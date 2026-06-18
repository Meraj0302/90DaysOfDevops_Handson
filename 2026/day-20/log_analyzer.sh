#!/bin/bash
# log_analyzer.sh - Analyzes a log file and generates a report

# ── TASK 1: Check input ──────────────────────────────────────────────────────

# If no argument given, show error and quit
if [ $# -eq 0 ]; then
    echo "Error: Please provide a log file."
    echo "Usage: ./log_analyzer.sh sample.log"
    exit 1
fi

LOG_FILE=$1

# If the file doesn't exist, show error and quit
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' not found."
    exit 1
fi

# ── TASK 2: Count errors ─────────────────────────────────────────────────────

TOTAL_LINES=$(wc -l < "$LOG_FILE")
ERROR_COUNT=$(grep -cE "ERROR|Failed" "$LOG_FILE")

echo "Total lines  : $TOTAL_LINES"
echo "Total errors : $ERROR_COUNT"
echo ""

# ── TASK 3: Show critical events ─────────────────────────────────────────────

echo "--- Critical Events ---"
grep -n "CRITICAL" "$LOG_FILE" | while read line; do
    LINE_NUM=$(echo "$line" | cut -d: -f1)
    LINE_TEXT=$(echo "$line" | cut -d: -f2-)
    echo "Line $LINE_NUM: $LINE_TEXT"
done
echo ""

# ── TASK 4: Top 5 error messages ─────────────────────────────────────────────

echo "--- Top 5 Error Messages ---"
grep "ERROR" "$LOG_FILE" \
    | awk '{$1=$2=$3=""; print $0}' \
    | sed 's/^   //' \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -5
echo ""

# ── TASK 5: Save report to file ──────────────────────────────────────────────

TODAY=$(date +%Y-%m-%d)
REPORT="log_report_${TODAY}.txt"

{
    echo "Date        : $(date)"
    echo "Log File    : $LOG_FILE"
    echo "Total Lines : $TOTAL_LINES"
    echo "Total Errors: $ERROR_COUNT"
    echo ""
    echo "--- Top 5 Error Messages ---"
    grep "ERROR" "$LOG_FILE" \
        | awk '{$1=$2=$3=""; print $0}' \
        | sed 's/^   //' \
        | sort | uniq -c | sort -rn | head -5
    echo ""
    echo "--- Critical Events ---"
    grep -n "CRITICAL" "$LOG_FILE"
} > "$REPORT"

echo "Report saved: $REPORT"

# ── TASK 6: Archive the log file ─────────────────────────────────────────────

mkdir -p archive
mv "$LOG_FILE" archive/
echo "Log archived: archive/$LOG_FILE"
