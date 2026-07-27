$wayneSales=0.0; $wayneGP=0.0; $wayneRows=0
$wayne = Get-Content 'C:\JimmyOctane\IBMi\QRPGLESRC\wayne.rpgle'
foreach ($line in $wayne) {
    $cols = $line -split ','
    if ($cols.Count -ge 10) {
        $sr = $cols[8].Trim() -replace '[\$\s]','' -replace '^\((.+)\)$','-$1' -replace '[^0-9\.\-]',''
        $gr = $cols[9].Trim() -replace '[\$\s]','' -replace '^\((.+)\)$','-$1' -replace '[^0-9\.\-]',''
        $sv = 0.0; $gv = 0.0
        if ([double]::TryParse($sr,[ref]$sv) -and [double]::TryParse($gr,[ref]$gv)) {
            $wayneSales += $sv; $wayneGP += $gv; $wayneRows++
        }
    }
}

$detSales=0.0; $detCost=0.0; $detGP=0.0; $detRows=0
$salesdet = Get-Content 'C:\JimmyOctane\IBMi\QRPGLESRC\salesdet.rpgle'
foreach ($line in $salesdet) {
    $cols = $line -split ','
    if ($cols.Count -ge 12) {
        $sr = $cols[9].Trim(); $cr = $cols[10].Trim(); $gr = $cols[11].Trim()
        $sv=0.0; $cv=0.0; $gv=0.0
        if ([double]::TryParse($sr,[ref]$sv) -and [double]::TryParse($cr,[ref]$cv) -and [double]::TryParse($gr,[ref]$gv)) {
            $detSales += $sv; $detCost += $cv; $detGP += $gv; $detRows++
        }
    }
}

$salesDiff = $wayneSales - $detSales
$gpDiff    = $wayneGP - $detGP

Write-Output ""
Write-Output "============================================="
Write-Output "  DOLLAR VALUE COMPARISON - June 2026"
Write-Output "============================================="
Write-Output ""
Write-Output ("  {0,-22} {1,-22} {2}" -f "Metric","wayne.rpgle","salesdet.rpgle")
Write-Output "  ------------------------------------------------------------"
Write-Output ("  {0,-22} {1,-22} {2}" -f "Data rows",$wayneRows,$detRows)
Write-Output ("  {0,-22} {1,-22} {2}" -f "Total Sales",('{0:C2}' -f $wayneSales),('{0:C2}' -f $detSales))
Write-Output ("  {0,-22} {1,-22} {2}" -f "Total GP",('{0:C2}' -f $wayneGP),('{0:C2}' -f $detGP))
Write-Output ("  {0,-22} {1,-22} {2}" -f "Total Cost","N/A",('{0:C2}' -f $detCost))
Write-Output ""
Write-Output "  --- DIFFERENCES ---"
Write-Output ("  Sales Difference   : {0:C2}" -f $salesDiff)
Write-Output ("  GP Difference      : {0:C2}" -f $gpDiff)
Write-Output ""
if ([Math]::Abs($salesDiff) -lt 1.00) {
    Write-Output "  >> Sales totals MATCH (within dollar)"
} else {
    Write-Output ("  >> Sales are OFF by {0:C2}" -f [Math]::Abs($salesDiff))
}
if ([Math]::Abs($gpDiff) -lt 1.00) {
    Write-Output "  >> GP totals MATCH (within dollar)"
} else {
    Write-Output ("  >> GP is OFF by {0:C2}" -f [Math]::Abs($gpDiff))
}
Write-Output ""
