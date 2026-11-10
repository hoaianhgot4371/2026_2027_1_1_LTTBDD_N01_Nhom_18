param([Parameter(Mandatory=$true)][string]$Batch)
$ErrorActionPreference = 'Continue'
$flutter = 'C:\Users\hoaia\develop\flutter\bin\flutter.bat'
$logDir = Join-Path $PSScriptRoot '../docs/verification'
New-Item -ItemType Directory -Force $logDir | Out-Null
$logFile = Join-Path $logDir "$Batch.txt"
"Verification batch: $Batch`nLocal timestamp: $([DateTimeOffset]::Now.ToString('o'))" | Set-Content -Encoding UTF8 $logFile
function Save-Line {
  process {
    $line = "$PSItem".TrimEnd()
    Write-Output $line
    Add-Content -LiteralPath $logFile -Encoding UTF8 -Value $line
  }
}
foreach ($arguments in @(@('analyze'), @('test'), @('build','apk','--release'))) {
  "`n> flutter $arguments" | Save-Line
  & $flutter @arguments 2>&1 | Save-Line
  $code = $LASTEXITCODE
  "Exit code: $code" | Save-Line
  if ($code -ne 0) { exit $code }
}
"`n> git diff --check" | Save-Line
git diff --check 2>&1 | Save-Line
$code = $LASTEXITCODE
"Exit code: $code" | Save-Line
if ($code -ne 0) { exit $code }
"`n> git diff --cached --check" | Save-Line
git diff --cached --check 2>&1 | Save-Line
$code = $LASTEXITCODE
"Exit code: $code" | Save-Line
exit $code
