"""
Excel to IBM i DB2 Import Script
=================================
This script reads 2 specific fields from the first tab of an Excel file
and imports them into an IBM i DB2 table.

CUSTOMIZE THESE VARIABLES:
- EXCEL_FILE: Path to your Excel file
- SHEET_NAME: Name of the first tab (or use 0 for first sheet)
- FIELD1_COLUMN: Column name or index for first field
- FIELD2_COLUMN: Column name or index for second field
- DB_LIBRARY: Your IBM i library name
- DB_TABLE: Your IBM i table name
- DB_FIELD1: First database field name
- DB_FIELD2: Second database field name
"""

import pandas as pd
import pyodbc
import sys
from datetime import datetime

# ============================================================================
# CONFIGURATION - CUSTOMIZE THESE VALUES
# ============================================================================

# Excel file configuration
EXCEL_FILE = r'C:\JimmyOctane\IBMi\DG 2025 Q4.xlsx'
SHEET_NAME = 0  # Use 0 for first sheet, or 'Sheet1' for sheet name
FIELD1_COLUMN = 'Column1'  # Change to your first column name or use 0 for first column
FIELD2_COLUMN = 'Column2'  # Change to your second column name or use 1 for second column

# Database configuration
DB_LIBRARY = 'YOURLIB'     # Change to your library name
DB_TABLE = 'YOURTABLE'     # Change to your table name
DB_FIELD1 = 'FIELD1'       # Change to your first field name
DB_FIELD2 = 'FIELD2'       # Change to your second field name

# IBM i connection (adjust as needed)
DB_SYSTEM = 'your_ibmi_system'  # Your IBM i system name or IP
DB_USER = 'your_user'           # Your IBM i user
DB_PASSWORD = 'your_password'   # Your IBM i password

# ============================================================================
# FUNCTIONS
# ============================================================================

def read_excel_fields(excel_file, sheet_name, field1_col, field2_col):
    """
    Read 2 specific fields from Excel file
    
    Args:
        excel_file: Path to Excel file
        sheet_name: Sheet name or index (0 for first sheet)
        field1_col: First column name or index
        field2_col: Second column name or index
    
    Returns:
        DataFrame with 2 columns
    """
    try:
        print(f"Reading Excel file: {excel_file}")
        
        # Read Excel file
        df = pd.read_excel(excel_file, sheet_name=sheet_name)
        
        print(f"Total rows in Excel: {len(df)}")
        print(f"Available columns: {list(df.columns)}")
        
        # Extract only the 2 fields we need
        if isinstance(field1_col, int) and isinstance(field2_col, int):
            # Using column indices
            df_subset = df.iloc[:, [field1_col, field2_col]]
            df_subset.columns = [DB_FIELD1, DB_FIELD2]
        else:
            # Using column names
            df_subset = df[[field1_col, field2_col]].copy()
            df_subset.columns = [DB_FIELD1, DB_FIELD2]
        
        # Remove rows with null values in both fields
        df_subset = df_subset.dropna(how='all')
        
        print(f"Rows after removing nulls: {len(df_subset)}")
        print(f"\nFirst 5 rows:")
        print(df_subset.head())
        
        return df_subset
        
    except Exception as e:
        print(f"Error reading Excel file: {e}")
        sys.exit(1)


def connect_to_db2():
    """
    Connect to IBM i DB2 database
    
    Returns:
        pyodbc connection object
    """
    try:
        print(f"\nConnecting to IBM i system: {DB_SYSTEM}")
        
        # Connection string for IBM i
        conn_string = (
            f"DRIVER={{IBM i Access ODBC Driver}};"
            f"SYSTEM={DB_SYSTEM};"
            f"UID={DB_USER};"
            f"PWD={DB_PASSWORD};"
            f"DBQ={DB_LIBRARY};"
        )
        
        conn = pyodbc.connect(conn_string)
        print("Connected successfully!")
        
        return conn
        
    except Exception as e:
        print(f"Error connecting to database: {e}")
        print("\nMake sure:")
        print("1. IBM i Access ODBC Driver is installed")
        print("2. System name, user, and password are correct")
        print("3. Library exists on IBM i")
        sys.exit(1)


def import_to_db2(df, conn):
    """
    Import DataFrame to IBM i DB2 table
    
    Args:
        df: DataFrame with data to import
        conn: Database connection
    """
    try:
        cursor = conn.cursor()
        
        # Check if table exists
        table_full_name = f"{DB_LIBRARY}.{DB_TABLE}"
        print(f"\nImporting to table: {table_full_name}")
        
        # Prepare INSERT statement
        insert_sql = f"""
            INSERT INTO {table_full_name} ({DB_FIELD1}, {DB_FIELD2})
            VALUES (?, ?)
        """
        
        # Import data row by row
        success_count = 0
        error_count = 0
        
        for index, row in df.iterrows():
            try:
                cursor.execute(insert_sql, row[DB_FIELD1], row[DB_FIELD2])
                success_count += 1
                
                # Show progress every 100 rows
                if success_count % 100 == 0:
                    print(f"Imported {success_count} rows...")
                    
            except Exception as e:
                error_count += 1
                print(f"Error on row {index + 1}: {e}")
        
        # Commit the transaction
        conn.commit()
        
        print(f"\n{'='*60}")
        print(f"Import completed!")
        print(f"Successfully imported: {success_count} rows")
        print(f"Errors: {error_count} rows")
        print(f"{'='*60}")
        
        cursor.close()
        
    except Exception as e:
        print(f"Error importing data: {e}")
        conn.rollback()
        sys.exit(1)


def main():
    """
    Main execution function
    """
    print("="*60)
    print("Excel to IBM i DB2 Import")
    print("="*60)
    print(f"Started: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print()
    
    # Step 1: Read Excel file
    df = read_excel_fields(EXCEL_FILE, SHEET_NAME, FIELD1_COLUMN, FIELD2_COLUMN)
    
    # Step 2: Connect to DB2
    conn = connect_to_db2()
    
    # Step 3: Import data
    import_to_db2(df, conn)
    
    # Step 4: Close connection
    conn.close()
    
    print(f"\nCompleted: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")


if __name__ == "__main__":
    main()
