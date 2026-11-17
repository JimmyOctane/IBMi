#!/QOpenSys/pkgs/bin/python3
"""
ECM Daily Report Loader
=======================
Loads 2 tabs from ECM_DailyReport_20261008.xlsx into DB2 tables in JAMIEDEV library.
- Pendords  → ECMPENDORD
- bookdshp  → ECMBOOKSHP

This version uses openpyxl and generates SQL (no pyodbc required).
Improved sheet name handling with better error messages and list of available sheets.
"""

import sys
from datetime import datetime
from openpyxl import load_workbook

EXCEL_FILE = '/home/jflanary/ECM_DailyReport_20261008.xlsx'
OUTPUT_SQL = '/tmp/load_ecm.sql'

TABS = [
    {'sheet': 'Pendords',  'table': 'ECMPENDORD'},
    {'sheet': 'bookdshp',  'table': 'ECMBOOKSHP'}
]

def log(msg):
    print(f"[{datetime.now().strftime('%H:%M:%S')}] {msg}")

log("Starting ECM Daily Report Load")
log(f"Reading Excel: {EXCEL_FILE}")

# First, check what sheets are actually in the Excel file
try:
    wb_check = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
    available_sheets = wb_check.sheetnames
    log(f"Available sheets in Excel: {available_sheets}")
    wb_check.close()
except Exception as e:
    log(f"Cannot open Excel file: {e}")
    sys.exit(1)

with open(OUTPUT_SQL, 'w') as f:
    f.write("-- ================================================================\\n")
    f.write(f"-- Generated on {datetime.now()}\\n")
    f.write("-- ECM Daily Report - Pendords and bookdshp tabs\\n")
    f.write("-- ================================================================\\n\\n")
    f.write("SET SCHEMA JAMIEDEV;\\n\\n")

    for tab in TABS:
        sheet_name = tab['sheet']
        try:
            wb = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
            if sheet_name not in wb.sheetnames:
                raise KeyError(f"Worksheet '{sheet_name}' does not exist. Available: {wb.sheetnames}")
            sheet = wb[sheet_name]
            rows = list(sheet.iter_rows(values_only=True))
            wb.close()

            if not rows:
                log(f"Sheet {sheet_name} is empty")
                f.write(f"-- WARNING: Sheet {sheet_name} is empty\\n\\n")
                continue

            headers = [str(col).strip().replace(' ', '_').replace('-', '_').upper() for col in rows[0]]
            data_rows = rows[1:]

            full_table = f"JAMIEDEV.{tab['table']}"

            log(f"Processing {sheet_name} → {full_table} ({len(data_rows)} rows)")

            # Create table
            f.write(f"-- Table: {tab['table']}\\n")
            col_defs = ',\\n    '.join([f'"{col}" VARCHAR(1000)' for col in headers])
            f.write(f"CREATE OR REPLACE TABLE {full_table} (\\n    {col_defs}\\n);\\n\\n")

            # Insert data
            insert_count = 0
            for row in data_rows:
                if all(c is None for c in row):
                    continue  # skip completely blank rows
                values = []
                for cell in row:
                    if cell is None:
                        values.append('NULL')
                    elif isinstance(cell, (int, float)):
                        values.append(str(cell))
                    else:
                        val = str(cell).replace("'", "''")
                        values.append(f"'{val}'")
                f.write(f"INSERT INTO {full_table} VALUES ({', '.join(values)});\\n")
                insert_count += 1

            f.write(f"\\n-- Inserted {insert_count} rows into {tab['table']}\\n")
            f.write("\\nCOMMIT;\\n\\n")

        except Exception as e:
            log(f"Error processing {sheet_name}: {e}")
            f.write(f"-- ERROR in sheet {sheet_name}: {str(e)}\\n\\n")



log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

log(f"SQL script generated: {OUTPUT_SQL}")
log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")


log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")


log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")


log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

