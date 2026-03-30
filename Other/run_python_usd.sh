#!/QOpenSys/usr/bin/qsh
# Shell script to run Python USD to CAD exchange rate fetcher
# This is called from the SQLRPGLE program

# Set paths
PYTHON_PATH="/QOpenSys/pkgs/bin/python3"
SCRIPT_PATH="/home/jflanary/usd_to_cad_exchange.py"
OUTPUT_FILE="/tmp/usd_cad_output.txt"

# Clear previous output
> ${OUTPUT_FILE}

# Check if Python exists
if [ ! -f "${PYTHON_PATH}" ]; then
    echo "ERROR: Python not found at ${PYTHON_PATH}" >> ${OUTPUT_FILE}
    echo "Try: yum install python3" >> ${OUTPUT_FILE}
    exit 1
fi

# Check if script exists
if [ ! -f "${SCRIPT_PATH}" ]; then
    echo "ERROR: Python script not found at ${SCRIPT_PATH}" >> ${OUTPUT_FILE}
    exit 1
fi

# Check if Python script is readable
if [ ! -r "${SCRIPT_PATH}" ]; then
    echo "ERROR: Python script not readable at ${SCRIPT_PATH}" >> ${OUTPUT_FILE}
    exit 1
fi

# Run Python script and capture output
echo "Running Python script..." >> ${OUTPUT_FILE}

# Check if amount parameter was provided
if [ -n "$1" ]; then
    # Run with amount parameter (no prompting)
    ${PYTHON_PATH} ${SCRIPT_PATH} "$1" >> ${OUTPUT_FILE} 2>&1
else
    # Run interactively with input
    echo "0" | ${PYTHON_PATH} ${SCRIPT_PATH} >> ${OUTPUT_FILE} 2>&1
fi

# Capture exit code
EXIT_CODE=$?

if [ ${EXIT_CODE} -ne 0 ]; then
    echo "" >> ${OUTPUT_FILE}
    echo "Python script exited with code: ${EXIT_CODE}" >> ${OUTPUT_FILE}
fi

exit ${EXIT_CODE}
