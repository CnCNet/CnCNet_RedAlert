:: -----------------------------------------------------------------------------
:: -----------------------------------------------------------------------------
:: Batch script for building the Red Alert code (Win32 target).
::
:: Orchestrates the full build pipeline:
::   1. Builds WIN32LIB         (CALL WIN32LIB\MAKE.BAT)
::   2. Builds WINVQ            (CALL WINVQ\MAKE.BAT) -- VQM32 + VQA32 only
::   3. Builds the game in CODE (three WMAKE passes: release / playtest / internal)
:: -----------------------------------------------------------------------------
:: -----------------------------------------------------------------------------

@ECHO OFF
SETLOCAL ENABLEEXTENSIONS

:: -----------------------------------------------------------------------------
:: Language selection (BUILD_LANG env override, defaulted to ENGLISH).
:: Valid options are: ENGLISH, FRENCH, GERMAN, SPAIN (never used).
:: -----------------------------------------------------------------------------
SET "LANG=ENGLISH"
IF NOT "%BUILD_LANG%"=="" SET "LANG=%BUILD_LANG%"

IF NOT "%LANG%"=="ENGLISH" IF NOT "%LANG%"=="FRENCH" IF NOT "%LANG%"=="GERMAN" (
    @ECHO ERROR: BUILD_LANG must be ENGLISH, FRENCH, or GERMAN ^(got: %LANG%^)
    GOTO :FAIL
)

:: Build target. Only Win32 is supported by this script.
SET "WIN32=1"

:: Uncomment to enable Watcom's debug output
::SET "WMAKE_DEBUG=/d"

:: Set the working directory to the current repo directory
SET "PRJ_ROOT=%CD%"

:: -----------------------------------------------------------------------------
:: Repo paths
:: -----------------------------------------------------------------------------
SET "CODE_ROOT=%CD%\CODE"
SET "WWLIB_ROOT=%CD%\WIN32LIB"
SET "WWVQ_ROOT=%CD%\WINVQ"

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

:: Reset PATH (Watcom has an ~8KB PATH limit; inherited PATH often exceeds it)
:: and rebuild with only the dirs the toolchain needs.
SET "PATH=C:\Windows\System32"
SET "PATH=%WATCOM%\BINNT;%TASM%\BIN;%MASM%\BIN;%LINKER%\BIN;%UTILS%\BIN;%PATH%"

:: INCLUDE is used by the VQ library code and can cause conflicts, so lets clear it.
SET INCLUDE=

:: Westwood library paths
SET "WWLIB=%PRJ_ROOT%\WIN32LIB"
SET "WWVQ=%PRJ_ROOT%\WINVQ"

:: 3rd-party library paths
SET "DXMEDIA=%PRJ_ROOT%\DXMEDIA"
SET "DXSDK=%PRJ_ROOT%\DXSDK"
SET "GCL510=%PRJ_ROOT%\GCL510"
SET "DBWIN32=%PRJ_ROOT%\DBWIN32"
SET "WWIPX=%PRJ_ROOT%\IPX"

:: Path to MPEG DLL library. This was actually written by Westwood but the
:: source code is not available, so we use the pre-compiled library.
SET "MPEGLIB=%PRJ_ROOT%\MPEGLIB"

:: Source of this UUIDLIB is unknown, but it's required by the game makefile.
SET "UUIDLIB=%PRJ_ROOT%\UUIDLIB"

:: MS-DOS Player binary, required to run 16-bit DOS tools (TASM/TLINK/TDSTRIP/EBN
:: in the IPX build chain).
:: See: http://takeda-toshiya.my.coocan.jp/msdos/
SET "MSDOS=%UTILS%\MSDOS_i486_x86.EXE"


:: -----------------------------------------------------------------------------
:: Print build options
:: -----------------------------------------------------------------------------
@ECHO ======================================================
@ECHO Printing build options
@ECHO ======================================================
@ECHO LANG=%LANG%
@ECHO WIN32=%WIN32%
@ECHO PRJ_ROOT=%PRJ_ROOT%
@ECHO CODE_ROOT=%CODE_ROOT%
@ECHO WWLIB_ROOT=%WWLIB_ROOT%
@ECHO WWVQ_ROOT=%WWVQ_ROOT%
@ECHO WATCOM=%WATCOM%
@ECHO WATCOM106=%WATCOM106%
@ECHO WATCOM11=%WATCOM11%
@ECHO TASM=%TASM%
@ECHO MASM=%MASM%
@ECHO LINKER=%LINKER%
@ECHO UTILS=%UTILS%
@ECHO DXMEDIA=%DXMEDIA%
@ECHO DXSDK=%DXSDK%
@ECHO GCL510=%GCL510%
@ECHO DBWIN32=%DBWIN32%
@ECHO WWIPX=%WWIPX%
@ECHO MPEGLIB=%MPEGLIB%
@ECHO UUIDLIB=%UUIDLIB%
@ECHO MSDOS=%MSDOS%
@ECHO(
@ECHO PATH=%PATH%


:: -----------------------------------------------------------------------------
:: Build WIN32LIB (delegated to WIN32LIB\MAKE.BAT)
:: -----------------------------------------------------------------------------
CALL "%WWLIB_ROOT%\MAKE.BAT"
IF ERRORLEVEL 1 GOTO :FAIL


:: -----------------------------------------------------------------------------
:: Build WINVQ -- VQM32 + VQA32 (delegated to WINVQ\MAKE.BAT)
:: -----------------------------------------------------------------------------
CALL "%WWVQ_ROOT%\MAKE.BAT"
IF ERRORLEVEL 1 GOTO :FAIL


:: -----------------------------------------------------------------------------
:: Build Red Alert (three passes: release / playtest / internal)
:: -----------------------------------------------------------------------------
@ECHO ON
@ECHO(
@ECHO ======================================================
@ECHO Building Red Alert (Win32) [%LANG%]
@ECHO ======================================================
@ECHO OFF

CD /D "%CODE_ROOT%"

@ECHO ON
WMAKE %WMAKE_DEBUG% WIN32=%WIN32% %LANG%=1 RELEASE_VERSION=1 CLEAN ALL
IF ERRORLEVEL 1 GOTO :FAIL
WMAKE %WMAKE_DEBUG% WIN32=%WIN32% %LANG%=1 PLAYTEST_VERSION=1 CLEAN ALL
IF ERRORLEVEL 1 GOTO :FAIL
WMAKE %WMAKE_DEBUG% WIN32=%WIN32% %LANG%=1 INTERNAL_VERSION=1 CLEAN ALL
IF ERRORLEVEL 1 GOTO :FAIL
@ECHO OFF

GOTO :EXIT


:: -----------------------------------------------------------------------------
:FAIL
:: -----------------------------------------------------------------------------
@ECHO(
@ECHO ERROR: build failed.
ENDLOCAL
:: Pause for interactive sessions only (skip in CI where BUILD_LANG is set).
IF "%BUILD_LANG%"=="" (
    @ECHO(
    PAUSE
)
EXIT /B 1


:: -----------------------------------------------------------------------------
:EXIT
:: -----------------------------------------------------------------------------
ENDLOCAL
:: Pause for interactive sessions only (skip in CI where BUILD_LANG is set).
IF "%BUILD_LANG%"=="" (
    @ECHO(
    PAUSE
)
EXIT /B 0
