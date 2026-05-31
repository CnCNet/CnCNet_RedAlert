:: -----------------------------------------------------------------------------
:: -----------------------------------------------------------------------------
:: Batch script for building Red Alert for ALL supported languages.
::
:: Invokes the top-level MAKE.BAT once per language (ENGLISH, FRENCH, GERMAN)
:: with BUILD_LANG set appropriately. Stops on the first language that fails;
:: the final exit code reflects overall success / failure.
:: -----------------------------------------------------------------------------
:: -----------------------------------------------------------------------------

@ECHO OFF
SETLOCAL ENABLEEXTENSIONS

:: Capture whether BUILD_LANG was set at entry. Used at the end to decide
:: whether to PAUSE for interactive invocation (e.g. double-click from
:: Explorer). When the caller pre-sets BUILD_LANG, we assume scripted /
:: CI context and skip the pause.
SET "_ORIGINAL_BUILD_LANG=%BUILD_LANG%"

@ECHO ======================================================
@ECHO Building Red Alert -- all languages
@ECHO ======================================================

CALL :BUILD_ONE ENGLISH
IF ERRORLEVEL 1 GOTO :FAIL

CALL :BUILD_ONE FRENCH
IF ERRORLEVEL 1 GOTO :FAIL

CALL :BUILD_ONE GERMAN
IF ERRORLEVEL 1 GOTO :FAIL

@ECHO(
@ECHO ======================================================
@ECHO All language builds completed successfully.
@ECHO ======================================================

IF "%_ORIGINAL_BUILD_LANG%"=="" (
    @ECHO(
    PAUSE
)
ENDLOCAL
EXIT /B 0


:: -----------------------------------------------------------------------------
:BUILD_ONE  -- subroutine: build a single language. Arg %1 = language name.
:: -----------------------------------------------------------------------------
@ECHO(
@ECHO ######################################################
@ECHO ### Language: %1
@ECHO ######################################################
SET "BUILD_LANG=%1"
CALL "%~dp0MAKE.BAT"
EXIT /B %ERRORLEVEL%


:: -----------------------------------------------------------------------------
:FAIL
:: -----------------------------------------------------------------------------
@ECHO(
@ECHO ======================================================
@ECHO ERROR: build failed for BUILD_LANG=%BUILD_LANG%
@ECHO ======================================================
IF "%_ORIGINAL_BUILD_LANG%"=="" (
    @ECHO(
    PAUSE
)
ENDLOCAL
EXIT /B 1
