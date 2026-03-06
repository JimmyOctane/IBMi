# Read the file
$content = Get-Content 'QRPGLESRC/bectran.sqlrpgle' -Raw

# Fix ProcessCreditXML procedure (lines 484-540) - add numbers back
$counter = 1
$content = $content -replace '(?<=dcl-proc ProcessCreditXML;.*?dcl-s )null_X(?= int\(10\) inz\(0\);)', {
    param($match)
    $result = "null_X$counter"
    $script:counter++
    return $result
}

# Reset counter for SQL SELECT statement replacements in ProcessCreditXML
$counter = 1
$inCreditProc = $false
$lines = $content -split "`r?`n"
$result = New-Object System.Collections.ArrayList

for ($i = 0; $i < $lines.Count; $i++) {
    $line = $lines[$i]
    
    # Track if we're in ProcessCreditXML procedure
    if ($line -match 'dcl-proc ProcessCreditXML;') {
        $inCreditProc = $true
        $counter = 1
    }
    elseif ($line -match 'end-proc;' -and $inCreditProc) {
        $inCreditProc = $false
    }
    
    # Replace :null_X with :null_X1, :null_X2, etc. in ProcessCreditXML SQL
    if ($inCreditProc -and $line -match ':null_X[,\s]') {
        $line = $line -replace ':null_X(?=[,\s])', ":null_X$counter"
        $counter++
    }
    
    [void]$result.Add($line)
}

# Join lines back together
$content = $result -join "`r`n"

# Write the file back
$content | Set-Content 'QRPGLESRC/bectran.sqlrpgle' -NoNewline
Write-Host "Fixed ProcessCreditXML null indicators"
