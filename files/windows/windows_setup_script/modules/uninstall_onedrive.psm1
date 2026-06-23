function UninstallOnedrive {
    if (Read-YesNo -Prompt "Stop OneDrive processes?" -Default $true) {
        Write-Host "Stopping OneDrive process..."
        $onedriveProcesses = Get-Process -Name "OneDrive" -ErrorAction SilentlyContinue
        if ($onedriveProcesses) {
            $onedriveProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
            $onedriveProcesses | Wait-Process
        }
    }

    if (Read-YesNo -Prompt "Uninstall OneDrive?" -Default $true) {
        Write-Host "Uninstalling OneDrive..."
        $onedriveSetupPath = "$env:SystemRoot\System32\OneDriveSetup.exe"
        if (Test-Path $onedriveSetupPath) {
            Start-Process -FilePath $onedriveSetupPath -ArgumentList "/uninstall" -Wait
        }
    }

    if (Read-YesNo -Prompt "Remove OneDrive folders for all users?" -Default $true) {
        Write-Host "Removing OneDrive folders for all users..."
        $users = Get-WmiObject Win32_UserProfile | Where-Object { $_.Special -eq $false }
        foreach ($user in $users) {
            $userProfile = $user.LocalPath
            $onedrivePath = Join-Path $userProfile "OneDrive"
            if (Test-Path $onedrivePath) {
                Remove-Item -Path $onedrivePath -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }

    if (Read-YesNo -Prompt "Remove OneDrive-related folders?" -Default $true) {
        Write-Host "Removing OneDrive related folders..."
        $paths = @(
            "$env:LOCALAPPDATA\Microsoft\OneDrive",
            "$env:ProgramData\Microsoft OneDrive",
            "C:\OneDriveTemp"
        )
        foreach ($path in $paths) {
            if (Test-Path $path) {
                Remove-Item -Path $path -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }

    if (Read-YesNo -Prompt "Remove OneDrive-related registry keys?" -Default $true) {
        Write-Host "Removing OneDrive registry keys..."

        $regPaths = @(
            "HKCU:\Software\Microsoft\OneDrive",
            "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe",
            "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\OneDriveSetup.exe"
        )
        foreach ($regPath in $regPaths) {
            if (Test-Path $regPath) {
                Remove-Item -Path $regPath -Recurse -Force -ErrorAction SilentlyContinue
            }
        }

        $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
        Remove-ItemProperty -Path $regPath -Name "OneDrive" -ErrorAction SilentlyContinue
    }

    Write-Host "OneDrive removal completed."
}

Export-ModuleMember -Function UninstallOnedrive