with open(OUTPUT_SQL, 'w') as f:
    f.write("-- ================================================================\\n")
    f.write(f"-- Generated on {datetime.now()}\\n")
    f.write("-- ECM Daily Report - Pendords and bookdshp tabs\\n")
    f.write("-- ================================================================\\n\\n")
    f.write("SET SCHEMA JAMIEDEV;\\n\\n")

    for tab in TABS:
        sheet_name = tab['sheet']
        try:
            wb = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
            if sheet_name not in wb.sheetnames:
                raise KeyError(f"Worksheet '{sheet_name}' does not exist. Available: {wb.sheetnames}")
            sheet = wb[sheet_name]
            rows = list(sheet.iter_rows(values_only=True))
            wb.close()

            if not rows:
                log(f"Sheet {sheet_name} is empty")
                f.write(f"-- WARNING: Sheet {sheet_name} is empty\\n\\n")
                continue

            headers = [str(col).strip().replace(' ', '_').replace('-', '_').upper() for col in rows[0]]
            data_rows = rows[1:]

            full_table = f"JAMIEDEV.{tab['table']}"

            log(f"Processing {sheet_name} → {full_table} ({len(data_rows)} rows)")

            # Create table
            f.write(f"-- Table: {tab['table']}\\n")
            col_defs = ',\\n    '.join([f'"{col}" VARCHAR(1000)' for col in headers])
            f.write(f"CREATE OR REPLACE TABLE {full_table} (\\n    {col_defs}\\n);\\n\\n")

            # Insert data
            insert_count = 0
            for row in data_rows:
                if all(c is None for c in row):
                    continue  # skip completely blank rows
                values = []
                for cell in row:
                    if cell is None:
                        values.append('NULL')
                    elif isinstance(cell, (int, float)):
                        values.append(str(cell))
                    else:
                        val = str(cell).replace("'", "''")
                        values.append(f"'{val}'")
                f.write(f"INSERT INTO {full_table} VALUES ({', '.join(values)});\\n")
                insert_count += 1

            f.write(f"\\n-- Inserted {insert_count} rows into {tab['table']}\\n")
            f.write("\\nCOMMIT;\\n\\n")

        except Exception as e:
            log(f"Error processing {sheet_name}: {e}")
            f.write(f"-- ERROR in sheet {sheet_name}: {str(e)}\\n\\n")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

#!/QOpenSys/pkgs/bin/python3
"""
ECM Daily Report Loader
=======================
Loads 2 tabs from ECM_DailyReport_20261008.xlsx into DB2 tables in JAMIEDEV library.
- Pendords  → ECMPENDORD
- bookdshp  → ECMBOOKSHP

This version uses openpyxl and generates SQL (no pyodbc required).
Improved sheet name handling with better error messages and list of available sheets.
"""

import sys
from datetime import datetime
from openpyxl import load_workbook

EXCEL_FILE = '/home/jflanary/ECM_DailyReport_20261008.xlsx'
OUTPUT_SQL = '/tmp/load_ecm.sql'

TABS = [
    {'sheet': 'Pendords',  'table': 'ECMPENDORD'},
    {'sheet': 'bookdshp',  'table': 'ECMBOOKSHP'}
]

def log(msg):
    print(f"[{datetime.now().strftime('%H:%M:%S')}] {msg}")

log("Starting ECM Daily Report Load")
log(f"Reading Excel: {EXCEL_FILE}")

# First, check what sheets are actually in the Excel file
try:
    wb_check = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
    available_sheets = wb_check.sheetnames
    log(f"Available sheets in Excel: {available_sheets}")
    wb_check.close()
except Exception as e:
    log(f"Cannot open Excel file: {e}")
    sys.exit(1)


#!/QOpenSys/pkgs/bin/python3
"""
ECM Daily Report Loader
=======================
Loads 2 tabs from ECM_DailyReport_20261008.xlsx into DB2 tables in JAMIEDEV library.
- Pendords  → ECMPENDORD
- bookdshp  → ECMBOOKSHP

This version uses openpyxl and generates SQL (no pyodbc required).
"""

import sys
from datetime import datetime
from openpyxl import load_workbook

EXCEL_FILE = '/home/jflanary/ECM_DailyReport_20261008.xlsx'
OUTPUT_SQL = '/tmp/load_ecm.sql'

TABS = [
    {'sheet': 'Pendords',  'table': 'ECMPENDORD'},
    {'sheet': 'bookdshp',  'table': 'ECMBOOKSHP'}
]

def log(msg):
    print(f"[{datetime.now().strftime('%H:%M:%S')}] {msg}")

log("Starting ECM Daily Report Load")
log(f"Reading Excel: {EXCEL_FILE}")

