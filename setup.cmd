@echo off
echo Setting up your environment for Windows...

REM Step 1: Set Working Directory
SET BASE_DIR=%~dp0
cd /d "%BASE_DIR%"
IF NOT "%ERRORLEVEL%"=="0" (
    echo Error: Failed to change directory. Exiting.
    exit /b 1
)

echo Using working directory: "%BASE_DIR%"

REM Step 2: Check Python Installation
FOR /F "delims=" %%I IN ('where python3 2^>nul') DO SET PYTHON_EXECUTABLE=python3
IF NOT DEFINED PYTHON_EXECUTABLE (
    FOR /F "delims=" %%I IN ('where python 2^>nul') DO SET PYTHON_EXECUTABLE=python
)
IF NOT DEFINED PYTHON_EXECUTABLE (
    echo Error: Python is not installed. Please install Python 3.8 or later.
    exit /b 1
)

echo Using Python executable: %PYTHON_EXECUTABLE%

REM Step 3: Create Virtual Environment
IF NOT EXIST "venv" (
    echo Creating virtual environment...
    %PYTHON_EXECUTABLE% -m venv venv
    IF NOT "%ERRORLEVEL%"=="0" (
        echo Error: Failed to create virtual environment. Exiting.
        exit /b 1
    )
) ELSE (
    echo Virtual environment already exists. Skipping creation.
)

REM Step 4: Activate the Virtual Environment
IF EXIST "venv\Scripts\activate.bat" (
    CALL "venv\Scripts\activate.bat"
) ELSE (
    echo Error: Could not find the activation script. Exiting.
    exit /b 1
)

REM Debugging: Show Active Python Path
FOR /F "delims=" %%I IN ('where python') DO SET ACTIVE_PYTHON=%%I
echo Active Python executable: %ACTIVE_PYTHON%

REM Step 5: Upgrade pip
echo Upgrading pip...
pip install --upgrade pip
IF NOT "%ERRORLEVEL%"=="0" (
    echo Error: Failed to upgrade pip. Exiting.
    exit /b 1
)

REM Step 6: Install Requirements
IF EXIST "%BASE_DIR%requirements.txt" (
    echo Installing dependencies from requirements.txt...
    pip install -r "%BASE_DIR%requirements.txt"
    IF NOT "%ERRORLEVEL%"=="0" (
        echo Error: Failed to install dependencies. Exiting.
        exit /b 1
    )
) ELSE (
    echo Error: requirements.txt not found in "%BASE_DIR%". Please ensure it exists.
    exit /b 1
)

echo Setup complete! Use "run.cmd" or "./run.sh" to launch the app.

REM Step 7: Deactivate Virtual Environment
CALL deactivate
