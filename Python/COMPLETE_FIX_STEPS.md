# Complete Step-by-Step Guide to Fix Python Module Error

## Problem
Getting `ModuleNotFoundError: No module named 'pandas'` when running the Excel import script, even though packages install successfully.

---

## Step-by-Step Solution

### Step 1: Upload Files to IBM i

Upload these files from your Windows PC to `/home/jflanary/` on IBM i:
- `advanced_diagnose.sh`
- `run_excel_import_fixed.sh`

**How to upload:**
- Use FTP, SFTP, or your preferred file transfer method
- Ensure files go to `/home/jflanary/` directory

---

### Step 2: Connect to IBM i Shell

From a 5250 session:
```
CALL QP2TERM
```

Or use SSH to connect directly to the IBM i PASE shell.

---

### Step 3: Navigate to Your Home Directory

```bash
cd /home/jflanary
```

---

### Step 4: Make Scripts Executable

```bash
chmod +x advanced_diagnose.sh
chmod +x run_excel_import_fixed.sh
```

---

### Step 5: Run the Diagnostic Script

```bash
./advanced_diagnose.sh
```

**What to look for in the output:**
- Test 1 & 2: Should show if pandas can be imported
- Test 3: Shows which Python is in your PATH
- Test 5: Shows where Python looks for packages
- Test 6: Shows where pandas is actually installed
- Test 8: Tests with PYTHONPATH set

**Copy and save this output** - we need it to understand the issue.

---

### Step 6: Try the Fixed Import Script

```bash
./run_excel_import_fixed.sh
```

This script sets the PYTHONPATH before running the import.

---

## If It Still Doesn't Work

### Option A: Check Python Version Mismatch

Run this command to see all Python installations:
```bash
ls -la /QOpenSys/pkgs/bin/python*
ls -la /usr/bin/python*
```

You might have multiple Python versions. Packages might be installed for Python 3.9 but the script is using Python 3.6 (or vice versa).

### Option B: Install Packages System-Wide

Try installing with sudo (if you have permission):
```bash
sudo /QOpenSys/pkgs/bin/python3 -m pip install pandas openpyxl pyodbc
```

### Option C: Specify Exact Python Version

Find the exact Python version:
```bash
/QOpenSys/pkgs/bin/python3 --version
```

If it shows Python 3.9, install packages specifically for 3.9:
```bash
/QOpenSys/pkgs/bin/python3.9 -m pip install --user pandas openpyxl pyodbc
```

Then update the script to use that version.

### Option D: Create a Virtual Environment

```bash
cd /home/jflanary
/QOpenSys/pkgs/bin/python3 -m venv excel_env
source excel_env/bin/activate
pip install pandas openpyxl pyodbc
```

Then modify the import script to use this virtual environment.

---

## Quick Reference: All Commands in Order

```bash
# Connect to shell
CALL QP2TERM

# Navigate to directory
cd /home/jflanary

# Make scripts executable
chmod +x advanced_diagnose.sh run_excel_import_fixed.sh

# Run diagnostic
./advanced_diagnose.sh

# Try fixed script
./run_excel_import_fixed.sh
```

---

## What Each File Does

- **[`advanced_diagnose.sh`](advanced_diagnose.sh:1)** - Runs 8 tests to identify the Python path issue
- **[`run_excel_import_fixed.sh`](run_excel_import_fixed.sh:1)** - Import script with PYTHONPATH explicitly set
- **[`fix_python_path.sh`](fix_python_path.sh:1)** - Reinstalls packages with --user flag
- **[`install_python_packages.sh`](install_python_packages.sh:1)** - Original installation script

---

## Need More Help?

After running [`advanced_diagnose.sh`](advanced_diagnose.sh:1), share the complete output. The diagnostic will reveal:
1. If there are multiple Python installations
2. Where packages are installed vs. where Python is looking
3. The exact PYTHONPATH needed to fix the issue
