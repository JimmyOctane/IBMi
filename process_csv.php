<?php
/**
 * CSV Upload and Processing Script for IBM i
 * Processes uploaded CSV files and optionally inserts data into DB2 tables
 */

// Configuration
ini_set('display_errors', 1);
error_reporting(E_ALL);
ini_set('max_execution_time', 300); // 5 minutes
ini_set('memory_limit', '256M');

// IBM i DB2 Connection Parameters (adjust as needed)
define('DB_HOST', 'localhost');
define('DB_USER', ''); // Set your DB2 user
define('DB_PASS', ''); // Set your DB2 password
define('DB_NAME', ''); // Set your database/library

// Upload directory (ensure this directory exists and is writable)
define('UPLOAD_DIR', '/www/ibmi/uploads/');

// Maximum file size (10MB)
define('MAX_FILE_SIZE', 10 * 1024 * 1024);

/**
 * Main processing function
 */
function processUpload() {
    $response = [
        'success' => false,
        'message' => '',
        'data' => []
    ];
    
    try {
        // Validate upload
        if (!isset($_FILES['csv_file']) || $_FILES['csv_file']['error'] !== UPLOAD_ERR_OK) {
            throw new Exception('File upload failed: ' . getUploadError($_FILES['csv_file']['error']));
        }
        
        $file = $_FILES['csv_file'];
        
        // Validate file size
        if ($file['size'] > MAX_FILE_SIZE) {
            throw new Exception('File size exceeds maximum allowed size of 10MB');
        }
        
        // Validate file type
        $fileExt = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));
        if ($fileExt !== 'csv') {
            throw new Exception('Invalid file type. Only CSV files are allowed');
        }
        
        // Get form parameters
        $tableName = isset($_POST['table_name']) ? trim($_POST['table_name']) : '';
        $delimiter = isset($_POST['delimiter']) ? $_POST['delimiter'] : ',';
        $hasHeader = isset($_POST['has_header']);
        $createTable = isset($_POST['create_table']);
        
        // Handle tab delimiter
        if ($delimiter === '\t') {
            $delimiter = "\t";
        }
        
        // Create upload directory if it doesn't exist
        if (!file_exists(UPLOAD_DIR)) {
            mkdir(UPLOAD_DIR, 0755, true);
        }
        
        // Generate unique filename
        $uploadedFile = UPLOAD_DIR . uniqid('csv_') . '_' . basename($file['name']);
        
        // Move uploaded file
        if (!move_uploaded_file($file['tmp_name'], $uploadedFile)) {
            throw new Exception('Failed to save uploaded file');
        }
        
        // Parse CSV file
        $csvData = parseCSV($uploadedFile, $delimiter, $hasHeader);
        
        if (empty($csvData['rows'])) {
            throw new Exception('No data found in CSV file');
        }
        
        $response['data'] = [
            'filename' => basename($file['name']),
            'rows_count' => count($csvData['rows']),
            'columns_count' => count($csvData['headers']),
            'headers' => $csvData['headers'],
            'sample_rows' => array_slice($csvData['rows'], 0, 5) // First 5 rows as sample
        ];
        
        // Process to database if table name is provided
        if (!empty($tableName)) {
            $dbResult = processToDatabase($csvData, $tableName, $createTable);
            $response['data']['database'] = $dbResult;
        }
        
        $response['success'] = true;
        $response['message'] = 'CSV file processed successfully';
        
        // Clean up uploaded file
        @unlink($uploadedFile);
        
    } catch (Exception $e) {
        $response['success'] = false;
        $response['message'] = $e->getMessage();
    }
    
    return $response;
}

/**
 * Parse CSV file
 */
