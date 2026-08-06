$path = 'c:\JimmyOctane\IBMi\QRPGLESRC\arr5616.sqlrpgle'
$bytes = [System.IO.File]::ReadAllBytes($path)
Write-Host "Total bytes: $($bytes.Length)"
$text = [System.Text.Encoding]::UTF8.GetString($bytes)
$idx = $text.IndexOf("Device is valid")
Write-Host "Index: $idx"
$snippet = $text.Substring($idx-30, 400)
foreach($ch in $snippet.ToCharArray()) {
    $code = [int]$ch
    if ($code -eq 13) { Write-Host "[CR]" -NoNewline }
    elseif ($code -eq 10) { Write-Host "[LF]" }
    else { Write-Host $ch -NoNewline }
}
