@echo off
goto :main

:print
    <nul set /p="%~1"
exit /b

:pause
    call :print "%~1"
    pause >nul
    echo;
exit /b

:main
    :: Get ESC
    for /f %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"
    set "WORK_PATH=%~dp0"
    set "PREFIX=%ESC%[36m[%~nx0]:%ESC%[m"

    :: Run as administrator
    net session >nul 2>&1
    if %errorLevel% neq 0 (
        echo %PREFIX% Please run this script as administrator!
        powershell -Command "Start-Process '%~f0' -Verb RunAs -WorkingDirectory \"%WORK_PATH%\""
        exit
    )


    echo %PREFIX% Starting powershell script ...

    powershell -ExecutionPolicy Bypass -File "%WORK_PATH%configuration.ps1"

    echo %PREFIX% Done

    call :pause "%PREFIX% Press any key ... "
exit
