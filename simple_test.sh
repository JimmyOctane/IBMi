#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Simple Test: Can we import pandas with the Python we're using?
# ============================================================================

echo "Testing Python and pandas..."
echo ""

# Test 1: Which python3
echo "1. Which python3 command will be used:"
which python3
echo ""

# Test 2: Python version
echo "2. Python version:"
/QOpenSys/pkgs/bin/python3 --version
echo ""

# Test 3: Try to import pandas
echo "3. Attempting to import pandas:"
/QOpenSys/pkgs/bin/python3 << 'PYEOF'
import sys
print(f"Python executable: {sys.executable}")
print(f"Python version: {sys.version}")
print(f"\nPython path:")
for p in sys.path:
    print(f"  {p}")

print(f"\nTrying to import pandas...")
try:
    import pandas as pd
    print(f"SUCCESS! pandas version: {pd.__version__}")
    print(f"pandas location: {pd.__file__}")
except ImportError as e:
    print(f"FAILED! Error: {e}")
    print(f"\nLet's check where pip installed packages:")
    import site
    print(f"User site-packages: {site.USER_SITE}")
    import os
    if os.path.exists(site.USER_SITE):
        print(f"Contents of {site.USER_SITE}:")
        for item in os.listdir(site.USER_SITE):
            if 'pandas' in item.lower():
                print(f"  FOUND: {item}")
    else:
        print(f"Directory does not exist: {site.USER_SITE}")
PYEOF

echo ""
echo "Test complete!"
