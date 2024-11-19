@echo off
echo Running the application...

REM Step 1: Activate the virtual environment
IF EXIST "venv\Scripts\activate.bat" (
    CALL "venv\Scripts\activate.bat"
) ELSE (
    echo Error: Virtual environment not found. Please run setup.cmd first to create it.
    exit /b 1
)

REM Step 2: Prompt the user for the OpenAI API key
SET /P api_key=Enter your OpenAI API key: 

REM Step 3: Set the API key as an environment variable
SET OPENAI_API_KEY=%api_key%

REM Step 4: Run the application
python app\main.py
IF NOT "%ERRORLEVEL%"=="0" (
    echo Error: Failed to run the application.
    exit /b 1
)

REM Step 5: Deactivate the virtual environment
CALL deactivate

echo Application finished running.
