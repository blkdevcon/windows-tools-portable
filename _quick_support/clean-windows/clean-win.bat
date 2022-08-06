@echo off

color 0a &:: Set console color to dark green (hello hacker console)

:: Security check [1/3]
:: Exit if , script is run from a non-administrator account
:: Security check to ensure that the script is being run by an administrator.

@echo off

goto check_Permissions &::check permission to continue the script

:check_Permissions
echo Checking for administrator permissions...
timeout /t 1 &:: Administrator permissions are required to run this script.

cls &:: Clear the screen.

net session >nul 2>&1
if %errorLevel% == 0 (
    echo Success: You are running this script as an administrator.
) else (
    echo Error: You are not running this script as an administrator.
    exit /b 1
)

cls &:: Clear the screen.

:: Abort the script if there is any pending restart/reboot.
:: Security check [2/3]
:: Abort if any restart is pending

@echo off 

if exist %~dp0\restart.txt (
    echo Restart pending. Exiting.
    exit /b 1
)

:: This script will clean the Windows build directory.
:: FORCE SCRIPT TO WORK ON FULL SCREEN MODE
:VBSDynamicBuild 

SET TempVBSFile=%temp%\~tmpSendKeysTemp.vbs &:: SET TEMP VBS FILE
IF EXIST "%TempVBSFile%" DEL /F /Q "%TempVBSFile%" &:: IF TEMP VBS FILE EXISTS, DELETE IT

echo Set WshShell = WScript.CreateObject("WScript.Shell") >>"%TempVBSFile%" &:: ECHO SET WSH SHELL
echo Wscript.Sleep 1                                    >>"%TempVBSFile%" &:: ECHO WSCRIPT SLEEP 1
echo WshShell.SendKeys "{F11}"                            >>"%TempVBSFile%" &:: ECHO WSH SHELL SEND KEYS F11
echo Wscript.Sleep 1                                    >>"%TempVBSFile%" &:: ECHO WSCRIPT SLEEP 1

CSCRIPT //nologo "%TempVBSFile%"

title KARTHIK-V1.2-STABLE &:: title is needed cuz of the way the console is displayed
echo YOU ARE USING KARTHIK LAL WINDOWS CLEAN SCRIPT &:: Ofc we need to mention the tool before starting the script
timeout /t 3 &:: timeout is used to make the script wait for 3 seconds

:: Security check [3/3]
:: EULA Agreement (For the purpose of this script, the EULA is considered to be accepted if the user accepts it.)

@echo off

echo EULA Agreement - Please read the following EULA agreement.

echo [1] This script is provided as is with no warranty of any kind. The author is not responsible for any damage caused by this script.
echo [2] This script is designed to clean up the Windows operating system.
echo [3] This operation may take a few minutes/hours to complete.
echo [4] Please do not close the console window until the script is finished.
echo [5] This script is fully automated and does not require any user input to complete. (after accepting the EULA)
echo [6] This script will not clean up the following:
echo    [*] Windows Defender
echo    [*] Windows Defender Antivirus
echo    [*] Windows Defender Online
echo    [*] Windows Defender SmartScreen
echo    [*] Windows Defender Trust Center
echo    [*] Windows Defender Web Scan

@echo off

echo Do you accept the terms of the EULA? (y/n) &:: Accept EULA?
set /p EULA_Answer= Y/N: &:: Accept EULA?

if /i "%EULA_Answer%" == "Y" (
    echo EULA Accepted.
    goto EULA_Accepted
) else (
    echo EULA Rejected.
    goto EULA_Rejected
)

:EULA_Rejected

echo [===]
timeout /t 1 &:: EULA agreement aborted. (1/5)
cls
echo [======]
timeout /t 1 &:: EULA agreement aborted. (2/5)
cls
echo [==========]
timeout /t 1 &:: EULA agreement aborted. (3/5)
cls
echo [===============]
timeout /t 1 &:: EULA agreement aborted. (4/5)
cls
echo [====================]
timeout /t 1 &:: EULA agreement aborted. (5/5)
exit /b 1

:EULA_Accepted

echo BYE BYE EXPLORER.exe &:: lets make it look like a real program :)
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
cls
taskkill /f /im explorer.exe &:: kill the explorer.exe

echo Clearing DNS cache &:: Clearing DNS cache
ipconfig /flushdns &:: Flush DNS cache

echo Removing .log files &:: delete all the .log files
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del %windir%\KB*.log /f /q  &:: delete all the files with KB in the name

