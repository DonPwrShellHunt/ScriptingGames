#!/usr/local/bin/pwsh-preview
Write-Host "Confirming PowerShell Preview working in Code context"
Write-Warning -Message   "Need multiple commands to check debugging"
$showThis="A variable that is expanded on output"
Write-Output ('Show variable showThis:{0}' -f $showThis)
