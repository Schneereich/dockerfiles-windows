@echo off
REM original source: https://github.com/elastic/kibana/blob/master/bin/kibana.bat
REM modified source: https://github.com/sixeyed/diamol/blob/master/images/kibana/windows/kibana.bat

SETLOCAL

set SCRIPT_DIR=%~dp0
for %%I in ("%SCRIPT_DIR%..") do set DIR=%%~dpfI

REM use the local node - the bundled version in the Kibana download has been removed
set NODE="node"

set NODE_ENV="production"

If Not Exist "%NODE%" (
  IF Exist "%SYS_NODE%" (
    set "NODE=%SYS_NODE%"
  ) else (
    Echo unable to find usable node.js executable.
    Exit /B 1
  )
)

set "NODE_OPTIONS=--no-warnings --max-http-header-size=65536 %NODE_OPTIONS%" && "%NODE%" "%DIR%\src\cli" %*

:finally

ENDLOCAL