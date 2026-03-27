# Read the file
$content = Get-Content 'listprbk.sqlrpgle' -Raw

# Remove **FREE line if it exists
$content = $content -replace '^\*\*FREE\r?\n', ''

# Split into lines
$lines = $content -split '\r?\n'

# Process each line - ensure it starts at column 9 (8 spaces)
$newLines = @()
foreach ($line in $lines) {
    if ($line -match '^\s{8}') {
        # Already has 8 spaces, keep as is
        $newLines += $line
    } else {
        # Trim leading spaces and add exactly 8 spaces
        $trimmed = $line.TrimStart()
        if ($trimmed -eq '') {
            $newLines += '        '
        } else {
            $newLines += '        ' + $trimmed
        }
    }
}

# Write back to file
$newLines -join "`r`n" | Set-Content 'listprbk.sqlrpgle' -NoNewline
Write-Host "File formatted successfully"
