#!/QOpenSys/pkgs/bin/python3
"""
Excel Reader for IBM i IFS - Callable Version
==============================================
Reads .xlsx files from IFS and imports to DB2 table
Can be called from CL, RPG, or command line

Usage:
  python3 read_xlsx_callable.py <xlsx_path> <library> <table> [sheet_name] [start_row]

Example:
  python3 read_xlsx_callable.py /home/data/sales.xlsx MYLIB SALESTBL 0 1
"""

import sys
import pandas as pd
import pyodbc
import json
from datetime import datetime
import traceback

def log_message(message, log_file='/tmp/xlsx_import.log'):
    """Write message to log file"""
    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    with open(log_file, 'a') as f:
        f.write(f"[{timestamp}] {message}\n")

def read_xlsx_from_ifs(xlsx_path, sheet_name=0, start_row=0):
    """
    Read Excel file from IFS
    
    Args:
        xlsx_path: Full IFS path to .xlsx file
        sheet_name: Sheet name or index (0 for first sheet)
        start_row: Row to start reading from (0-based)
    
    Returns:
        pandas DataFrame
    """
    try:
        log_message(f"Reading Excel file: {xlsx_path}")
        
        # Try to convert sheet_name to int if it's numeric
        try:
            sheet_name = int(sheet_name)
        except (ValueError, TypeError):
            pass
        
        # Read Excel file
        df = pd.read_excel(
            xlsx_path, 
            sheet_name=sheet_name,
            header=start_row
        )
        
        log_message(f"Successfully read {len(df)} rows from Excel")
        log_message(f"Columns: {list(df.columns)}")
        
        return df
        
    except FileNotFoundError:
        log_message(f"ERROR: File not found: {xlsx_path}")
        raise
    except Exception as e:
        log_message(f"ERROR reading Excel: {str(e)}")
        log_message(traceback.format_exc())
        raise

def connect_db2(library):
    """
    Connect to local IBM i DB2
    
    Args:
        library: Library name for default schema
    
    Returns:
        pyodbc connection
    """
    try:
        log_message(f"Connecting to DB2, library: {library}")
        
        # Connection string for local IBM i
        conn_string = (
            "DRIVER={IBM i Access ODBC Driver};"
            "SYSTEM=localhost;"
            f"DBQ={library};"
            "CMT=0;"  # Manual commit
        )
        
        conn = pyodbc.connect(conn_string)
        log_message("DB2 connection established")
        
        return conn
        
    except Exception as e:
        log_message(f"ERROR connecting to DB2: {str(e)}")
        raise

def import_to_table(df, conn, library, table):
    """
    Import DataFrame to DB2 table
    
    Args:
        df: pandas DataFrame
        conn: DB2 connection
        library: Library name
        table: Table name
    """
    try:
        cursor = conn.cursor()
        table_full = f"{library}.{table}"
        
        log_message(f"Importing to table: {table_full}")
        
        # Get column count from DataFrame
        col_count = len(df.columns)
        placeholders = ', '.join(['?' for _ in range(col_count)])
        
        # Build INSERT statement
        insert_sql = f"INSERT INTO {table_full} VALUES ({placeholders})"
        
        log_message(f"Insert SQL: {insert_sql}")
        
        # Import rows
        success_count = 0
        error_count = 0
        
        for index, row in df.iterrows():
            try:
                # Convert row to list, handling NaN values
                values = [None if pd.isna(val) else val for val in row.tolist()]
                cursor.execute(insert_sql, values)
                success_count += 1
                
                # Progress indicator
                if success_count % 100 == 0:
                    log_message(f"Progress: {success_count} rows imported")
                    
            except Exception as e:
                error_count += 1
                log_message(f"ERROR on row {index + 1}: {str(e)}")
        
        # Commit transaction
        conn.commit()
        
        log_message(f"Import complete: {success_count} success, {error_count} errors")
        
        cursor.close()
        
        return success_count, error_count
        
    except Exception as e:
        log_message(f"ERROR during import: {str(e)}")
        conn.rollback()
        raise

def main():
    """Main execution"""
    try:
        # Parse command line arguments
        if len(sys.argv) < 4:
            print("Usage: read_xlsx_callable.py <xlsx_path> <library> <table> [sheet_name] [start_row]")
            sys.exit(1)
        
        xlsx_path = sys.argv[1]
        library = sys.argv[2].upper()
        table = sys.argv[3].upper()
        sheet_name = sys.argv[4] if len(sys.argv) > 4 else 0
        start_row = int(sys.argv[5]) if len(sys.argv) > 5 else 0
        
        log_message("="*60)
        log_message("Excel to DB2 Import - Callable Version")
        log_message(f"File: {xlsx_path}")
        log_message(f"Target: {library}.{table}")
        log_message(f"Sheet: {sheet_name}, Start Row: {start_row}")
        log_message("="*60)
        
        # Step 1: Read Excel
        df = read_xlsx_from_ifs(xlsx_path, sheet_name, start_row)
        
        # Step 2: Connect to DB2
        conn = connect_db2(library)
        
        # Step 3: Import data
        success, errors = import_to_table(df, conn, library, table)
        
        # Step 4: Close connection
        conn.close()
        
        # Output summary
        summary = {
            "status": "success",
            "rows_imported": success,
            "rows_failed": errors,
            "total_rows": len(df)
        }
        
        print(json.dumps(summary))
        log_message(f"Final status: {json.dumps(summary)}")
        
        sys.exit(0 if errors == 0 else 1)
        
    except Exception as e:
        error_msg = {
            "status": "error",
            "message": str(e),
            "traceback": traceback.format_exc()
        }
        print(json.dumps(error_msg))
        log_message(f"FATAL ERROR: {json.dumps(error_msg)}")
        sys.exit(1)

if __name__ == "__main__":
    main()
