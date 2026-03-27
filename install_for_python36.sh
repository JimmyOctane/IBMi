#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Definitive Fix: Install packages for Python 3.6 specifically
# ============================================================================

echo "============================================================"
echo "Installing Python Packages for Python 3.6"
echo "============================================================"
echo ""

# Use the explicit Python 3.6 binary
PYTHON="/QOpenSys/pkgs/bin/python3.6"

echo "Using Python: $PYTHON"
$PYTHON --version
echo ""

# Check if pip is available
echo "Checking pip..."
$PYTHON -m pip --version
if [ $? -ne 0 ]; then
    echo "ERROR: pip is not available for Python 3.6"
    echo "Installing pip..."
    $PYTHON -m ensurepip --user
fi
echo ""

# Install packages with explicit Python 3.6
echo "Installing pandas for Python 3.6..."
$PYTHON -m pip install --user pandas
echo ""

echo "Installing openpyxl for Python 3.6..."
$PYTHON -m pip install --user openpyxl
echo ""

echo "Installing pyodbc for Python 3.6..."
$PYTHON -m pip install --user pyodbc
echo ""

# Verify installation
echo "============================================================"
echo "Verifying Installation"
echo "============================================================"
echo ""

$PYTHON << 'EOF'
import sys
print(f"Python: {sys.executable}")
print(f"Version: {sys.version}")
print("")

try:
    import pandas
    print(f"✓ pandas {pandas.__version__} installed at:")
    print(f"  {pandas.__file__}")
except ImportError as e:
    print(f"✗ pandas NOT found: {e}")

try:
    import openpyxl
    print(f"✓ openpyxl {openpyxl.__version__} installed at:")
    print(f"  {openpyxl.__file__}")
except ImportError as e:
    print(f"✗ openpyxl NOT found: {e}")

try:
    import pyodbc
    print(f"✓ pyodbc {pyodbc.version} installed at:")
    print(f"  {pyodbc.__file__}")
except ImportError as e:
    print(f"✗ pyodbc NOT found: {e}")
EOF

echo ""
echo "============================================================"
echo "Installation Complete!"
echo "============================================================"
