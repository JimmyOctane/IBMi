$file = 'QRPGLESRC/bectran.sqlrpgle'
$content = [System.IO.File]::ReadAllText($file)
$start = $content.IndexOf('dcl-proc ProcessCreditXML;')
$end = $content.IndexOf('end-proc;', $start) + 9
$before = $content.Substring(0, $start)
$middle = $content.Substring($start, $end - $start)
$after = $content.Substring($end)
$middle = $middle -replace '\bnull_F', 'nullC_F'
[System.IO.File]::WriteAllText($file, $before + $middle + $after)
Write-Host "Replacement complete"
