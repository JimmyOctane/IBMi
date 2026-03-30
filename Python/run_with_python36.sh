#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Run Excel Import with Python 3.6
# ============================================================================

# Use explicit Python 3.6 binary
PYTHON="/QOpenSys/pkgs/bin/python3.6"
SCRIPT="/home/jflanary/import_excel_to_db2.py"
OUTPUT="/tmp/excel_import_output.txt"
ERROR="/tmp/excel_import_error.txt"

echo "============================================================" | tee $OUTPUT
echo "Excel to DB2 Import - Started at $(date)" | tee -a $OUTPUT
echo "============================================================" | tee -a $OUTPUT
echo "" | tee -a $OUTPUT

echo "Using Python: $PYTHON" | tee -a $OUTPUT
$PYTHON --version 2>&1 | tee -a $OUTPUT
echo "" | tee -a $OUTPUT

echo "Running import script..." | tee -a $OUTPUT
echo "" | tee -a $OUTPUT

# Run with Python 3.6
$PYTHON $SCRIPT 2>&1 | tee -a $OUTPUT

EXIT_CODE=${PIPESTATUS[0]}

echo "" | tee -a $OUTPUT
echo "============================================================" | tee -a $OUTPUT
echo "Completed at $(date)" | tee -a $OUTPUT
echo "Exit Code: $EXIT_CODE" | tee -a $OUTPUT
echo "============================================================" | tee -a $OUTPUT

exit $EXIT_CODE