# First, check what sheets are actually in the Excel file
try:
    wb_check = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
    available_sheets = wb_check.sheetnames
    log(f"Available sheets in Excel: {available_sheets}")
    wb_check.close()
except Exception as e:
    log(f"Cannot open Excel file: {e}")
    sys.exit(1)

with open(OUTPUT_SQL, 'w') as f:
    f.write("-- ================================================================\\n")
    f.write(f"-- Generated on {datetime.now()}\\n")
    f.write("-- ECM Daily Report - Pendords and bookdshp tabs\\n")
    f.write("-- ================================================================\\n\\n")
    f.write("SET SCHEMA JAMIEDEV;\\n\\n")

    for tab in TABS:
        sheet_name = tab['sheet']
        try:
            wb = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
            if sheet_name not in wb.sheetnames:
                raise KeyError(f"Worksheet '{sheet_name}' does not exist. Available: {wb.sheetnames}")
            sheet = wb[sheet_name]
            rows = list(sheet.iter_rows(values_only=True))
            wb.close()

            if not rows:
                log(f"Sheet {sheet_name} is empty")
                f.write(f"-- WARNING: Sheet {sheet_name} is empty\\n\\n")
                continue

            headers = [str(col).strip().replace(' ', '_').replace('-', '_').upper() for col in rows[0]]
            data_rows = rows[1:]

            full_table = f"JAMIEDEV.{tab['table']}"

            log(f"Processing {sheet_name} → {full_table} ({len(data_rows)} rows)")

            # Create table
            f.write(f"-- Table: {tab['table']}\\n")
            col_defs = ',\\n    '.join([f'"{col}" VARCHAR(1000)' for col in headers])
            f.write(f"CREATE OR REPLACE TABLE {full_table} (\\n    {col_defs}\\n);\\n\\n")

            # Insert data
            insert_count = 0
            for row in data_rows:
                if all(c is None for c in row):
                    continue  # skip completely blank rows
                values = []
                for cell in row:
                    if cell is None:
                        values.append('NULL')
                    elif isinstance(cell, (int, float)):
                        values.append(str(cell))
                    else:
                        val = str(cell).replace("'", "''")
                        values.append(f"'{val}'")
                f.write(f"INSERT INTO {full_table} VALUES ({', '.join(values)});\\n")
                insert_count += 1

            f.write(f"\\n-- Inserted {insert_count} rows into {tab['table']}\\n")
            f.write("\\nCOMMIT;\\n\\n")

        except Exception as e:
            log(f"Error processing {sheet_name}: {e}")
            f.write(f"-- ERROR in sheet {sheet_name}: {str(e)}\\n\\n")

    for tab in TABS:
        sheet_name = tab['sheet']
        try:
            wb = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
            if sheet_name not in wb.sheetnames:
                raise KeyError(f"Worksheet '{sheet_name}' does not exist. Available: {wb.sheetnames}")
            sheet = wb[sheet_name]
            rows = list(sheet.iter_rows(values_only=True))
            wb.close()

            if not rows:
                log(f"Sheet {sheet_name} is empty")
                f.write(f"-- WARNING: Sheet {sheet_name} is empty\\n\\n")
                continue

            headers = [str(col).strip().replace(' ', '_').replace('-', '_').upper() for col in rows[0]]
            data_rows = rows[1:]

            full_table = f"JAMIEDEV.{tab['table']}"

            log(f"Processing {sheet_name} → {full_table} ({len(data_rows)} rows)")

            # Create table
            f.write(f"-- Table: {tab['table']}\\n")
            col_defs = ',\\n    '.join([f'"{col}" VARCHAR(1000)' for col in headers])
            f.write(f"CREATE OR REPLACE TABLE {full_table} (\\n    {col_defs}\\n);\\n\\n")

            # Insert data
            insert_count = 0
            for row in data_rows:
                if all(c is None for c in row):
                    continue  # skip completely blank rows
                values = []
                for cell in row:
                    if cell is None:
                        values.append('NULL')
                    elif isinstance(cell, (int, float)):
                        values.append(str(cell))
                    else:
                        val = str(cell).replace("'", "''")
                        values.append(f"'{val}'")
                f.write(f"INSERT INTO {full_table} VALUES ({', '.join(values)});\\n")
                insert_count += 1

            f.write(f"\\n-- Inserted {insert_count} rows into {tab['table']}\\n")
            f.write("\\nCOMMIT;\\n\\n")

        except Exception as e:
            log(f"Error processing {sheet_name}: {e}")
            f.write(f"-- ERROR in sheet {sheet_name}: {str(e)}\\n\\n")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

