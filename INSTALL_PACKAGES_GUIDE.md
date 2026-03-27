# Python Package Installation Guide for Excel Import

This guide will help you install the required Python packages to fix the `ModuleNotFoundError: No module named 'pandas'` error.

## Problem
The Excel import script requires Python packages that are not currently installed:
- **pandas** - For reading Excel files
- **openpyxl** - Required by pandas to read .xlsx files  
- **pyodbc** - For connecting to DB2 database

## Solution Options

### Option 1: Using the CL Program (Recommended)

This is the easiest method if you're familiar with IBM i commands.

#### Step 1: Upload Files to IFS
Upload these files from your Windows PC to `/home/jflanary/` on IBM i:
- `install_python_packages.sh`

#### Step 2: Make Script Executable
From a 5250 session or SSH, run:
```
CALL QP2TERM
cd /home/jflanary
chmod +x install_python_packages.sh
```

#### Step 3: Compile the CL Program
```
CRTBNDCL PGM(YOURLIB/INSTPYPKG) +
         SRCFILE(YOURLIB/QCLSRC) +
         SRCMBR(INSTPYPKG)
```
(Replace `YOURLIB` with your actual library name)

#### Step 4: Run the Installation
```
CALL YOURLIB/INSTPYPKG
```

This will install all required packages. You should see a completion message when done.

---

### Option 2: Using SSH/QP2TERM Directly

If you prefer to run commands directly:

#### Step 1: Upload Script
Upload `install_python_packages.sh` to `/home/jflanary/` on IBM i

#### Step 2: Connect via SSH or QP2TERM
```
CALL QP2TERM
```

#### Step 3: Make Script Executable
```bash
cd /home/jflanary
chmod +x install_python_packages.sh
```

#### Step 4: Run the Installation Script
```bash
./install_python_packages.sh
```

Or run it directly:
```bash
/home/jflanary/install_python_packages.sh
```

---

### Option 3: Manual pip Installation

If the script doesn't work, install packages manually:

```bash
# Connect to PASE shell
CALL QP2TERM

# Install each package
/QOpenSys/pkgs/bin/python3 -m pip install pandas
/QOpenSys/pkgs/bin/python3 -m pip install openpyxl
/QOpenSys/pkgs/bin/python3 -m pip install pyodbc

# Verify installations
/QOpenSys/pkgs/bin/python3 -c "import pandas; print('pandas:', pandas.__version__)"
/QOpenSys/pkgs/bin/python3 -c "import openpyxl; print('openpyxl:', openpyxl.__version__)"
/QOpenSys/pkgs/bin/python3 -c "import pyodbc; print('pyodbc:', pyodbc.version)"
```

---

## Verification

After installation, verify the packages are installed:

```bash
/QOpenSys/pkgs/bin/python3 -c "import pandas, openpyxl, pyodbc; print('All packages installed successfully!')"
```

If this command runs without errors, you're ready to run the Excel import!

---

## Troubleshooting

### Error: "pip: command not found"
Python pip should be included with Python 3. If not, install it:
```bash
/QOpenSys/pkgs/bin/python3 -m ensurepip --upgrade
```

### Error: "Permission denied"
Make sure the script is executable:
```bash
chmod +x /home/jflanary/install_python_packages.sh
```

### Error: "No such file or directory"
Verify the script was uploaded to the correct location:
```bash
ls -l /home/jflanary/install_python_packages.sh
```

### Error: Network/proxy issues
If your IBM i system requires a proxy for internet access, set it before running pip:
```bash
export http_proxy=http://your-proxy:port
export https_proxy=http://your-proxy:port
/QOpenSys/pkgs/bin/python3 -m pip install pandas openpyxl pyodbc
```

---

## After Installation

Once packages are installed successfully, you can run the Excel import:

### Using CL Program:
```
CALL YOURLIB/RUNXLSIMP
```

### Using Shell Script:
```bash
/home/jflanary/run_excel_import.sh
```

---

## Files Created

- [`install_python_packages.sh`](install_python_packages.sh:1) - Shell script to install packages
- [`QCLSRC/INSTPYPKG.CLLE`](QCLSRC/INSTPYPKG.CLLE:1) - CL program to run installation
- This guide - Step-by-step instructions

---

## Quick Reference Commands

```bash
# Check Python version
/QOpenSys/pkgs/bin/python3 --version

# Check if pip is available
/QOpenSys/pkgs/bin/python3 -m pip --version

# List installed packages
/QOpenSys/pkgs/bin/python3 -m pip list

# Install a specific package
/QOpenSys/pkgs/bin/python3 -m pip install package-name

# Upgrade a package
/QOpenSys/pkgs/bin/python3 -m pip install --upgrade package-name
```
