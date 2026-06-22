function DisableStartUp {
  # $startupPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup"
  # Remove-Item "$startupPath\Discord.lnk" -ErrorAction SilentlyContinue

  $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run"
  Remove-ItemProperty -Path $regPath -Name "OneDrive" -ErrorAction SilentlyContinue
}

Export-ModuleMember -Function DisableStartUp
