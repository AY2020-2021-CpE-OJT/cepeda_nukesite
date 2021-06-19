@echo off

set prompt_message="TEST: "
set choice="null"

:THIS_PROCESS
set /p choice=%prompt_message%
call :THIS_PROMPT %choice%

GOTO THIS_PROCESS




:THIS_PROMPT
set /a "c=%~1+1"
echo result = %c%

:END_THIS_PROMPT
EXIT /B 0
