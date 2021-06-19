@echo off

set prompt_message="TEST: "
set choice="null"

:THIS_PROCESS
set /p choice=%prompt_message%
echo choice b4 = %choice%
call :DECISION_PROMPT %choice%
echo choice aft = %choice%
GOTO THIS_PROCESS




:DECISION_PROMPT
set /a "result=%~1+5"
echo result= %result%
set /i "%~1+=%result%"
rem IF '%decision%' == 'yes' set "%~1=return64"

:END_THIS_PROMPT
EXIT /B 0
