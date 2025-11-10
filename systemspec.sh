#!/bin/bash

OUTPUT_FILE="system_info_output.txt"

echo "Collecting system information. Output will be saved to $OUTPUT_FILE"
echo "==============================================" >$OUTPUT_FILE
echo " SYSTEM INFORMATION REPORT" >>$OUTPUT_FILE
echo " Generated on: $(date)" >>$OUTPUT_FILE
echo "==============================================" >>$OUTPUT_FILE
echo >>$OUTPUT_FILE

# 1. Hardware and drivers currently in use
echo "1. Hardware and Drivers (lspci -k)" >>$OUTPUT_FILE
echo "----------------------------------------------" >>$OUTPUT_FILE
lspci -k >>$OUTPUT_FILE
echo >>$OUTPUT_FILE

# 2. Kernel modules currently loaded
echo "2. Kernel Modules Loaded (lsmod)" >>$OUTPUT_FILE
echo "----------------------------------------------" >>$OUTPUT_FILE
lsmod >>$OUTPUT_FILE
echo >>$OUTPUT_FILE

# 3. Install inxi if not installed
echo "Checking for inxi..."
if ! command -v inxi >/dev/null 2>&1; then
  echo "inxi not found. Attempting to install..."

  # Detect Debian / Ubuntu
  if command -v apt >/dev/null 2>&1; then
    sudo apt update -y >/dev/null
    sudo apt install -y inxi

  # Detect Fedora / RHEL
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y inxi

  else
    echo "No supported package manager found. Install inxi manually."
  fi
else
  echo "inxi found."
fi

# 4. Run inxi -Fxxx
echo >>$OUTPUT_FILE
echo "3. Full System Overview (inxi -Fxxx)" >>$OUTPUT_FILE
echo "----------------------------------------------" >>$OUTPUT_FILE
inxi -Fxxx >>$OUTPUT_FILE
echo >>$OUTPUT_FILE

# 5. USB Devices
echo "4. USB Devices (lsusb)" >>$OUTPUT_FILE
echo "----------------------------------------------" >>$OUTPUT_FILE
lsusb >>$OUTPUT_FILE
echo >>$OUTPUT_FILE

echo "==============================================" >>$OUTPUT_FILE
echo " Report Completed" >>$OUTPUT_FILE
echo " Saved to: $OUTPUT_FILE" >>$OUTPUT_FILE
echo "=============================================="

echo
echo "Done. Open the file with:"
echo "cat $OUTPUT_FILE"
