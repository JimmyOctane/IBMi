#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Shell Script to Run Excel Import Python Program (FIXED VERSION)
# ============================================================================
# This script runs the Python program to import Excel data to DB2
# with proper Python path configuration
# ============================================================================

# Set paths
PYTHON_SCRIPT="/home/jflanary/import_excel_to_db2.py"
OUTPUT_FILE="/tmp/excel_import_output.txt"
ERROR_FILE="/tmp/excel_import_error.txt"

# Ensure Python can find user-installed packages
export PYTHONPATH="${HOME}/.local/lib/python3.9/site-packages:${PYTHONPATH}"

# Log start time
echo "============================================================" > $OUTPUT_FILE
echo "Excel to DB2 Import - Started at $(date)" >> $OUTPUT_FILE
echo "============================================================" >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Display Python environment info
echo "Python Version:" >> $OUTPUT_FILE
/QOpenSys/pkgs/bin/python3 --version >> $OUTPUT_FILE 2>&1
echo "" >> $OUTPUT_FILE

echo "Python Path:" >> $OUTPUT_FILE
/QOpenSys/pkgs/bin/python3 -c "import sys; print('\n'.join(sys.path))" >> $OUTPUT_FILE 2>&1
echo "" >> $OUTPUT_FILE

echo "Verifying pandas import:" >> $OUTPUT_FILE
/QOpenSys/pkgs/bin/python3 -c "import pandas; print('pandas version:', pandas.__version__)" >> $OUTPUT_FILE 2>&1
echo "" >> $OUTPUT_FILE

echo "Running import script..." >> $OUTPUT_FILE
echo "" >> $OUTPUT_FILE

# Run the Python script with explicit python3 path
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
