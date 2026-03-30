#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Advanced Python Path Diagnostic and Fix
# ============================================================================

echo "============================================================"
echo "Advanced Python Diagnostics"
echo "============================================================"
echo ""

# Test 1: Direct python3 command
echo "Test 1: Testing with direct python3 command"
python3 -c "import pandas; print('SUCCESS with python3')" 2>&1
echo ""

# Test 2: Full path python3
echo "Test 2: Testing with /QOpenSys/pkgs/bin/python3"
/QOpenSys/pkgs/bin/python3 -c "import pandas; print('SUCCESS with /QOpenSys/pkgs/bin/python3')" 2>&1
echo ""

# Test 3: Check which python is being used
echo "Test 3: Which python3 is in PATH?"
which python3
echo ""

# Test 4: Check all python3 installations
echo "Test 4: All python3 installations:"
ls -la /QOpenSys/pkgs/bin/python* 2>/dev/null
ls -la /usr/bin/python* 2>/dev/null
echo ""

# Test 5: Check site-packages locations
echo "Test 5: Site-packages locations:"
/QOpenSys/pkgs/bin/python3 << 'EOF'
import site
import sys
print("sys.executable:", sys.executable)
print("\nUser site-packages:", site.USER_SITE)
print("\nSystem site-packages:", site.getsitepackages())
print("\nFull sys.path:")
for p in sys.path:
    print("  ", p)
EOF
echo ""

# Test 6: Find where pandas is actually installed
echo "Test 6: Finding pandas installation:"
find ~/.local -name "pandas" -type d 2>/dev/null | head -5
echo ""

# Test 7: Check environment variables
echo "Test 7: Environment variables:"
echo "HOME: $HOME"
echo "USER: $USER"
echo "PYTHONPATH: $PYTHONPATH"
echo "PATH: $PATH"
echo ""

# Test 8: Try importing with PYTHONPATH set
echo "Test 8: Testing with PYTHONPATH set:"
USER_SITE=$(/QOpenSys/pkgs/bin/python3 -c "import site; print(site.USER_SITE)")
echo "Setting PYTHONPATH to: $USER_SITE"
export PYTHONPATH="$USER_SITE:$PYTHONPATH"
/QOpenSys/pkgs/bin/python3 -c "import pandas; print('SUCCESS with PYTHONPATH set to:', '$USER_SITE')" 2>&1
echo ""

echo "============================================================"
echo "Diagnostic Complete - Check results above"
echo "============================================================"
