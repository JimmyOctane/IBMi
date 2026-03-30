#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Final Fix: Upgrade pip and install compatible versions
# ============================================================================

PYTHON="/QOpenSys/pkgs/bin/python3.6"

echo "============================================================"
echo "Final Fix for Python Package Installation"
echo "============================================================"
echo ""

echo "Step 1: Upgrade pip to latest version"
echo "Old pip tries to build from source. New pip uses pre-built wheels."
$PYTHON -m pip install --user --upgrade pip
echo ""

echo "Step 2: Upgrade setuptools and wheel"
$PYTHON -m pip install --user --upgrade setuptools wheel
echo ""

echo "Step 3: Install pandas (compatible version for Python 3.6)"
echo "Using pandas 1.1.5 which is the last version supporting Python 3.6"
$PYTHON -m pip install --user "pandas==1.1.5" --prefer-binary
echo ""

echo "Step 4: Verify openpyxl (already installed)"
$PYTHON -m pip install --user --upgrade openpyxl
echo ""

echo "Step 5: Install pyodbc pre-built wheel if available"
echo "If this fails, we'll use an alternative DB connection method"
$PYTHON -m pip install --user pyodbc --prefer-binary
PYODBC_STATUS=$?
echo ""

if [ $PYODBC_STATUS -ne 0 ]; then
    echo "WARNING: pyodbc installation failed (requires gcc compiler)"
    echo "You may need to use ibm_db or ODBC configuration instead"
    echo ""
fi

echo "============================================================"
echo "Verification"
echo "============================================================"
echo ""

$PYTHON << 'EOF'
import sys
print(f"Python: {sys.version}")
print("")

# Test pandas
try:
    import pandas as pd
    print(f"SUCCESS: pandas {pd.__version__}")
    print(f"  Location: {pd.__file__}")
except ImportError as e:
    print(f"FAILED: pandas - {e}")

# Test openpyxl
try:
    import openpyxl
    print(f"SUCCESS: openpyxl {openpyxl.__version__}")
    print(f"  Location: {openpyxl.__file__}")
except ImportError as e:
    print(f"FAILED: openpyxl - {e}")

# Test pyodbc
try:
    import pyodbc
    print(f"SUCCESS: pyodbc {pyodbc.version}")
    print(f"  Location: {pyodbc.__file__}")
except ImportError as e:
    print(f"FAILED: pyodbc - {e}")
    print(f"  Note: pyodbc requires gcc compiler on IBM i")
EOF

echo ""
echo "============================================================"
echo "Installation Complete!"
echo "============================================================"
