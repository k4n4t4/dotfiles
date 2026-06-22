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

  foreach ($package in $packages) {
    if (Read-YesNo -Prompt "Install $($package.Name)?" -Default $true) {
      winget install --exact --id $package.Id
    }
  }

  if (Read-YesNo -Prompt "Add Neovim to PATH?" -Default $true) {
    Add-Path "C:\Program Files\Neovim\bin"
  }

  if (Read-YesNo -Prompt "Add Git to PATH?" -Default $true) {
    Add-Path "C:\Program Files\Git\cmd"
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