with open(OUTPUT_SQL, 'w') as f:
    f.write("-- ================================================================\\n")
    f.write(f"-- Generated on {datetime.now()}\\n")
    f.write("-- ECM Daily Report - Pendords and bookdshp tabs\\n")
    f.write("-- ================================================================\\n\\n")
    f.write("SET SCHEMA JAMIEDEV;\\n\\n")

    for tab in TABS:
        sheet_name = tab['sheet']
        try:
            wb = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
            if sheet_name not in wb.sheetnames:
                raise KeyError(f"Worksheet '{sheet_name}' does not exist. Available: {wb.sheetnames}")
            sheet = wb[sheet_name]
            rows = list(sheet.iter_rows(values_only=True))
            wb.close()

            if not rows:
                log(f"Sheet {sheet_name} is empty")
                f.write(f"-- WARNING: Sheet {sheet_name} is empty\\n\\n")
                continue

            headers = [str(col).strip().replace(' ', '_').replace('-', '_').upper() for col in rows[0]]
            data_rows = rows[1:]

            full_table = f"JAMIEDEV.{tab['table']}"

            log(f"Processing {sheet_name} → {full_table} ({len(data_rows)} rows)")

            # Create table
            f.write(f"-- Table: {tab['table']}\\n")
            col_defs = ',\\n    '.join([f'"{col}" VARCHAR(1000)' for col in headers])
            f.write(f"CREATE OR REPLACE TABLE {full_table} (\\n    {col_defs}\\n);\\n\\n")

            # Insert data
            insert_count = 0
            for row in data_rows:
                if all(c is None for c in row):
                    continue  # skip completely blank rows
                values = []
                for cell in row:
                    if cell is None:
                        values.append('NULL')
                    elif isinstance(cell, (int, float)):
                        values.append(str(cell))
                    else:
                        val = str(cell).replace("'", "''")
                        values.append(f"'{val}'")
                f.write(f"INSERT INTO {full_table} VALUES ({', '.join(values)});\\n")
                insert_count += 1

            f.write(f"\\n-- Inserted {insert_count} rows into {tab['table']}\\n")
            f.write("\\nCOMMIT;\\n\\n")

        except Exception as e:
            log(f"Error processing {sheet_name}: {e}")
            f.write(f"-- ERROR in sheet {sheet_name}: {str(e)}\\n\\n")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")


log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

#!/QOpenSys/pkgs/bin/python3
"""
ECM Daily Report Loader
=======================
Loads 2 tabs from ECM_DailyReport_20261008.xlsx into DB2 tables in JAMIEDEV library.
- Pendords  → ECMPENDORD
- bookdshp  → ECMBOOKSHP

This version uses openpyxl and generates SQL (no pyodbc required).
Improved sheet name handling with better error messages and list of available sheets.
"""

import sys
from datetime import datetime
from openpyxl import load_workbook

EXCEL_FILE = '/home/jflanary/ECM_DailyReport_20261008.xlsx'
OUTPUT_SQL = '/tmp/load_ecm.sql'

TABS = [
    {'sheet': 'Pendords',  'table': 'ECMPENDORD'},
    {'sheet': 'bookdshp',  'table': 'ECMBOOKSHP'}
]

def log(msg):
    print(f"[{datetime.now().strftime('%H:%M:%S')}] {msg}")

log("Starting ECM Daily Report Load")
log(f"Reading Excel: {EXCEL_FILE}")

# First, check what sheets are actually in the Excel file
try:
    wb_check = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
    available_sheets = wb_check.sheetnames
    log(f"Available sheets in Excel: {available_sheets}")
    wb_check.close()
except Exception as e:
    log(f"Cannot open Excel file: {e}")
    sys.exit(1)
#!/QOpenSys/pkgs/bin/python3
"""
ECM Daily Report Loader
=======================
Loads 2 tabs from ECM_DailyReport_20261008.xlsx into DB2 tables in JAMIEDEV library.
- Pendords  → ECMPENDORD
- bookdshp  → ECMBOOKSHP

This version uses openpyxl and generates SQL (no pyodbc required).
Improved sheet name handling with better error messages and list of available sheets.
"""

