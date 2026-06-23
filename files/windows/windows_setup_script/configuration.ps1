Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

Import-Module "$PSScriptRoot\modules\utils.psm1"

$modules = @(
    "winget.psm1",
    "uninstall_onedrive.psm1"
)

foreach ($module in $modules) {
    Import-Module "$PSScriptRoot\modules\$module" -Force
}

if (-not (Read-YesNo -Prompt "Start Windows setup?" -Default $true)) {
    Write-Host "Aborting..." -ForegroundColor Red
    exit 1
}

$steps = @(
    @{ Name = "Uninstall OneDrive"; Action = { UninstallOnedrive } },
    @{ Name = "Uninstall built-in apps"; Action = { UninstallPackages } },
    @{ Name = "Install apps (winget)"; Action = { InstallPackages } }
)

foreach ($step in $steps) {
    Invoke-OptionalStep -Name $step.Name -Action $step.Action -Default $true
}

Write-Host "All selected steps finished." -ForegroundColor Green
exit 0
