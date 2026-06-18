#!/bin/bash

set -euo pipefail

# ==========================
# Task 1: Input Validation
# ==========================

if [ $# -ne 1 ]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

LOG_FILE="$1"

if [ ! -f "$LOG_FILE" ]; then
    echo "Error: File '$LOG_FILE' does not exist."
    exit 1
fi

# ==========================
# Variables
# ==========================

DATE=$(date +%F)
REPORT="log_report_${DATE}.txt"

TOTAL_LINES=$(wc -l < "$LOG_FILE")

# ==========================
# Task 2: Error Count
# ==========================

ERROR_COUNT=$(grep -Ei "ERROR|Failed" "$LOG_FILE" | wc -l)

echo "================================="
echo "Log Analysis Report"
echo "================================="
echo "Log File      : $LOG_FILE"
echo "Total Lines   : $TOTAL_LINES"
echo "Error Count   : $ERROR_COUNT"
echo

# ==========================
# Task 3: Critical Events
# ==========================

echo "--- Critical Events ---"
CRITICAL_EVENTS=$(grep -n "CRITICAL" "$LOG_FILE" || true)

if [ -z "$CRITICAL_EVENTS" ]; then
    echo "No critical events found."
else
    echo "$CRITICAL_EVENTS"
fi

echo

# ==========================
# Task 4: Top Error Messages
# ==========================

echo "--- Top 5 Error Messages ---"

TOP_ERRORS=$(grep "ERROR" "$LOG_FILE" \
    | sed 's/.*ERROR[: ]*//' \
    | sort \
    | uniq -c \
    | sort -rn \
    | head -5)

if [ -z "$TOP_ERRORS" ]; then
    echo "No ERROR messages found."
else
    echo "$TOP_ERRORS"
fi

# ==========================
# Task 5: Summary Report
# ==========================

{
echo "================================="
echo "LOG ANALYSIS SUMMARY REPORT"
echo "================================="
echo "Date of Analysis : $(date)"
echo "Log File         : $LOG_FILE"
echo "Total Lines      : $TOTAL_LINES"
echo "Total Errors     : $ERROR_COUNT"
echo

echo "----- Top 5 Error Messages -----"
if [ -z "$TOP_ERRORS" ]; then
    echo "No ERROR messages found."
else
    echo "$TOP_ERRORS"
fi

echo
echo "----- Critical Events -----"

if [ -z "$CRITICAL_EVENTS" ]; then
    echo "No critical events found."
else
    echo "$CRITICAL_EVENTS"
fi

} > "$REPORT"

echo
echo "Report generated successfully: $REPORT"

# ==========================
# Task 6: Archive Log File
# ==========================

mkdir -p archive

mv "$LOG_FILE" archive/

echo "Log file moved to archive/"