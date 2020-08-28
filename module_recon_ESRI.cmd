:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Author:		David Geeraerts
:: Location:	Olympia, Washington USA
:: E-Mail:		geeraerd@evergreen.edu
::
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Copyleft License(s)
:: GNU GPL (General Public License)
:: https://www.gnu.org/licenses/gpl-3.0.en.html
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:::::::::::::::::::::::::::
@Echo Off
setlocal enableextensions
:::::::::::::::::::::::::::

::#############################################################################
::							#DESCRIPTION#
::	SCRIPT STYLE: Recon
::		Will get information about ESRI software installations
::		
::#############################################################################

::::::::::::::::::::::::::::::::::
:: VERSIONING INFORMATION		::
::  Semantic Versioning used	::
::   http://semver.org/			::
::::::::::::::::::::::::::::::::::
::	Major.Minor.Revision
::	Added BUILD number which is used during development and testing.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

SET $SCRIPT_NAME=module_recon_ESRI
SET $SCRIPT_VERSION=1.1.0
SET $SCRIPT_BUILD=20200828-0820
Title %$SCRIPT_NAME% %$SCRIPT_VERSION%
Prompt mrE$G
color 0E
mode con:cols=70
mode con:lines=45
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
:: Declare Global variables
::	All User variables are set within here.
::		(configure variables)
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Log settings
::	Advise local storage for logging.
SET "LOG_LOCATION=%PUBLIC%\Logs"
::	Advise the default log file name.
SET LOG_FILE=%$SCRIPT_NAME%_%COMPUTERNAME%.txt




::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
::##### Everything below here is 'hard-coded' [DO NOT MODIFY] #####
::
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:: CONSOLE OUTPUT
ECHO  ******************************************************************
ECHO. 
ECHO      		%$SCRIPT_NAME% %$SCRIPT_VERSION%
ECHO.
ECHO  ******************************************************************
ECHO.
echo %DATE% %TIME%
ECHO Processing...
ECHO.
::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:: Check Log access
IF NOT EXIST %LOG_LOCATION% MD %LOG_LOCATION% || SET LOG_LOCATION=%PUBLIC%\Logs
:: What if log location gets set to Public
IF NOT EXIST %LOG_LOCATION% MD %LOG_LOCATION%
ECHO TEST %DATE% %TIME% > %LOG_LOCATION%\test_%LOG_FILE% || SET LOG_LOCATION=%TEMP%\Logs
:: What if log location gets set to temp
IF NOT EXIST %LOG_LOCATION% MD %LOG_LOCATION%
IF EXIST %LOG_LOCATION%\test_%LOG_FILE% DEL /Q %LOG_LOCATION%\test_%LOG_FILE%
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


:start
echo %DATE% %TIME% Start... > %LOG_LOCATION%\%LOG_FILE%
echo Script Name: %$SCRIPT_NAME% >> %LOG_LOCATION%\%LOG_FILE%
echo Script Version: %$SCRIPT_VERSION% >> %LOG_LOCATION%\%LOG_FILE%
echo Computer: %COMPUTERNAME% >> %LOG_LOCATION%\%LOG_FILE%
echo User: %USERNAME% >> %LOG_LOCATION%\%LOG_FILE%

openfiles 1> nul 2> nul
SET $ADMIN_STATUS=%ERRORLEVEL%
:: 0 = admin; 1 = user
IF %$ADMIN_STATUS% NEQ 0 GoTo skipAC
echo Running with administrative privelege!
echo (not recommended! Run as a standard user!)
echo.

Echo Continue or abort:
Echo.
Echo [1] Exit
echo [2] Continue
Echo.
Choice /c 12
Echo.
If ERRORLevel 2 GoTo runR
If ERRORLevel 1 GoTo clean
Echo.
: skipAC


:runR
echo Getting ESRI application information...
REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\ESRI /S 2>nul >> %LOG_LOCATION%\%LOG_FILE%
SET $QUERY_ERR=%ERRORLEVEL%
IF %$QUERY_ERR% EQU 1 echo ESRI software isn't installed on this system!
echo.
echo Getting ESRI legacy application information...
REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ESRI /S 2>nul >> %LOG_LOCATION%\%LOG_FILE% 
SET $QUERY_ERR_L=%ERRORLEVEL%
IF %$QUERY_ERR_L% EQU 1 echo Legacy ESRI software isn't installed on this system!
echo.
IF %$QUERY_ERR% EQU 1 IF %$QUERY_ERR_L% EQU 1 GoTo Clean

echo Recon file is here:
echo %LOG_LOCATION%\%LOG_FILE%
echo.
echo All done!
start notepad "%LOG_LOCATION%\%LOG_FILE%"

:clean
:: Cleanup up var directory
IF EXIST "%LOG_LOCATION%\var" RD /S /Q "%LOG_LOCATION%\var"

:end
echo %DATE% %TIME% End. >> %LOG_LOCATION%\%LOG_FILE%
ECHO. >> %LOG_LOCATION%\%LOG_FILE%

timeout /T 60
EXIT