function parseCSV($filepath, $delimiter = ',', $hasHeader = true) {
    $result = [
        'headers' => [],
        'rows' => []
    ];
    
    if (!file_exists($filepath)) {
        throw new Exception('CSV file not found');
    }
    
    $handle = fopen($filepath, 'r');
    if ($handle === false) {
        throw new Exception('Unable to open CSV file');
    }
    
    $rowIndex = 0;
    
    while (($data = fgetcsv($handle, 0, $delimiter)) !== false) {
        // Skip empty rows
        if (empty(array_filter($data))) {
            continue;
        }
        
        if ($rowIndex === 0 && $hasHeader) {
            // First row is header
            $result['headers'] = array_map('trim', $data);
        } else {
            // Data row
            if (empty($result['headers'])) {
                // Generate generic headers if no header row
                $result['headers'] = array_map(function($i) {
                    return 'Column_' . ($i + 1);
                }, array_keys($data));
            }
            
            // Create associative array with headers as keys
            $row = [];
            foreach ($data as $index => $value) {
                $header = isset($result['headers'][$index]) ? $result['headers'][$index] : 'Column_' . ($index + 1);
                $row[$header] = trim($value);
            }
            $result['rows'][] = $row;
        }
        
        $rowIndex++;
    }
    
    fclose($handle);
    
    return $result;
}

/**
 * Process data to DB2 database
 */
function processToDatabase($csvData, $tableName, $createTable = false) {
    $result = [
        'inserted' => 0,
        'failed' => 0,
        'errors' => []
    ];
    
    try {
        // Connect to DB2
        $conn = connectDB2();
        
        if (!$conn) {
            throw new Exception('Database connection failed');
        }
        
        // Parse table name (library.table format)
        $tableParts = explode('.', $tableName);
        if (count($tableParts) === 2) {
            $library = strtoupper(trim($tableParts[0]));
            $table = strtoupper(trim($tableParts[1]));
            $fullTableName = "$library.$table";
        } else {
            $table = strtoupper(trim($tableName));
            $fullTableName = $table;
        }
        
        // Check if table exists
        $tableExists = checkTableExists($conn, $fullTableName);
        
        if (!$tableExists && $createTable) {
            // Create table based on CSV structure
            createTableFromCSV($conn, $fullTableName, $csvData['headers']);
        } elseif (!$tableExists) {
            throw new Exception("Table $fullTableName does not exist. Enable 'Auto-create table' option to create it.");
        }
        
        // Insert data
        foreach ($csvData['rows'] as $index => $row) {
            try {
                insertRow($conn, $fullTableName, $row);
                $result['inserted']++;
            } catch (Exception $e) {
                $result['failed']++;
                $result['errors'][] = "Row " . ($index + 1) . ": " . $e->getMessage();
                
                // Limit error messages to first 10
                if (count($result['errors']) >= 10) {
                    $result['errors'][] = "... and more errors";
                    break;
                }
            }
        }
        
        // Close connection
        if (function_exists('db2_close')) {
            db2_close($conn);
        } elseif (function_exists('odbc_close')) {
            odbc_close($conn);
        }
        
    } catch (Exception $e) {
        $result['errors'][] = $e->getMessage();
    }
    
    return $result;
}

/**
 * Connect to DB2 database
 */
function connectDB2() {
    // Try IBM DB2 extension first
    if (function_exists('db2_connect')) {
        $conn = db2_connect(DB_NAME, DB_USER, DB_PASS);
        return $conn;
    }
    
    // Try ODBC as fallback
    if (function_exists('odbc_connect')) {
        $dsn = "DRIVER={IBM i Access ODBC Driver};SYSTEM=" . DB_HOST . ";DBQ=" . DB_NAME;
        $conn = odbc_connect($dsn, DB_USER, DB_PASS);
        return $conn;
    }
    
    throw new Exception('No DB2 or ODBC extension available');
}

/**
 * Check if table exists
 */
function checkTableExists($conn, $tableName) {
    $parts = explode('.', $tableName);
    
    if (count($parts) === 2) {
        $library = $parts[0];
        $table = $parts[1];
        $sql = "SELECT COUNT(*) as CNT FROM QSYS2.SYSTABLES WHERE TABLE_SCHEMA = '$library' AND TABLE_NAME = '$table'";
    } else {
        $sql = "SELECT COUNT(*) as CNT FROM QSYS2.SYSTABLES WHERE TABLE_NAME = '$tableName'";
    }
    
    if (function_exists('db2_exec')) {
        $stmt = db2_exec($conn, $sql);
        $row = db2_fetch_assoc($stmt);
        return $row && $row['CNT'] > 0;
    } elseif (function_exists('odbc_exec')) {
        $stmt = odbc_exec($conn, $sql);
        $row = odbc_fetch_array($stmt);
        return $row && $row['CNT'] > 0;
    }
    
    return false;
}

/**
 * Create table from CSV structure
 */
