# Add path if missing
function Add-Path {
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $current = [System.Environment]::GetEnvironmentVariable(
        "Path",
        [System.EnvironmentVariableTarget]::Machine
    )

    $paths = @()
    if ($current) {
        $paths = $current -split ';' | Where-Object { $_ -ne '' }
    }

    if ($paths -icontains $Path) { return }

    [System.Environment]::SetEnvironmentVariable(
        "Path",
        ($paths + $Path) -join ';',
        [System.EnvironmentVariableTarget]::Machine
    )
}

function Read-YesNo {
    param(
        [string]$Prompt = "Continue?",
        [bool]$Default = $true
    )

    while ($true) {
        $defaultText = if ($Default) { "Y/n" } else { "y/N" }
        $response = Read-Host "$Prompt [$defaultText]"

        if ([string]::IsNullOrWhiteSpace($response)) {
            return $Default
        }

        switch ($response.Trim().ToLowerInvariant()) {
            "y" { return $true }
            "yes" { return $true }
            "n" { return $false }
            "no" { return $false }
            default { Write-Host "Please answer y or n." -ForegroundColor Yellow }
        }
    }
}

function Invoke-OptionalStep {
    param(
        [Parameter(Mandatory)]
        [string]$Name,
        [Parameter(Mandatory)]
        [scriptblock]$Action,
        [bool]$Default = $true
    )

    if (Read-YesNo -Prompt "Run '$Name'?" -Default $Default) {
        Write-Host "Running: $Name" -ForegroundColor Cyan
        & $Action
        return
    }

    Write-Host "Skipped: $Name" -ForegroundColor DarkGray
}

Export-ModuleMember -Function Add-Path, Read-YesNo, Invoke-OptionalStep