echo Removing System Tempory Files &:: delete all the files in the system tempory folder
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q %systemdrive%\*.tmp &:: delete all the .tmp files in the system drive

echo Removing *_mp files &:: delete all the files with _mp in the name
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q %systemdrive%\*._mp &:: delete all the ._mp files in the system drive

echo Removing *.log files &:: delete all the files with .log in the name
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q %systemdrive%\*.log &:: delete all the .log files in the system drive

echo Remvoing *.gid files &:: delete all the files with .gid in the name
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q %systemdrive%\*.gid &:: delete all the .gid files in the system drive

echo Removing *.chk files &:: delete all the files with .chk in the name
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q %systemdrive%\*.chk &:: delete all the .chk files in the system drive

echo Removing .old files &:: delete all the files with .old in the name
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q %systemdrive%\*.old &:: delete all the .old files in the system drive

echo Removing recycled files &:: delete all the files in the recycle bin
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q %systemdrive%\recycled\*.* &:: delete all the files in the recycle bin

echo Removing *.bak files &:: delete all the files with .bak in the name
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q %windir%\*.bak &:: delete all the .bak files in the system drive

echo Removing prefetch files &:: delete all the files with .pf in the name
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q %windir%\prefetch\*.* &:: delete all the .pf files in the system drive

echo Removing temp files &:: delete all the files in temp directory
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
rd /s /q %windir%\temp & md %windir%\temp &:: delete all the temp files from the system drive

echo Removing default stored cookies &:: delete all the stored cookies in the system drive
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /q %userprofile%\cookies\*.* &:: clear all the cookies in the user profile

echo Removing temporary_internet_files &:: delete all the files in the temporary internet files folder
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q "%userprofile%\local settings\temporary internet files\*.*" &:: delete all the files in the temporary internet files folder

echo Removing recent files &:: delete all the files in the recent files folder
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q "%userprofile%\recent\*.*" &:: delete all the files in the recent files folder | clearing the recent files folder having some issues on windows 11 (not sure why)

echo Scanning all protected system files, and replacing corrupted files &:: fix all the corrupted files in the system drive
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
sfc /scannow &:: scan all the protected system files and fix if any are corrupted

echo Print out directory_tree_list &:: print out the directory tree list
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
dir /s &:: check all directory_trees and print out the list (just for final view)

echo Clearing the system restore point &:: clear the system restore point
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
vssadmin delete shadows /all /quiet &:: clear all the system restore point shadows from the system drive (save's some space)

cls &:: clear the console

echo Thank you for using my script &:: GREETINGS
echo Regards KARTHIK LAL &:: REGARDS
timeout /t 4 &:: timeout is used to make the script wait for 1 seconds

echo Welcome back explorer.exe &:: lets make it look like a real program :)
explorer.exe &:: restart the explorer.exe which we already killed earlier

:: REMOVING THE TEMP DIRECTORY AT LAST , DUE TO SOME LOOPING ISSUE ON WINDOWS 11 (not sure why)
echo Finally REMOVING THE TEMP DIRECTORY &:: delete all the files in the temp directory
echo Removing local_settings__temp files &:: delete all the files in the local settings temp folder
timeout /t 1 &:: timeout is used to make the script wait for 1 seconds
del /f /s /q "%userprofile%\local settings\temp\*.*" &:: delete all the files in the local settings temp folder

&:: ================================================================
&:: AUTHOR: KARTHIK LAL & :: EMAIL: karthik.lal558@gmail.com
&:: DATE: 10-06-2022
&:: WINDOWS CLEANER SCRIPT - STABLE VERSION
&:: TOOLS ARE PROVIDED AS IS WITHOUT WARRANTY OF ANY KIND AND THE AUTHOR IS NOT RESPONSIBLE FOR ANY DAMAGE CAUSED BY THE USE OF THESE TOOLS
&:: USE AT YOUR OWN RISK
&:: FORCED TO RUN ONLY WITH ADMINISTRATOR PRIVILEGES.
&:: LICESNSE: GNU GENERAL PUBLIC LICENSE V3.0
&:: OPENSOURCE SOFTWARE LICENSE AGREEMENT FOR WINDOWS DISTRIBUTION SYSTEM (https://www.gnu.org/licenses/gpl-3.0.en.html)
&:: Copying and distribution of this file, with or without modification, are permitted in any medium without royalty provided the copyright notice and this notice are preserved.
&:: Copyright (c) 2022 KARTHIK LAL
&:: ================================================================