import sys
from datetime import datetime
from openpyxl import load_workbook

EXCEL_FILE = '/home/jflanary/ECM_DailyReport_20261008.xlsx'
OUTPUT_SQL = '/tmp/load_ecm.sql'

TABS = [
    {'sheet': 'Pendords',  'table': 'ECMPENDORD'},
    {'sheet': 'bookdshp',  'table': 'ECMBOOKSHP'}
]

def log(msg):
    print(f"[{datetime.now().strftime('%H:%M:%S')}] {msg}")

log("Starting ECM Daily Report Load")
log(f"Reading Excel: {EXCEL_FILE}")

# First, check what sheets are actually in the Excel file
try:
    wb_check = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
    available_sheets = wb_check.sheetnames
    log(f"Available sheets in Excel: {available_sheets}")
    wb_check.close()
except Exception as e:
    log(f"Cannot open Excel file: {e}")
    sys.exit(1)

with open(OUTPUT_SQL, 'w') as f:
    f.write("-- ================================================================\\n")
    f.write(f"-- Generated on {datetime.now()}\\n")
    f.write("-- ECM Daily Report - Pendords and bookdshp tabs\\n")
    f.write("-- ================================================================\\n\\n")
    f.write("SET SCHEMA JAMIEDEV;\\n\\n")

    for tab in TABS:
        sheet_name = tab['sheet']
        try:
            wb = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
            if sheet_name not in wb.sheetnames:
                raise KeyError(f"Worksheet '{sheet_name}' does not exist. Available: {wb.sheetnames}")
            sheet = wb[sheet_name]
            rows = list(sheet.iter_rows(values_only=True))
            wb.close()

            if not rows:
                log(f"Sheet {sheet_name} is empty")
                f.write(f"-- WARNING: Sheet {sheet_name} is empty\\n\\n")
                continue

            headers = [str(col).strip().replace(' ', '_').replace('-', '_').upper() for col in rows[0]]
            data_rows = rows[1:]

            full_table = f"JAMIEDEV.{tab['table']}"

            log(f"Processing {sheet_name} → {full_table} ({len(data_rows)} rows)")

            # Create table
            f.write(f"-- Table: {tab['table']}\\n")
            col_defs = ',\\n    '.join([f'"{col}" VARCHAR(1000)' for col in headers])
            f.write(f"CREATE OR REPLACE TABLE {full_table} (\\n    {col_defs}\\n);\\n\\n")

            # Insert data
            insert_count = 0
            for row in data_rows:
                if all(c is None for c in row):
                    continue  # skip completely blank rows
                values = []
                for cell in row:
                    if cell is None:
                        values.append('NULL')
                    elif isinstance(cell, (int, float)):
                        values.append(str(cell))
                    else:
                        val = str(cell).replace("'", "''")
                        values.append(f"'{val}'")
                f.write(f"INSERT INTO {full_table} VALUES ({', '.join(values)});\\n")
                insert_count += 1

            f.write(f"\\n-- Inserted {insert_count} rows into {tab['table']}\\n")
            f.write("\\nCOMMIT;\\n\\n")

        except Exception as e:
            log(f"Error processing {sheet_name}: {e}")
            f.write(f"-- ERROR in sheet {sheet_name}: {str(e)}\\n\\n")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")


