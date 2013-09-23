@echo off
REM turns off script execution restrictions for Powershell
REM Version: 1.0 20130923 Author: Dennis Chow dchow [AT] xtecsystems.com
REM This script is licensed under GPL v3


echo About:
cls
echo .
echo About:
echo This script uses the System.Net.Dns calls for IPv4 resolution from an expanded AD Computername Query into a CSV file.
echo .
echo Notes: Becareful in using 0 (aka no limit) if you've got a non-specific search. You must be have .NET 3.0 framework installed and above.
echo .
echo Instructions: Follow prompts on screen.
echo .

SET /P ANSWER=Select (1) Continue (2) Exit?
echo You chose: %ANSWER%
if /i {%ANSWER%}=={1} (goto :continue)
if /i {%ANSWER%}=={2} (goto :exit)
goto :exit

:continue
echo Starting up...
REM turns off script execution restrictions for Powershell
powershell.exe -executionpolicy unrestricted -command .\adquery_dns_host_search.ps1
echo Press any key to exit...
pause
REM using /b with the exit parameters exits subroutine but not cmd.exe
exit /b 0

:exit
echo Starting up...
echo Press any key to exit...
pause
exit /b 1
