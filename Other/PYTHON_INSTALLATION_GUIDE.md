# Installing Python on IBM i and Running USD to CAD Exchange Rate Program

## Step 1: Install Python on IBM i

### Option A: Using SSH (Recommended)
SSH into your IBM i system and run:

```bash
# Install Python 3
yum install python3

# Verify installation
python3 --version

# Install pip (if not included)
yum install python3-pip

# Install the requests module
pip3 install requests
```

### Option B: Using QSH from IBM i Command Line
```
QSH CMD('yum install python3')
QSH CMD('pip3 install requests')
```

### Option C: Using ACS (Access Client Solutions)
1. Open ACS
2. Go to "Open Source Package Management"
3. Search for "python3"
4. Install python3 and python3-pip
5. Search for and install "python3-requests" or use pip after Python is installed

## Step 2: Verify Python Installation

Run these commands to verify:

```bash
which python3
# Should show: /QOpenSys/pkgs/bin/python3

python3 --version
# Should show: Python 3.x.x

python3 -c "import requests; print('requests module OK')"
# Should show: requests module OK
```

## Step 3: Verify File Locations

Make sure these files are in place:

```bash
# Check Python script
ls -la /home/jflanary/usd_to_cad_exchange.py

# Check shell script
ls -la /home/jflanary/run_python_usd.sh

# Make shell script executable if needed
chmod +x /home/jflanary/run_python_usd.sh
```

## Step 4: Test Python Script Manually

Before running from RPG, test the Python script directly:

```bash
# Run the Python script
cd /home/jflanary
python3 usd_to_cad_exchange.py

# Or run the shell script
/home/jflanary/run_python_usd.sh

# Check the output
cat /tmp/usd_cad_output.txt
```

## Step 5: Run the IBM i Program

Once Python is installed and tested, run the program:

### Using the CL Program (Simpler)
```
CRTBNDCL PGM(YOURLIB/RUNPYUSD) SRCFILE(YOURLIB/QCLSRC) SRCMBR(RUNPYUSD)
CALL YOURLIB/RUNPYUSD
```

### Using the SQLRPGLE Program
```
CRTSQLRPGI OBJ(YOURLIB/RUNPYUSD) +
           SRCFILE(YOURLIB/QRPGLESRC) +
           SRCMBR(RUNPYUSD) +
           COMMIT(*NONE) +
           DBGVIEW(*SOURCE)

CALL YOURLIB/RUNPYUSD
```

## Expected Output

Once everything is working, you should see:

```
========================================
USD to CAD Exchange Rate
========================================
1 USD = 1.3542 CAD
Last Updated: 2026-03-04
Retrieved: 2026-03-04 11:03:15
========================================

Conversion Examples:
  $10 USD = $13.54 CAD
  $50 USD = $67.71 CAD
  $100 USD = $135.42 CAD
  $500 USD = $677.10 CAD
  $1,000 USD = $1,354.20 CAD
```

## Troubleshooting

### Python Installation Issues

If `yum` is not available:
1. You may need to install the IBM i Open Source Package Management first
2. Download from: https://www.ibm.com/support/pages/node/706903
3. Or contact your system administrator

### Permission Issues

If you get permission errors:
```bash
# Check current user
whoami

# Check file permissions
ls -la /home/jflanary/

# Fix permissions if needed
chmod 755 /home/jflanary/usd_to_cad_exchange.py
chmod 755 /home/jflanary/run_python_usd.sh
```

### Network Issues

If the API call fails:
- Verify IBM i has internet access
- Check firewall rules for outbound HTTPS (port 443)
- Test with: `ping api.exchangerate-api.com`

### Alternative Python Paths

If Python is installed in a different location:
```bash
# Find Python
which python3

# Update the shell script with the correct path
# Edit /home/jflanary/run_python_usd.sh
# Change PYTHON_PATH="/QOpenSys/pkgs/bin/python3" to your path
```

## Quick Test Commands

Run these in sequence to test each component:

```bash
# 1. Test Python
python3 --version

# 2. Test requests module
python3 -c "import requests; print('OK')"

# 3. Test Python script directly
python3 /home/jflanary/usd_to_cad_exchange.py

# 4. Test shell script
/home/jflanary/run_python_usd.sh

# 5. Check output
cat /tmp/usd_cad_output.txt
```

If all these work, the IBM i program will work too!