with open(OUTPUT_SQL, 'w') as f:
    f.write("-- ================================================================\\n")
    f.write(f"-- Generated on {datetime.now()}\\n")
    f.write("-- ECM Daily Report - Pendords and bookdshp tabs\\n")
    f.write("-- ================================================================\\n\\n")
    f.write("SET SCHEMA JAMIEDEV;\\n\\n")

    for tab in TABS:
        sheet_name = tab['sheet']
        try:
            wb = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
            if sheet_name not in wb.sheetnames:
                raise KeyError(f"Worksheet '{sheet_name}' does not exist. Available: {wb.sheetnames}")
            sheet = wb[sheet_name]
            rows = list(sheet.iter_rows(values_only=True))
            wb.close()

            if not rows:
                log(f"Sheet {sheet_name} is empty")
                f.write(f"-- WARNING: Sheet {sheet_name} is empty\\n\\n")
                continue

            headers = [str(col).strip().replace(' ', '_').replace('-', '_').upper() for col in rows[0]]
            data_rows = rows[1:]

            full_table = f"JAMIEDEV.{tab['table']}"

            log(f"Processing {sheet_name} → {full_table} ({len(data_rows)} rows)")

            # Create table
            f.write(f"-- Table: {tab['table']}\\n")
            col_defs = ',\\n    '.join([f'"{col}" VARCHAR(1000)' for col in headers])
            f.write(f"CREATE OR REPLACE TABLE {full_table} (\\n    {col_defs}\\n);\\n\\n")

            # Insert data
            insert_count = 0
            for row in data_rows:
                if all(cell is None for cell in row if cell is not None):  # improved blank check
                    continue  # skip completely blank rows
                values = []
                for cell in row:
                    if cell is None:
                        values.append('NULL')
                    elif isinstance(cell, (int, float)):
                        values.append(str(cell))
                    else:
                        val = str(cell).replace("'", "''")
                        values.append(f"'{val}'")
                f.write(f"INSERT INTO {full_table} VALUES ({', '.join(values)});\\n")
                insert_count += 1

            f.write(f"\\n-- Inserted {insert_count} rows into {tab['table']}\\n")
            f.write("\\nCOMMIT;\\n\\n")

        except Exception as e:
            log(f"Error processing {sheet_name}: {e}")
            f.write(f"-- ERROR in sheet {sheet_name}: {str(e)}\\n\\n")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\\nDone.")

import sys
from datetime import datetime
from openpyxl import load_workbook

EXCEL_FILE = '/home/jflanary/ECM_DailyReport_20261008.xlsx'
OUTPUT_SQL = '/tmp/load_ecm.sql'

TABS = [
    {'sheet': 'Pendords',  'table': 'ECMPENDORD'},
    {'sheet': 'bookdshp',  'table': 'ECMBOOKSHP'}
]

def log(msg):
    print(f"[{datetime.now().strftime('%H:%M:%S')}] {msg}")

log("Starting ECM Daily Report Load")
log(f"Reading Excel: {EXCEL_FILE}")

with open(OUTPUT_SQL, 'w') as f:
    f.write("-- ================================================================\n")
    f.write(f"-- Generated on {datetime.now()}\n")
    f.write("-- ECM Daily Report - Pendords and bookdshp tabs\n")
    f.write("-- ================================================================\n\n")
    f.write("SET SCHEMA JAMIEDEV;\n\n")

    for tab in TABS:
        try:
            wb = load_workbook(filename=EXCEL_FILE, read_only=True, data_only=True)
            sheet = wb[tab['sheet']]
            rows = list(sheet.iter_rows(values_only=True))
            wb.close()

            if not rows:
                log(f"Sheet {tab['sheet']} is empty")
                continue

            headers = [str(col).strip().replace(' ', '_').replace('-', '_').upper() for col in rows[0]]
            data_rows = rows[1:]

            full_table = f"JAMIEDEV.{tab['table']}"

            log(f"Processing {tab['sheet']} → {full_table} ({len(data_rows)} rows)")

            # Create table
            f.write(f"-- Table: {tab['table']}\n")
            col_defs = ',\n    '.join([f'"{col}" VARCHAR(1000)' for col in headers])
            f.write(f"CREATE OR REPLACE TABLE {full_table} (\n    {col_defs}\n);\n\n")

            # Insert data
            for row in data_rows:
                values = []
                for cell in row:
                    if cell is None:
                        values.append('NULL')
                    elif isinstance(cell, (int, float)):
                        values.append(str(cell))
                    else:
                        val = str(cell).replace("'", "''")
                        values.append(f"'{val}'")
                f.write(f"INSERT INTO {full_table} VALUES ({', '.join(values)});\n")

            f.write("\nCOMMIT;\n\n")

        except Exception as e:
            log(f"Error processing {tab['sheet']}: {e}")
            f.write(f"-- ERROR in sheet {tab['sheet']}: {str(e)}\n\n")

log(f"SQL script generated: {OUTPUT_SQL}")
log("\nTo load the data, run:")
log(f"RUNSQLSTM SRCSTMF('{OUTPUT_SQL}') COMMIT(*NONE) NAMING(*SQL)")
log("\nDone.")
