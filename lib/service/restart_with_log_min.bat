@echo off
set LOGFILE=restart_log.txt
set EXE_NAME=Software.exe
set EXE_PATH=C:\Path\To\Your\Software.exe

:loop
echo Starting %EXE_NAME% at %date% %time% >> %LOGFILE%
start "" "%EXE_PATH%"
timeout /t 1800 /nobreak
echo Terminating %EXE_NAME% at %date% %time% >> %LOGFILE%
taskkill /IM "%EXE_NAME%" /F
goto loop
