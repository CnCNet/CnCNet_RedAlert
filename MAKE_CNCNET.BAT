:: -----------------------------------------------------------------------------
:: -----------------------------------------------------------------------------
:: Build ONLY the CnCNet private variant of Red Alert
::   ENGLISH + CNCNET  ->  RUN\ENGLISH_CNCNET\
::
:: Thin wrapper: sets the CNCNET build mode and delegates to MAKE.BAT, which
:: handles the ENGLISH+CNCNET-only path (and resolves the private sources from
:: .env CNCNET_RED_ALERT_PRIVATE_REPO or CODE\CNCNET; it errors if neither is
:: present).
:: -----------------------------------------------------------------------------
:: -----------------------------------------------------------------------------

@ECHO OFF
SETLOCAL ENABLEEXTENSIONS

SET "CNCNET=1"
CALL "%~dp0MAKE.BAT"

ENDLOCAL & EXIT /B %ERRORLEVEL%
