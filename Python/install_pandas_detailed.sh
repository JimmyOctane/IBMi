#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Install pandas with detailed logging
# ============================================================================

PYTHON="/QOpenSys/pkgs/bin/python3.6"
LOGFILE="/tmp/pandas_install_log.txt"

echo "Logging all output to: $LOGFILE"
echo ""

{
    echo "============================================================"
    echo "Pandas Installation with Detailed Logging"
    echo "Date: $(date)"
    echo "============================================================"
    echo ""
    
    echo "Current pip version:"
    $PYTHON -m pip --version
    echo ""
    
    echo "Step 1: Upgrading pip..."
    $PYTHON -m pip install --user --upgrade pip
    PIP_EXIT=$?
    echo "Pip upgrade exit code: $PIP_EXIT"
    echo ""
    
    echo "New pip version:"
    $PYTHON -m pip --version
    echo ""
    
    echo "Step 2: Installing numpy first (pandas dependency)..."
    $PYTHON -m pip install --user "numpy<1.20"
    echo ""
    
    echo "Step 3: Installing pandas with verbose output..."
    $PYTHON -m pip install --user --verbose "pandas==1.1.5"
    PANDAS_EXIT=$?
    echo "Pandas install exit code: $PANDAS_EXIT"
    echo ""
    
    echo "Step 4: Checking what was installed..."
    $PYTHON -m pip list | grep -i pandas
    echo ""
    
    echo "Step 5: Testing import..."
    $PYTHON -c "import pandas; print('SUCCESS:', pandas.__version__)" 2>&1
    echo ""
    
    echo "============================================================"
    echo "Log complete"
    echo "============================================================"
    
} 2>&1 | tee $LOGFILE

echo ""
echo "Full log saved to: $LOGFILE"
echo "To view: cat $LOGFILE"
