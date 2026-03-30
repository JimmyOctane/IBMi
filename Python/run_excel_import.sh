#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Shell Script to Run Excel Import Python Program
# ============================================================================
# This script runs the Python program to import Excel data to DB2
# Place this file in /home/jflanary/ (or your home directory)
# Make it executable: chmod +x run_excel_import.sh
# ============================================================================

# Set paths
PYTHON_SCRIPT="/home/jflanary/import_excel_to_db2.py"
OUTPUT_FILE="/tmp/excel_import_output.txt"
ERROR_FILE="/tmp/excel_import_error.txt"

# Log start time
echo "============================================================" > $OUTPUT_FILE
echo "Excel to DB2 Import - Started at $(date)" >> $OUTPUT_FILE
echo "============================================================" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Run the Python script
/QOpenSys/pkgs/bin/python3 $PYTHON_SCRIPT >> $OUTPUT_FILE 2>> $ERROR_FILE

# Capture exit code
EXIT_CODE=$?

# Log completion
echo "" >> $OUTPUT_FILE
echo "============================================================" >> $OUTPUT_FILE
echo "Completed at $(date)" >> $OUTPUT_FILE
echo "Exit Code: $EXIT_CODE" >> $OUTPUT_FILE
echo "============================================================" >> $OUTPUT_FILE

# Display results
cat $OUTPUT_FILE

# If there were errors, display them
if [ -s $ERROR_FILE ]; then
    echo ""
    echo "ERRORS OCCURRED:"
    cat $ERROR_FILE
fi

# Exit with the Python script's exit code
exit $EXIT_CODE
