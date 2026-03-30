#!/QOpenSys/pkgs/bin/bash
# ============================================================================
# Install pandas using IBM i yum (pre-compiled packages)
# ============================================================================

echo "============================================================"
echo "Installing pandas using IBM i Package Manager (yum)"
echo "============================================================"
echo ""

echo "The pip install fails because your system lacks compilers."
echo "IBM provides pre-compiled Python packages via yum."
echo ""

echo "Step 1: Check if yum is available..."
which yum
if [ $? -ne 0 ]; then
    echo "ERROR: yum not found. You need to install IBM i Access Client Solutions"
    echo "or use the IBM i ACS package manager."
    exit 1
fi
echo ""

echo "Step 2: Search for available pandas packages..."
yum search python3-pandas python36-pandas
echo ""

echo "Step 3: Install python3-pandas (if available)..."
echo "This may require root/admin privileges"
yum install -y python3-pandas python3-numpy python3-openpyxl
echo ""

echo "Step 4: Or try python36 specific packages..."
yum install -y python36-pandas python36-numpy python36-openpyxl
echo ""

echo "Step 5: Verify installation..."
/QOpenSys/pkgs/bin/python3.6 -c "import pandas; print('SUCCESS: pandas', pandas.__version__)" 2>&1
echo ""

echo "============================================================"
echo "Installation attempt complete"
echo "============================================================"
