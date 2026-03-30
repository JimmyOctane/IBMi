#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Python Environment Diagnostic Script
# ============================================================================
# This script checks Python configuration to diagnose module import issues
# ============================================================================

echo "============================================================"
echo "Python Environment Diagnostics"
echo "============================================================"
echo ""

echo "1. Python Version:"
/QOpenSys/pkgs/bin/python3 --version
echo ""

echo "2. Python Executable Path:"
which python3
/QOpenSys/pkgs/bin/which python3
echo ""

echo "3. Python sys.path (where Python looks for modules):"
/QOpenSys/pkgs/bin/python3 -c "import sys; print('\n'.join(sys.path))"
echo ""

echo "4. Pip Version:"
/QOpenSys/pkgs/bin/python3 -m pip --version
echo ""

echo "5. Installed Packages:"
/QOpenSys/pkgs/bin/python3 -m pip list | grep -E "(pandas|openpyxl|pyodbc)"
echo ""

echo "6. Try importing pandas:"
/QOpenSys/pkgs/bin/python3 -c "import pandas; print('SUCCESS: pandas found at:', pandas.__file__)" 2>&1
echo ""

echo "7. Check if pandas is in user site-packages:"
/QOpenSys/pkgs/bin/python3 -c "import site; print('User site-packages:', site.USER_SITE)"
ls -la $(/QOpenSys/pkgs/bin/python3 -c "import site; print(site.USER_SITE)") 2>/dev/null | grep pandas
echo ""

echo "8. Check system site-packages:"
/QOpenSys/pkgs/bin/python3 -c "import site; print('System site-packages:', site.getsitepackages())"
echo ""

echo "9. Environment Variables:"
echo "PYTHONPATH: $PYTHONPATH"
echo "PATH: $PATH"
echo ""

echo "============================================================"
echo "Diagnostic Complete"
echo "============================================================"
