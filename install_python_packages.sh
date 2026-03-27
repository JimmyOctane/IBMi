#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Install Required Python Packages for Excel Import
# ============================================================================
# This script installs the required Python packages on IBM i
# Run this once before running the Excel import script
# ============================================================================

echo "============================================================"
echo "Installing Python packages for Excel import..."
echo "============================================================"
echo ""

# Install pandas (for Excel file reading)
echo "Installing pandas..."
/QOpenSys/pkgs/bin/python3 -m pip install pandas

# Install openpyxl (required by pandas to read .xlsx files)
echo ""
echo "Installing openpyxl..."
/QOpenSys/pkgs/bin/python3 -m pip install openpyxl

# Install pyodbc (for DB2 database connection)
echo ""
echo "Installing pyodbc..."
/QOpenSys/pkgs/bin/python3 -m pip install pyodbc

echo ""
echo "============================================================"
echo "Installation complete!"
echo "============================================================"
echo ""
echo "Verifying installations..."
/QOpenSys/pkgs/bin/python3 -c "import pandas; print(f'pandas version: {pandas.__version__}')"
/QOpenSys/pkgs/bin/python3 -c "import openpyxl; print(f'openpyxl version: {openpyxl.__version__}')"
/QOpenSys/pkgs/bin/python3 -c "import pyodbc; print(f'pyodbc version: {pyodbc.version}')"
echo ""
echo "All packages installed successfully!"
