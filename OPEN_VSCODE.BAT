@ECHO OFF
:: -----------------------------------------------------------------------------
:: Open this repository in Visual Studio Code.
:: -----------------------------------------------------------------------------

:: %~dp0 is this script's folder (the repo root), with a trailing backslash.
CALL code "%~dp0." %*
IF ERRORLEVEL 1 (
    @ECHO(
    @ECHO ERROR: could not launch VS Code. Is the 'code' command on your PATH?
    @ECHO        In VS Code: Ctrl+Shift+P -^> "Shell Command: Install 'code' command in PATH".
    @ECHO(
    PAUSE
)
