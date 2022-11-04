@setlocal enableextensions enabledelayedexpansion
@echo off
for /F "tokens=3" %%a in ('dir /-c c:\ ^| find /i "bytes free"') do set availablespace=%%a
set availablespace=%availablespace:,=%
endlocal && set availablespace=%availablespace%
rem truncating end. loses precision
set /a kb=%availablespace:~0,-3%
set /a mb = kb/1024
set /a gb = mb/1024
set /a spacelimit=95
Echo                              *                
Echo ----------------------------------------------------------------
echo - Start Indexing If C Drive Used Space Is More Than :: %spacelimit% GB   -
echo - Currently Available Free Space In C Drive :: %gb% GB                -
if "%gb%" gtr "%spacelimit%" (
Echo Less Free Space So Running Indexing...............
net stop wsearch
REG ADD "HKLM\SOFTWARE\Microsoft\Windows Search" /v SetupCompletedSuccessfully /t REG_DWORD /d 0 /f
del "%ProgramData%\Microsoft\Search\Data\Applications\Windows\Windows.edb"
:wsearch
net start wsearch
IF NOT %ERRORLEVEL%==0 (goto :wsearch) ELSE goto :END

) else (
Echo - Enough Free Space So No Need To Run Indexing.                -
Echo ----------------------------------------------------------------
Echo                             *                              
)
:END