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

function Invoke-CliMenu {
    param(
        [string[]]$Options,
        [bool[]]$DefaultSelections
    )

    if ($DefaultSelections -and $DefaultSelections.Length -eq $Options.Length) {
        $selected = $DefaultSelections.Clone()
    } else {
        $selected = @($false) * $Options.Length
    }
    $cursor = 0

    while ($true) {
        [Console]::Clear()
        for ($i = 0; $i -lt $Options.Length; $i++) {
            $mark = if ($selected[$i]) { "[X]" } else { "[ ]" }
            $pointer = if ($i -eq $cursor) { ">" } else { " " }
            Write-Host "$pointer $mark $($Options[$i])"
        }
        Write-Host "`n[Space]: Select / [Enter]: Confirm / [Up/Down, k/j]: Navigate"

        $key = [Console]::ReadKey($true).Key
        if ($key -eq 'UpArrow' -and $cursor -gt 0) { $cursor-- }
        elseif ($key -eq 'DownArrow' -and $cursor -lt ($Options.Length - 1)) { $cursor++ }
        elseif ($key -eq 'k' -and $cursor -gt 0) { $cursor-- }
        elseif ($key -eq 'j' -and $cursor -lt ($Options.Length - 1)) { $cursor++ }
        elseif ($key -eq 'Spacebar') { $selected[$cursor] = -not $selected[$cursor] }
        elseif ($key -eq 'Enter') { break }
    }

    $result = @()
    for ($i = 0; $i -lt $Options.Length; $i++) {
        if ($selected[$i]) { $result += $Options[$i] }
    }
    return $result
}

Export-ModuleMember -Function Add-Path, Read-YesNo, Invoke-OptionalStep, Invoke-CliMenu
