Set-Location 'c:\JimmyOctane\IBMi\QRPGLESRC'
$env:GIT_PAGER = ''
$diff = git diff HEAD~1 HEAD -- oer2063.sqlrpgle 2>&1
$diff | Where-Object { $_ -match '^\+[^+]' }
