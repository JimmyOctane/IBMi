$content = Get-Content bectran.sqlrpgle -Raw
$content = $content -replace "ProcessCustomerXML\('/home/bectran/' \+\s+%trim\(returnIFSFolderListDS\.FileNames\(i\)\)\);", "ProcessCustomerXML('/home/bectran/' + %trim(returnIFSFolderListDS.FileNames(i)));"
$content = $content -replace "ProcessCreditXML\('/home/bectran/' \+\s+%trim\(returnIFSFolderListDS\.FileNames\(i\)\)\);", "ProcessCreditXML('/home/bectran/' + %trim(returnIFSFolderListDS.FileNames(i)));"
$content | Set-Content bectran.sqlrpgle -NoNewline
