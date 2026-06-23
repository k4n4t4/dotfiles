function InstallPackages {
    $packages = @(
        @{ Id = "7zip.7zip"; Name = "7-Zip" },
        @{ Id = "Mozilla.Firefox"; Name = "Firefox" },
        @{ Id = "Mozilla.Thunderbird"; Name = "Thunderbird" },
        @{ Id = "Obsidian.Obsidian"; Name = "Obsidian" },
        @{ Id = "Discord.Discord"; Name = "Discord" },
        @{ Id = "Valve.Steam"; Name = "Steam" },
        @{ Id = "Git.Git"; Name = "Git" }
    )

    $choices = @()
    foreach ($p in $packages) {
        $choices += $p.Name
    }
    
    $defaults = @($true) * $packages.Length
    $answers = Invoke-CliMenu -Options $choices -DefaultSelections $defaults
    Write-Host "`nSelected apps to install: $($answers -join ', ')"

    foreach ($package in $packages) {
        if ($answers -contains $package.Name) {
            winget install --exact --id $package.Id
        }
    }

    if ($answers -contains "Git") {
        if (Read-YesNo -Prompt "Add Git to PATH?" -Default $true) {
            Add-Path "C:\Program Files\Git\cmd"
        }
    }
}

function UninstallPackages {
    $packages = @(
        @{ Name = "Microsoft.WindowsSoundRecorder"; Label = "Sound Recorder" },
        @{ Name = "Microsoft.YourPhone"; Label = "Phone Link" },
        @{ Name = "MicrosoftCorporationII.MicrosoftFamily"; Label = "Microsoft Family" },
        @{ Name = "Microsoft.WindowsFeedbackHub"; Label = "Feedback Hub" },
        @{ Name = "Microsoft.WindowsCamera"; Label = "Camera" },
        @{ Name = "Microsoft.MicrosoftStickyNotes"; Label = "Sticky Notes" },
        @{ Name = "Microsoft.MicrosoftSolitaireCollection"; Label = "Solitaire Collection" },
        @{ Name = "Microsoft.GetHelp"; Label = "Get Help" },
        @{ Name = "Microsoft.Teams"; Label = "Teams" },
        @{ Name = "Microsoft.Todos"; Label = "To Do" },
        @{ Name = "Clipchamp.Clipchamp"; Label = "Clipchamp" },
        @{ Name = "B9ECED6F.ASUSPCAssistant"; Label = "ASUS PC Assistant" }
    )

    foreach ($package in $packages) {
        if (-not (Read-YesNo -Prompt "Uninstall $($package.Label)?" -Default $true)) {
            continue
        }

        $installed = Get-AppxPackage $package.Name
        if ($installed) {
            $installed | Remove-AppxPackage
            continue
        }

        Write-Host "Not installed: $($package.Label)" -ForegroundColor DarkGray
    }
}

Export-ModuleMember -Function InstallPackages, UninstallPackages
