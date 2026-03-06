$content = Get-Content 'QRPGLESRC/bectran.sqlrpgle' -Raw
$lines = $content -split "`n"
$inCreditProc = $false
$result = @()

foreach ($line in $lines) {
    if ($line -match 'dcl-proc ProcessCreditXML') {
        $inCreditProc = $true
    }
    
    if ($inCreditProc -and $line -match 'end-proc' -and $line -notmatch 'dcl-proc') {
        $result += $line
        $inCreditProc = $false
    }
    elseif ($inCreditProc) {
        $result += $line -replace '\bnull_F', 'nullC_F'
    }
    else {
        $result += $line
    }
}

$result -join "`n" | Set-Content 'QRPGLESRC/bectran.sqlrpgle' -NoNewline
