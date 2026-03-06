# USD to CAD Exchange Rate - IBM i Integration

This project provides a Python script to fetch current USD to CAD exchange rates and an IBM i SQLRPGLE program to execute it.

## Files

1. **[`usd_to_cad_exchange.py`](usd_to_cad_exchange.py:1)** - Python script that fetches exchange rates
2. **[`QRPGLESRC/runpyusd.sqlrpgle`](QRPGLESRC/runpyusd.sqlrpgle:1)** - SQLRPGLE program to execute Python script
3. **[`QCLSRC/RUNPYUSDC.CLLE`](QCLSRC/RUNPYUSDC.CLLE:1)** - CL wrapper to compile and run the program

## Setup Instructions

### 1. Install Python on IBM i (if not already installed)

```bash
# SSH into your IBM i system
ssh user@youribmi

# Install Python 3 using yum
yum install python3

# Install required Python package
pip3 install requests
```

### 2. Upload Python Script to IFS

Transfer [`usd_to_cad_exchange.py`](usd_to_cad_exchange.py:1) to your IBM i IFS, for example:

```bash
# Using FTP, SFTP, or copy the file to:
/home/YOURUSER/usd_to_cad_exchange.py
```

Make sure the file has execute permissions:
```bash
chmod 755 /home/YOURUSER/usd_to_cad_exchange.py
```

### 3. Update the SQLRPGLE Program

Edit [`QRPGLESRC/runpyusd.sqlrpgle`](QRPGLESRC/runpyusd.sqlrpgle:26) and update these variables:

```rpgle
// Line 26-27: Update with your paths
pythonPath = '/QOpenSys/pkgs/bin/python3';  // Verify Python location
scriptPath = '/home/YOURUSER/usd_to_cad_exchange.py';  // Your script path
```

To find your Python path on IBM i:
```bash
which python3
```

### 4. Compile and Run

#### Option A: Using the CL Wrapper (Recommended)

```
CRTBNDCL PGM(YOURLIB/RUNPYUSDC) SRCFILE(YOURLIB/QCLSRC) SRCMBR(RUNPYUSDC)
CALL YOURLIB/RUNPYUSDC
```

#### Option B: Compile SQLRPGLE Directly

```
CRTSQLRPGI OBJ(YOURLIB/RUNPYUSD) +
           SRCFILE(YOURLIB/QRPGLESRC) +
           SRCMBR(RUNPYUSD) +
           COMMIT(*NONE) +
           DBGVIEW(*SOURCE)

CALL YOURLIB/RUNPYUSD
```

## How It Works

1. **Python Script** ([`usd_to_cad_exchange.py`](usd_to_cad_exchange.py:1)):
   - Calls exchangerate-api.com free API
   - Fetches current USD to CAD exchange rate
   - Displays formatted output with conversion examples

2. **SQLRPGLE Program** ([`QRPGLESRC/runpyusd.sqlrpgle`](QRPGLESRC/runpyusd.sqlrpgle:1)):
   - Uses [`system()`](QRPGLESRC/runpyusd.sqlrpgle:14) API to execute Python script
   - Captures output to temporary file
   - Uses [`QSYS2.IFS_READ`](QRPGLESRC/runpyusd.sqlrpgle:73) to read output
   - Displays results using [`Qp0zLprintf()`](QRPGLESRC/runpyusd.sqlrpgle:9)

3. **CL Wrapper** ([`QCLSRC/RUNPYUSDC.CLLE`](QCLSRC/RUNPYUSDC.CLLE:1)):
   - Automatically compiles SQLRPGLE program if needed
   - Executes the program
   - Provides error handling

## Expected Output

```
========================================
USD to CAD Exchange Rate
========================================
1 USD = 1.3542 CAD
Last Updated: 2026-03-04
Retrieved: 2026-03-04 10:22:15
========================================

Conversion Examples:
  $10 USD = $13.54 CAD
  $50 USD = $67.71 CAD
  $100 USD = $135.42 CAD
  $500 USD = $677.10 CAD
  $1,000 USD = $1,354.20 CAD
```

## Troubleshooting

### Python Not Found
```bash
# Check if Python is installed
which python3

# Install if missing
yum install python3
```

### Requests Module Not Found
```bash
# Install requests package
pip3 install requests
```

### Permission Denied
```bash
# Make Python script executable
chmod 755 /home/YOURUSER/usd_to_cad_exchange.py
```

### API Connection Issues
- Ensure IBM i has internet access
- Check firewall rules for outbound HTTPS (port 443)
- Verify DNS resolution is working

## API Information

- **API Used**: exchangerate-api.com
- **Endpoint**: https://api.exchangerate-api.com/v4/latest/USD
- **Rate Limit**: Free tier allows reasonable usage
- **No API Key Required**: Basic endpoint is free

## Customization

To fetch different currency pairs, modify the Python script:

```python
# Change the base currency in the URL
url = "https://api.exchangerate-api.com/v4/latest/EUR"  # For EUR base

# Change the target currency
cad_rate = data['rates']['GBP']  # For British Pound
```

## Notes

- Exchange rates are updated regularly by the API provider
- The script requires internet connectivity
- Output is captured in `/tmp/usd_cad_output.txt`
- The SQLRPGLE program uses `*New` activation group for clean execution
