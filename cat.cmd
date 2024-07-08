@echo off
if "%~1"=="" (
    echo Usage: cat file_name
    goto end
)

type %1

:end
