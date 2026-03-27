#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Show Full Installation Output
# ============================================================================

PYTHON="/QOpenSys/pkgs/bin/python3.6"

echo "============================================================"
echo "Python Package Installation - Full Output"
echo "============================================================"
echo ""

echo "Step 1: Python Version"
$PYTHON --version
echo ""

echo "Step 2: Pip Version"
$PYTHON -m pip --version
echo ""

echo "Step 3: Installing pandas..."
echo "Command: $PYTHON -m pip install --user pandas"
$PYTHON -m pip install --user pandas
PANDAS_EXIT=$?
echo "Exit code: $PANDAS_EXIT"
echo ""

echo "Step 4: Installing openpyxl..."
echo "Command: $PYTHON -m pip install --user openpyxl"
$PYTHON -m pip install --user openpyxl
OPENPYXL_EXIT=$?
echo "Exit code: $OPENPYXL_EXIT"
echo ""

echo "Step 5: Installing pyodbc..."
echo "Command: $PYTHON -m pip install --user pyodbc"
$PYTHON -m pip install --user pyodbc
PYODBC_EXIT=$?
echo "Exit code: $PYODBC_EXIT"
echo ""

echo "Step 6: List installed packages"
$PYTHON -m pip list | grep -i -E "(pandas|openpyxl|pyodbc)"
echo ""

echo "Step 7: Check site-packages directory"
USER_SITE=$($PYTHON -c "import site; print(site.USER_SITE)")
echo "User site-packages: $USER_SITE"
ls -la "$USER_SITE" 2>/dev/null | grep -i pandas
echo ""

echo "Step 8: Try to import pandas"
$PYTHON -c "import pandas; print('SUCCESS: pandas version', pandas.__version__)" 2>&1
echo ""

echo "============================================================"
echo "Installation process complete"
echo "============================================================"
