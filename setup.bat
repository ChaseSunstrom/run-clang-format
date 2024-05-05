@echo off
setlocal enabledelayedexpansion

REM Set the path to the current directory where the batch script is located
set "script_dir=%~dp0"

REM Remove any trailing backslash from script_dir for consistency
if "%script_dir:~-1%"=="\" set "script_dir=%script_dir:~0,-1%"

REM Set the name of the Python script
set "script_name=run_clang_format.py"

REM Combine the directory and script name to get the full path
set "full_path=%script_dir%\%script_name%"

REM Assume the typical installation path of clang-format in LLVM
set "llvm_path=C:\Program Files\LLVM\bin"

REM Check if llvm_path is already in the PATH
echo %PATH% | findstr /I /C:"%llvm_path%" >nul 2>&1
if errorlevel 1 (
    echo Adding clang-format to PATH...
    REM Add llvm_path to the system PATH permanently
    setx PATH "%PATH%;%llvm_path%" /M
    REM Add llvm_path to the PATH for the current session
    set "PATH=%PATH%;%llvm_path%"
    echo clang-format has been added to PATH. Please restart your command prompt to see changes.
    pause
) else (
    echo clang-format is already in the PATH.
)

REM Add the script directory to the PATH if it's not already included
echo %PATH% | findstr /I /C:"%script_dir%" >nul 2>&1
if errorlevel 1 (
    echo Adding script directory to PATH...
    setx PATH "%script_dir%;%PATH%" /M
    set "PATH=%script_dir%;%PATH%"
    echo Script directory has been added to PATH. Please restart your command prompt to see changes.
    pause
) else (
    echo Script directory is already in the PATH.
)

REM Set an environment variable named RCF with the full path
setx RCF "python \"%full_path%\""
echo Environment variable RCF set to: python "%full_path%"

REM Output the current PATH to help with troubleshooting
echo Current PATH: %PATH%
pause

REM Run the Python script using the full path variable
call python "%full_path%"
if not errorlevel 1 (
    echo Script executed successfully.
) else (
    echo Failed to execute the script.
)
pause

:end_script
endlocal