function createTableFromCSV($conn, $tableName, $headers) {
    $columns = [];
    
    foreach ($headers as $header) {
        // Sanitize column name
        $colName = strtoupper(preg_replace('/[^A-Za-z0-9_]/', '_', $header));
        $colName = substr($colName, 0, 30); // DB2 column name limit
        
        // Default to VARCHAR(256)
        $columns[] = "$colName VARCHAR(256)";
    }
    
    $sql = "CREATE TABLE $tableName (" . implode(', ', $columns) . ")";
    
    if (function_exists('db2_exec')) {
        $result = db2_exec($conn, $sql);
        if (!$result) {
            throw new Exception('Failed to create table: ' . db2_stmt_errormsg());
        }
    } elseif (function_exists('odbc_exec')) {
        $result = odbc_exec($conn, $sql);
        if (!$result) {
            throw new Exception('Failed to create table: ' . odbc_errormsg());
        }
    }
}

/**
 * Insert row into table
 */
function insertRow($conn, $tableName, $row) {
    $columns = array_keys($row);
    $values = array_values($row);
    
    // Sanitize column names
    $columns = array_map(function($col) {
        return strtoupper(preg_replace('/[^A-Za-z0-9_]/', '_', $col));
    }, $columns);
    
    // Prepare placeholders
    $placeholders = array_fill(0, count($values), '?');
    
    $sql = "INSERT INTO $tableName (" . implode(', ', $columns) . ") VALUES (" . implode(', ', $placeholders) . ")";
    
    if (function_exists('db2_prepare')) {
        $stmt = db2_prepare($conn, $sql);
        if (!$stmt) {
            throw new Exception('Failed to prepare statement: ' . db2_stmt_errormsg());
        }
        
        $result = db2_execute($stmt, $values);
        if (!$result) {
            throw new Exception('Failed to execute: ' . db2_stmt_errormsg($stmt));
        }
    } elseif (function_exists('odbc_prepare')) {
        $stmt = odbc_prepare($conn, $sql);
        if (!$stmt) {
            throw new Exception('Failed to prepare statement: ' . odbc_errormsg());
        }
        
        $result = odbc_execute($stmt, $values);
        if (!$result) {
            throw new Exception('Failed to execute: ' . odbc_errormsg());
        }
    }
}

/**
 * Get upload error message
 */
function getUploadError($code) {
    $errors = [
        UPLOAD_ERR_INI_SIZE => 'File exceeds upload_max_filesize',
        UPLOAD_ERR_FORM_SIZE => 'File exceeds MAX_FILE_SIZE',
        UPLOAD_ERR_PARTIAL => 'File was only partially uploaded',
        UPLOAD_ERR_NO_FILE => 'No file was uploaded',
        UPLOAD_ERR_NO_TMP_DIR => 'Missing temporary folder',
        UPLOAD_ERR_CANT_WRITE => 'Failed to write file to disk',
        UPLOAD_ERR_EXTENSION => 'Upload stopped by extension'
    ];
    
    return isset($errors[$code]) ? $errors[$code] : 'Unknown error';
}

// Process the upload
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $response = processUpload();
    
    // Return JSON response for AJAX or display HTML
    if (isset($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) === 'xmlhttprequest') {
        header('Content-Type: application/json');
        echo json_encode($response);
    } else {
        // Display HTML response
        displayHTMLResponse($response);
    }
} else {
    header('Location: upload_csv.html');
    exit;
}

/**
 * Display HTML response
 */
