function Settings {
    if (Read-YesNo -Prompt "Add UTC setting?" -Default $true) {
        New-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\TimeZoneInformation" -Name "RealTimeIsUniversal" -Value 1 -PropertyType "DWord" -Force
    }
}
Export-ModuleMember -Function Settings
