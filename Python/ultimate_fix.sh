#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Ultimate Fix: Install and Run with Correct Python Environment
# ============================================================================
# This script ensures packages are installed and accessible in the same
# Python environment that runs the import script
# ============================================================================

echo "============================================================"
echo "Excel Import - Ultimate Fix Script"
echo "============================================================"
echo ""

# Find the Python executable
PYTHON_BIN="/QOpenSys/pkgs/bin/python3"

echo "Step 1: Checking Python installation..."
$PYTHON_BIN --version
echo ""

# Get the user site-packages directory
echo "Step 2: Getting Python site-packages location..."
USER_SITE=$($PYTHON_BIN -c "import site; print(site.USER_SITE)")
echo "User site-packages: $USER_SITE"
echo ""

# Ensure the directory exists
echo "Step 3: Ensuring site-packages directory exists..."
$PYTHON_BIN -m site --user-site
mkdir -p "$USER_SITE" 2>/dev/null
echo ""

# Install packages directly with this Python
echo "Step 4: Installing packages with the Python that will run the script..."
$PYTHON_BIN -m pip install --user --upgrade --force-reinstall pandas
echo ""
$PYTHON_BIN -m pip install --user --upgrade --force-reinstall openpyxl
echo ""
$PYTHON_BIN -m pip install --user --upgrade --force-reinstall pyodbc
echo ""

# Verify installation with the SAME Python
echo "Step 5: Verifying packages with the SAME Python executable..."
$PYTHON_BIN -c "import pandas; print('✓ pandas:', pandas.__version__, 'at', pandas.__file__)"
$PYTHON_BIN -c "import openpyxl; print('✓ openpyxl:', openpyxl.__version__, 'at', openpyxl.__file__)"
$PYTHON_BIN -c "import pyodbc; print('✓ pyodbc:', pyodbc.version, 'at', pyodbc.__file__)"
echo ""

# Now run the import script with the SAME Python
echo "Step 6: Running import script with the SAME Python..."
echo "============================================================"
echo ""

PYTHON_SCRIPT="/home/jflanary/import_excel_to_db2.py"
OUTPUT_FILE="/tmp/excel_import_output.txt"
ERROR_FILE="/tmp/excel_import_error.txt"

# Run with the exact same Python binary
$PYTHON_BIN $PYTHON_SCRIPT 2>&1 | tee $OUTPUT_FILE

EXIT_CODE=${PIPESTATUS[0]}

echo ""
echo "============================================================"
echo "Exit Code: $EXIT_CODE"
echo "============================================================"

if [ $EXIT_CODE -ne 0 ]; then
    echo ""
    echo "Script failed. Check output above for errors."
    exit $EXIT_CODE
else
    echo ""
    echo "Script completed successfully!"
    exit 0
fi