function displayHTMLResponse($response) {
    ?>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CSV Processing Result</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 20px;
            }
            
            .container {
                max-width: 900px;
                margin: 0 auto;
                background: white;
                border-radius: 10px;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
                padding: 40px;
            }
            
            h1 {
                color: #333;
                margin-bottom: 20px;
            }
            
            .status {
                padding: 15px 20px;
                border-radius: 6px;
                margin-bottom: 25px;
                font-weight: 600;
            }
            
            .status.success {
                background: #d4edda;
                color: #155724;
                border-left: 4px solid #28a745;
            }
            
            .status.error {
                background: #f8d7da;
                color: #721c24;
                border-left: 4px solid #dc3545;
            }
            
            .info-section {
                margin-bottom: 30px;
            }
            
            .info-section h2 {
                color: #333;
                font-size: 18px;
                margin-bottom: 15px;
                padding-bottom: 10px;
                border-bottom: 2px solid #667eea;
            }
            
            .info-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin-bottom: 20px;
            }
            
            .info-item {
                background: #f8f9ff;
                padding: 15px;
                border-radius: 6px;
            }
            
            .info-label {
                color: #666;
                font-size: 12px;
                text-transform: uppercase;
                margin-bottom: 5px;
            }
            
            .info-value {
                color: #333;
                font-size: 20px;
                font-weight: 600;
            }
            
            .table-container {
                overflow-x: auto;
                margin-bottom: 20px;
            }
            
            table {
                width: 100%;
                border-collapse: collapse;
                font-size: 14px;
            }
            
            th {
                background: #667eea;
                color: white;
                padding: 12px;
                text-align: left;
                font-weight: 600;
            }
            
            td {
                padding: 10px 12px;
                border-bottom: 1px solid #ddd;
            }
            
            tr:hover {
                background: #f8f9ff;
            }
            
            .error-list {
                background: #fff3cd;
                border-left: 4px solid #ffc107;
                padding: 15px;
                border-radius: 4px;
            }
            
            .error-list ul {
                margin-left: 20px;
                color: #856404;
            }
            
            .error-list li {
                margin-bottom: 5px;
            }
            
            .btn {
                display: inline-block;
                padding: 12px 30px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                text-decoration: none;
                border-radius: 6px;
                font-weight: 600;
                transition: transform 0.2s ease;
                margin-top: 20px;
            }
            
            .btn:hover {
                transform: translateY(-2px);
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>CSV Processing Result</h1>
            
            <div class="status <?php echo $response['success'] ? 'success' : 'error'; ?>">
                <?php echo htmlspecialchars($response['message']); ?>
            </div>
            
            <?php if ($response['success'] && !empty($response['data'])): ?>
                <div class="info-section">
                    <h2>File Information</h2>
                    <div class="info-grid">
                        <div class="info-item">
                            <div class="info-label">Filename</div>
                            <div class="info-value" style="font-size: 14px;">
                                <?php echo htmlspecialchars($response['data']['filename']); ?>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Total Rows</div>
                            <div class="info-value">
                                <?php echo number_format($response['data']['rows_count']); ?>
                            </div>
                        </div>
                        <div class="info-item">
                            <div class="info-label">Columns</div>
                            <div class="info-value">
                                <?php echo $response['data']['columns_count']; ?>
                            </div>
                        </div>
                    </div>
                </div>
                
                <?php if (!empty($response['data']['database'])): ?>
                    <div class="info-section">
                        <h2>Database Import Results</h2>
                        <div class="info-grid">
                            <div class="info-item">
                                <div class="info-label">Inserted</div>
                                <div class="info-value" style="color: #28a745;">
                                    <?php echo number_format($response['data']['database']['inserted']); ?>
                                </div>
                            </div>
                            <div class="info-item">
                                <div class="info-label">Failed</div>
                                <div class="info-value" style="color: #dc3545;">
                                    <?php echo number_format($response['data']['database']['failed']); ?>
                                </div>
                            </div>
                        </div>
                        
                        <?php if (!empty($response['data']['database']['errors'])): ?>
                            <div class="error-list">
                                <strong>Errors:</strong>
                                <ul>
                                    <?php foreach ($response['data']['database']['errors'] as $error): ?>
                                        <li><?php echo htmlspecialchars($error); ?></li>
                                    <?php endforeach; ?>
                                </ul>
                            </div>
                        <?php endif; ?>
                    </div>
                <?php endif; ?>
                
                <div class="info-section">
                    <h2>Sample Data (First 5 Rows)</h2>
                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <?php foreach ($response['data']['headers'] as $header): ?>
                                        <th><?php echo htmlspecialchars($header); ?></th>
                                    <?php endforeach; ?>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($response['data']['sample_rows'] as $row): ?>
                                    <tr>
                                        <?php foreach ($response['data']['headers'] as $header): ?>
                                            <td><?php echo htmlspecialchars($row[$header] ?? ''); ?></td>
                                        <?php endforeach; ?>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
            <?php endif; ?>
            
            <a href="upload_csv.html" class="btn">← Upload Another File</a>
        </div>
    </body>
    </html>
    <?php
}
?>
