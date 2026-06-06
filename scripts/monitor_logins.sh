#!/bin/bash
# Script to detect failed SSH login attempts

LOG_FILE="/var/log/auth.log"                # Path to system authentication log
OUTPUT_FILE="/var/log/failed_attempts.log"  # Output file for failed attempts

# Write header to output file
echo "Failed login attempts:" | sudo tee $OUTPUT_FILE > /dev/null

# Search for "Failed password" entries in the log
# Extract timestamp (fields 1–3) and username (field 11)
sudo grep "Failed password" $LOG_FILE | awk '{print $1,$2,$3,$11}' | sudo tee -a $OUTPUT_FILE > /dev/null

# Confirmation message
echo "Results saved to $OUTPUT_FILE"
