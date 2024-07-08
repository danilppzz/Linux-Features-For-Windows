@echo off
REM Recorre todos los argumentos
:loop
if "%~1"=="" goto endloop

REM Verifica si el archivo existe
set file=%1
if not exist %file% (
    echo.>%file%
) else (
    copy /b %file% +,, >nul
)

REM Pasa al siguiente argumento
shift
goto loop

:endloop
