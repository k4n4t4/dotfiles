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
        @{ Id = "Microsoft.WindowsSoundRecorder"; Name = "Sound Recorder" },
        @{ Id = "Microsoft.YourPhone"; Name = "Phone Link" },
        @{ Id = "MicrosoftCorporationII.MicrosoftFamily"; Name = "Microsoft Family" },
        @{ Id = "Microsoft.WindowsFeedbackHub"; Name = "Feedback Hub" },
        @{ Id = "Microsoft.WindowsCamera"; Name = "Camera" },
        @{ Id = "Microsoft.MicrosoftStickyNotes"; Name = "Sticky Notes" },
        @{ Id = "Microsoft.MicrosoftSolitaireCollection"; Name = "Solitaire Collection" },
        @{ Id = "Microsoft.GetHelp"; Name = "Get Help" },
        @{ Id = "Microsoft.Teams"; Name = "Teams" },
        @{ Id = "Microsoft.Todos"; Name = "To Do" },
        @{ Id = "Clipchamp.Clipchamp"; Name = "Clipchamp" },
        @{ Id = "B9ECED6F.ASUSPCAssistant"; Name = "ASUS PC Assistant" }
    )

    $choices = @()
    foreach ($p in $packages) {
        $choices += $p.Name
    }
    
    $defaults = @($true) * $packages.Length
    $answers = Invoke-CliMenu -Options $choices -DefaultSelections $defaults
    Write-Host "`nSelected apps to uninstall: $($answers -join ', ')"

    foreach ($package in $packages) {
        if ($answers -contains $package.Name) {
            $installed = Get-AppxPackage $package.Id
            if ($installed) {
                $installed | Remove-AppxPackage
                continue
            }

            Write-Host "Not installed: $($package.Name)" -ForegroundColor DarkGray
        }
    }
}

Export-ModuleMember -Function InstallPackages, UninstallPackages
