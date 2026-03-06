$content = Get-Content bectran.sqlrpgle -Raw

# Remove null variable declarations
$content = $content -replace '              dcl-s null_F\d+ int\(10\) inz\(0\);\r?\n', ''

# Remove null references in SELECT statements (e.g., ", :null_F1")
$content = $content -replace ', :null_F\d+', ''

# Remove int5_X indicator fields from data structures
$content = $content -replace '\s+int5_\d+ int\(10:0\);\r?\n', ''

$content | Set-Content bectran.sqlrpgle -NoNewline
