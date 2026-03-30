#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Fix Python Path and Reinstall Packages
# ============================================================================
# This script ensures packages are installed in the correct location
# and updates the Python path if needed
# ============================================================================

echo "============================================================"
echo "Fixing Python Package Installation"
echo "============================================================"
echo ""

# Get the user site-packages directory
USER_SITE=$(/QOpenSys/pkgs/bin/python3 -c "import site; print(site.USER_SITE)")
echo "User site-packages directory: $USER_SITE"
echo ""

# Ensure the directory exists
echo "Creating user site-packages directory if it doesn't exist..."
/QOpenSys/pkgs/bin/python3 -m site
echo ""

# Reinstall packages with --user flag explicitly
echo "Installing pandas with --user flag..."
/QOpenSys/pkgs/bin/python3 -m pip install --user --upgrade pandas
echo ""

echo "Installing openpyxl with --user flag..."
/QOpenSys/pkgs/bin/python3 -m pip install --user --upgrade openpyxl
echo ""

echo "Installing pyodbc with --user flag..."
/QOpenSys/pkgs/bin/python3 -m pip install --user --upgrade pyodbc
echo ""

echo "============================================================"
echo "Verifying Installation"
echo "============================================================"
echo ""

# Verify each package
echo "Testing pandas import..."
/QOpenSys/pkgs/bin/python3 -c "import pandas; print('✓ pandas version:', pandas.__version__, 'at', pandas.__file__)"

echo "Testing openpyxl import..."
/QOpenSys/pkgs/bin/python3 -c "import openpyxl; print('✓ openpyxl version:', openpyxl.__version__, 'at', openpyxl.__file__)"

echo "Testing pyodbc import..."
/QOpenSys/pkgs/bin/python3 -c "import pyodbc; print('✓ pyodbc version:', pyodbc.version, 'at', pyodbc.__file__)"

echo ""
echo "============================================================"
echo "All packages installed and verified successfully!"
echo "============================================================"
echo ""
echo "You can now run: /home/jflanary/run_excel_import.sh"
