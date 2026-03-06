# Read the file
$lines = Get-Content 'bectran.sqlrpgle'

# Find and replace lines 370-424 (column list) with reformatted version
$newLines = @()
for ($i = 0; $i -lt $lines.Count; $i++) {
    $lineNum = $i + 1
    
    if ($lineNum -eq 370) {
        # Replace lines 370-424 with reformatted column list
        $newLines += '                    GUID, ACCTID, TRANID,'
        $newLines += '                    ADDR1, ADDR2, CITY, STATE,'
        $newLines += '                    ZIPCODE, COUNTRYID, ANSALRNG, ANSALBEC,'
        $newLines += '                    ANSALCLI, ANSALDSC, NUMEMP, NUMEMPBEC,'
        $newLines += '                    NUMEMPCLI, NUMEMPDSC, BECCUSTID, BECCRTDT,'
        $newLines += '                    CNTFNAME, CNTLNAME, CNTPHONE, CNTTITLE,'
        $newLines += '                    CNTEMAIL, CUSTDBA, CUSTLEGAL, DUNSNUMBER,'
        $newLines += '                    FAX, BUSEMAIL, FEDTAXID, PHONE,'
        $newLines += '                    STINCORP, YRESTAB, STYLEBIZ, STYBIZBEC,'
        $newLines += '                    STYBIZCLI, STYBIZDSC, TYPEBIZ, TYPBIZBEC,'
        $newLines += '                    TYPBIZCLI, TYPBIZDSC, REQUESTID, REQSRC,'
        $newLines += '                    AMTREQ, TERMREQCD, TERMREQDS, PLANPURCH,'
        $newLines += '                    REQDATE, REQFRMTYP, POREQ, ACNUMEXST,'
        $newLines += '                    CLIACCTID, ORDPEND, ORDPNDAMT, STATUS'
        # Skip original lines 370-424
        $i = 423  # Will increment to 424 at loop end
    }
    elseif ($lineNum -ge 371 -and $lineNum -le 424) {
        # Skip these lines (already handled above)
        continue
    }
    else {
        $newLines += $lines[$i]
    }
}

# Write back to file
$newLines | Set-Content 'bectran.sqlrpgle'
Write-Host "File reformatted successfully"
