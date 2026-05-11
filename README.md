# CSV Upload System for IBM i Apache Server

A complete HTML/PHP solution for uploading and processing CSV files on IBM i Apache server with DB2 database integration.

## Files Included

1. **[`upload_csv.html`](upload_csv.html)** - Modern, responsive upload interface
2. **[`process_csv.php`](process_csv.php)** - Backend processing script

## Features

### Upload Interface
- ✅ Drag-and-drop file upload
- ✅ File validation (CSV only, max 10MB)
- ✅ Real-time file information display
- ✅ Modern, responsive design
- ✅ Mobile-friendly interface

### CSV Processing
- ✅ Multiple delimiter support (comma, semicolon, tab, pipe)
- ✅ Header row detection
- ✅ Data parsing and validation
- ✅ Sample data preview (first 5 rows)
- ✅ Row and column counting

### Database Integration
- ✅ DB2 database connection (via IBM DB2 or ODBC)
- ✅ Optional table insertion
- ✅ Auto-create table from CSV structure
- ✅ Batch insert with error handling
- ✅ Detailed import statistics

## Installation

### 1. Upload Files
Copy both files to your IBM i Apache web directory:
```bash
/www/ibmi/htdocs/
```

### 2. Create Upload Directory
Create a writable directory for temporary file storage:
```bash
mkdir -p /www/ibmi/uploads
chmod 755 /www/ibmi/uploads
```

### 3. Configure Database Connection
Edit [`process_csv.php`](process_csv.php:18) and update the database credentials:

```php
define('DB_HOST', 'localhost');        // Your IBM i hostname
define('DB_USER', 'your_username');    // Your DB2 username
define('DB_PASS', 'your_password');    // Your DB2 password
define('DB_NAME', 'your_library');     // Your default library
```

### 4. Verify PHP Extensions
Ensure one of these PHP extensions is installed:
- `ibm_db2` (IBM DB2 extension) - Recommended
- `odbc` (ODBC extension) - Fallback option

Check with:
```bash
php -m | grep -E 'db2|odbc'
```

### 5. Set Permissions
Ensure Apache has read/write permissions:
```bash
chown -R QTMHHTTP:0 /www/ibmi/htdocs/
chown -R QTMHHTTP:0 /www/ibmi/uploads/
```

## Usage

### Basic Upload
1. Navigate to `http://your-ibmi-server/upload_csv.html`
2. Select or drag-and-drop a CSV file
3. Choose delimiter type
4. Click "Upload and Process"

### Database Import
1. Upload your CSV file
2. Enter target table name (format: `LIBRARY.TABLE` or just `TABLE`)
3. Select delimiter and options:
   - ☑️ First row contains headers
   - ☑️ Auto-create table (if needed)
4. Click "Upload and Process"

### Example Table Names
- `MYLIB.CUSTOMERS` - Specific library and table
- `SALES_DATA` - Table in default library
- `QTEMP.TEMP_IMPORT` - Temporary table

## Configuration Options

### Upload Settings
Edit [`process_csv.php`](process_csv.php:13) to modify:

```php
define('UPLOAD_DIR', '/www/ibmi/uploads/');  // Upload directory
define('MAX_FILE_SIZE', 10 * 1024 * 1024);   // Max file size (10MB)
```

### PHP Settings
Adjust in [`process_csv.php`](process_csv.php:8):

```php
ini_set('max_execution_time', 300);  // 5 minutes timeout
ini_set('memory_limit', '256M');     // Memory limit
```

## CSV Format Requirements

### Supported Delimiters
- Comma (`,`)
- Semicolon (`;`)
- Tab (`\t`)
- Pipe (`|`)

### Example CSV
```csv
Customer_ID,Name,Email,Phone
1001,John Doe,john@example.com,555-1234
1002,Jane Smith,jane@example.com,555-5678
```

## Database Table Creation

When "Auto-create table" is enabled, the script will:
1. Sanitize column names (remove special characters)
2. Limit column names to 30 characters (DB2 limit)
3. Create all columns as `VARCHAR(256)`
4. Use uppercase naming convention

### Example Generated Table
```sql
CREATE TABLE MYLIB.CUSTOMERS (
    CUSTOMER_ID VARCHAR(256),
    NAME VARCHAR(256),
    EMAIL VARCHAR(256),
    PHONE VARCHAR(256)
)
```

## Error Handling

The system provides detailed error messages for:
- Invalid file types
- File size exceeded
- Database connection failures
- Table not found
- Insert failures with row numbers
- SQL errors

## Response Format

### Success Response
- File information (name, size, row/column count)
- Sample data preview (first 5 rows)
- Database import statistics (if applicable)
- Detailed error list (if any rows failed)

### Error Response
- Clear error message
- Suggested resolution
- Link to retry upload

## Security Considerations

1. **File Validation**: Only CSV files accepted
2. **Size Limits**: 10MB maximum file size
3. **SQL Injection**: Prepared statements used
4. **Column Sanitization**: Special characters removed
5. **Temporary Files**: Cleaned up after processing

## Troubleshooting

### "Database connection failed"
- Verify DB2/ODBC extension is installed
- Check database credentials in [`process_csv.php`](process_csv.php:18)
- Ensure user has proper permissions

### "Failed to save uploaded file"
- Check upload directory exists: `/www/ibmi/uploads/`
- Verify directory permissions (755)
- Ensure Apache user (QTMHHTTP) has write access

### "Table does not exist"
- Enable "Auto-create table" option, OR
- Create table manually before import, OR
- Verify table name format: `LIBRARY.TABLE`

### "No DB2 or ODBC extension available"
Install IBM DB2 extension:
```bash
yum install php-ibm_db2
```

Or configure ODBC:
```bash
yum install php-odbc unixODBC
```

## Customization

### Styling
Modify the `<style>` section in [`upload_csv.html`](upload_csv.html:7) to match your branding.

### Data Types
Edit [`createTableFromCSV()`](process_csv.php:284) in [`process_csv.php`](process_csv.php:284) to customize column types:

```php
// Example: Detect numeric columns
if (is_numeric($sampleValue)) {
    $columns[] = "$colName DECIMAL(15,2)";
} else {
    $columns[] = "$colName VARCHAR(256)";
}
```

### Validation Rules
Add custom validation in [`parseCSV()`](process_csv.php:139) function.

## Performance Tips

1. **Large Files**: Increase memory limit and execution time
2. **Batch Processing**: Process in chunks for very large files
3. **Indexing**: Add indexes after bulk insert
4. **Temporary Tables**: Use QTEMP for staging data

## Support

For issues or questions:
1. Check Apache error logs: `/www/ibmi/logs/error_log`
2. Enable PHP error display in [`process_csv.php`](process_csv.php:8)
3. Verify file permissions and ownership

## License

Free to use and modify for your IBM i environment.
