param([Parameter(Mandatory=$true)][string]$Batch)
$ErrorActionPreference = 'Continue'
$flutter = 'C:\Users\hoaia\develop\flutter\bin\flutter.bat'
$logDir = Join-Path $PSScriptRoot '../docs/verification'
New-Item -ItemType Directory -Force $logDir | Out-Null
$logFile = Join-Path $logDir "$Batch.txt"
"Verification batch: $Batch`nLocal timestamp: $([DateTimeOffset]::Now.ToString('o'))" | Set-Content -Encoding UTF8 $logFile
foreach ($arguments in @(@('analyze'), @('test'), @('build','apk','--release'))) {
  "`n> flutter $arguments" | Tee-Object -FilePath $logFile -Append
  & $flutter @arguments 2>&1 | ForEach-Object { "$PSItem" } | Tee-Object -FilePath $logFile -Append
  $code = $LASTEXITCODE
  "Exit code: $code" | Tee-Object -FilePath $logFile -Append
  if ($code -ne 0) { exit $code }
}
"`n> git diff --check" | Tee-Object -FilePath $logFile -Append
git diff --check 2>&1 | Tee-Object -FilePath $logFile -Append
$code = $LASTEXITCODE
"Exit code: $code" | Tee-Object -FilePath $logFile -Append
exit $code
