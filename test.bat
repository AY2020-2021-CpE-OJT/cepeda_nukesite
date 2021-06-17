:START
@echo off
 set tick=0
 echo %tick%
:AFT _NIT
set /p command="Enter command: "
IF '%command%' == 'exit' GOTO EXIT
IF '%command%' == 'add' GOTO ADD
IF '%command%' == 'full_reset' GOTO FULL_RESET
IF '%command%' == 'log' GOTO LOG
IF '%command%' == 'status' GOTO STATUS
IF '%command%' == 'test' GOTO TEST
IF '%command%' == 'push' GOTO PUSH
IF '%command%' == 'cls' CLS
GOTO START

:ADD
git add .
git status
echo adding

:COMMIT_PROMPT
set /p choice="Would you like to commit?: "
IF '%choice%' == 'yes' GOTO COMMIT_TRIGGER
IF '%choice%' == 'no' GOTO AFT _NIT
GOTO COMMIT_PROMPT

:COMMIT_TRIGGER
set /p message="Enter message: "
git commit -m %message%
git log
GOTO AFT _NIT


:TEST

:FULL_RESET
git reset
GOTO AFT _NIT
:LOG
git log
GOTO AFT _NIT

:STATUS
git status
GOTO AFT _NIT
:PUSH
git status
:PUSH _PROMPT
set /p choice="Confirm push?: "
IF '%choice%' == 'yes' git push
IF '%choice%' == 'no' GOTO AFT _NIT
GOTO PUSH _PROMPT
git push

:EXIT