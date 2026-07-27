# Compare $ values between wayne.rpgle and salesdet.rpgle

# ---- WAYNE.RPGLE ----
# Format: Order Number,Line Number,Invoice Date,Branch,Customer,,Product,Qty Shipped,Sales,GP,GM%,Delivery,...
# Sales = col index 8, GP = col index 9

$wayneSales = 0.0
$wayneGP = 0.0
$wayneRows = 0

$wayne = Get-Content 'C:\JimmyOctane\IBMi\QRPGLESRC\wayne.rpgle'
foreach ($line in $wayne) {
    $cols = $line -split ','
    if ($cols.Count -ge 10) {
        # Clean dollar signs, spaces, parens (negatives shown as ($112))
        $salesRaw = $cols[8].Trim() -replace '[\$\s]','' -replace '^\((.+)\)$','-$1' -replace '[^0-9\.\-]',''
        $gpRaw    = $cols[9].Trim() -replace '[\$\s]','' -replace '^\((.+)\)$','-$1' -replace '[^0-9\.\-]',''
        $salesVal = 0.0
        $gpVal    = 0.0
        if ([double]::TryParse($salesRaw, [ref]$salesVal) -and [double]::TryParse($gpRaw, [ref]$gpVal)) {
            $wayneSales += $salesVal
            $wayneGP    += $gpVal
            $wayneRows++
        }
    }
}

# ---- SALESDET.RPGLE ----
# Format: SalesmanID,Month,Century,Year,OrderNum,LineNum,Flag,Product,Qty,Sales,Cost,GP
# Sales = col index 9, Cost = col index 10, GP = col index 11

$detSales = 0.0
$detCost  = 0.0
$detGP    = 0.0
$detRows  = 0

$salesdet = Get-Content 'C:\JimmyOctane\IBMi\QRPGLESRC\salesdet.rpgle'
foreach ($line in $salesdet) {
    $cols = $line -split ','
    if ($cols.Count -ge 12) {
        $salesRaw = $cols[9].Trim()
        $costRaw  = $cols[10].Trim()
        $gpRaw    = $cols[11].Trim()
        $salesVal = 0.0
        $costVal  = 0.0
        $gpVal    = 0.0
        if ([double]::TryParse($salesRaw, [ref]$salesVal) -and
            [double]::TryParse($costRaw,  [ref]$costVal)  -and
            [double]::TryParse($gpRaw,    [ref]$gpVal)) {
            $detSales += $salesVal
            $detCost  += $costVal
            $detGP    += $gpVal
            $detRows++
        }
    }
}

# ---- OUTPUT ----
Write-Host ""
Write-Host "============================================="
Write-Host "  DOLLAR VALUE COMPARISON"
Write-Host "============================================="
Write-Host ""
Write-Host "FILE               : wayne.rpgle        salesdet.rpgle"
Write-Host "-----------------------------------------------------------"
Write-Host ("Data rows          : {0,-20} {1}" -f $wayneRows, $detRows)
Write-Host ("Total Sales        : {0,-20} {1}" -f ('{0:C2}' -f $wayneSales), ('{0:C2}' -f $detSales))
Write-Host ("Total GP           : {0,-20} {1}" -f ('{0:C2}' -f $wayneGP),    ('{0:C2}' -f $detGP))
if ($detCost -ne 0) {
    Write-Host ("Total Cost         : {0,-20} {1}" -f "N/A", ('{0:C2}' -f $detCost))
}
Write-Host ""
Write-Host "--- DIFFERENCES ---"
$salesDiff = $wayneSales - $detSales
$gpDiff    = $wayneGP - $detGP
Write-Host ("Sales Difference   : {0}" -f ('{0:C2}' -f $salesDiff))
Write-Host ("GP Difference      : {0}" -f ('{0:C2}' -f $gpDiff))
Write-Host ""
if ([Math]::Abs($salesDiff) -lt 1.00) {
    Write-Host "Sales totals MATCH (within $1)"
} else {
    Write-Host ("Sales are OFF by {0:C2}" -f [Math]::Abs($salesDiff))
}
if ([Math]::Abs($gpDiff) -lt 1.00) {
    Write-Host "GP totals MATCH (within $1)"
} else {
    Write-Host ("GP is OFF by {0:C2}" -f [Math]::Abs($gpDiff))
}
Write-Host ""
