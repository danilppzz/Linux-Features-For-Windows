
@echo off
REM Check if at least one argument is provided
if "%~1"=="" goto usage

REM Process each argument
:loop
if "%~1"=="" goto endloop

REM Check the argument for the type of IP addresses to display
if /I "%~1"=="a" (
    echo.
    ipconfig | findstr /R /C:"IPv4 Address" /C:"IPv6 Address"
    echo.
) else if /I "%~1"=="ipv4" (
    echo Displaying only IPv4 addresses:
    ipconfig | findstr /R /C:"IPv4 Address"
) else if /I "%~1"=="ipv6" (
    echo Displaying only IPv6 addresses:
    ipconfig | findstr /R /C:"IPv6 Address"
) else if /I "%~1"=="all" (
    echo Displaying all network information:
    ipconfig /all
) else if /I "%~1"=="dns" (
    echo Displaying DNS server information:
    ipconfig /displaydns
) else if /I "%~1"=="renew" (
    echo Renewing IP addresses:
    ipconfig /renew
) else if /I "%~1"=="release" (
    echo Releasing IP addresses:
    ipconfig /release
) else (
    echo Invalid argument: %~1
    echo Usage: ip.cmd [a|v4|ipv6|all|dns|renew|release]
)

REM Move to the next argument
shift
goto loop

:endloop
goto end

:usage
echo Usage: ip.cmd [a|v4|ipv6|all|dns|renew|release]
goto end

:end
