:: -----------------------------------------------------------------------------
:: -----------------------------------------------------------------------------
:: Batch script for building the Westwood Studios VQ library (WINVQ).
::
:: Builds the VQM32 and VQA32 component libraries only. The VPLAY32 and
:: VQAVIEW tools under WINVQ\ are intentionally excluded -- they are not
:: linked into the Red Alert game binary and are not part of this build.
::
:: Runs standalone (resolves the repo root from this script's location) and
:: is also safe to be called from the top-level MAKE.BAT via CALL.
:: -----------------------------------------------------------------------------
:: -----------------------------------------------------------------------------

@ECHO OFF
SETLOCAL ENABLEEXTENSIONS

:: -----------------------------------------------------------------------------
:: Resolve repo paths from this script's location.
:: %~dp0 is the directory containing this batch file (with trailing backslash).
:: -----------------------------------------------------------------------------
SET "WWVQ_ROOT=%~dp0"
IF "%WWVQ_ROOT:~-1%"=="\" SET "WWVQ_ROOT=%WWVQ_ROOT:~0,-1%"
FOR %%I IN ("%WWVQ_ROOT%\..") DO SET "PRJ_ROOT=%%~fI"

:: -----------------------------------------------------------------------------
:: Language selection (BUILD_LANG env override, defaulted to ENGLISH).
:: Valid options are: ENGLISH, FRENCH, GERMAN.
:: -----------------------------------------------------------------------------
SET "LANG=ENGLISH"
IF NOT "%BUILD_LANG%"=="" SET "LANG=%BUILD_LANG%"

IF NOT "%LANG%"=="ENGLISH" IF NOT "%LANG%"=="FRENCH" IF NOT "%LANG%"=="GERMAN" (
    @ECHO ERROR: BUILD_LANG must be ENGLISH, FRENCH, or GERMAN ^(got: %LANG%^)
    GOTO :FAIL
)

:: Uncomment to enable Watcom's debug output
::SET "WMAKE_DEBUG=/d"

:: -----------------------------------------------------------------------------
:: Toolchain paths
:: -----------------------------------------------------------------------------
SET "WATCOM=%PRJ_ROOT%\WATCOM106"
SET "WATCOM106=%PRJ_ROOT%\WATCOM106"
SET "WATCOM11=%PRJ_ROOT%\WATCOM11"
SET "TASM=%PRJ_ROOT%\TASM"
SET "MASM=%PRJ_ROOT%\MASM"
SET "LINKER=%PRJ_ROOT%\LINKER"
SET "UTILS=%PRJ_ROOT%\UTILS"

:: Reset PATH (Watcom has an ~8KB PATH limit) and rebuild with only the dirs
:: the toolchain needs.
SET "PATH=C:\Windows\System32"
SET "PATH=%WATCOM%\BINNT;%TASM%\BIN;%MASM%\BIN;%LINKER%\BIN;%UTILS%\BIN;%PATH%"

:: INCLUDE is used by the VQ library code and can cause conflicts -- clear it.
SET INCLUDE=

:: The VQM32 / VQA32 makefiles read %PRJ% to locate the WINVQ root.
SET "PRJ=%WWVQ_ROOT%"
SET "WWVQ=%WWVQ_ROOT%"

:: -----------------------------------------------------------------------------
:: Build VQM32
:: -----------------------------------------------------------------------------
@ECHO(
@ECHO ======================================================
@ECHO Building VQM32 [%LANG%]
@ECHO ======================================================

CD /D "%WWVQ_ROOT%\VQM32"

@ECHO ON
:: Update/copy headers into WINVQ\INCLUDE for downstream consumers.
WMAKE UPDATE
IF ERRORLEVEL 1 GOTO :FAIL
:: Build the VQM32 library.
WMAKE %WMAKE_DEBUG% WIN32=1 %LANG%=1 CLEAN ALL
IF ERRORLEVEL 1 GOTO :FAIL
@ECHO OFF

:: -----------------------------------------------------------------------------
:: Build VQA32
:: -----------------------------------------------------------------------------
@ECHO(
@ECHO ======================================================
@ECHO Building VQA32 [%LANG%]
@ECHO ======================================================

CD /D "%WWVQ_ROOT%\VQA32"

@ECHO ON
:: Update/copy headers into WINVQ\INCLUDE for downstream consumers.
WMAKE UPDATE
IF ERRORLEVEL 1 GOTO :FAIL
:: Build the VQA32 library.
WMAKE %WMAKE_DEBUG% WIN32=1 %LANG%=1 CLEAN ALL
IF ERRORLEVEL 1 GOTO :FAIL
@ECHO OFF

ENDLOCAL
EXIT /B 0

:FAIL
@ECHO ERROR: WINVQ build failed.
ENDLOCAL
EXIT /B 1
