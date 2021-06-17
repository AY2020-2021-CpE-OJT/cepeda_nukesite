:START
@echo off
 set tick=0
 echo %tick%
:START
set /p command="Enter command: "
IF '%command%' == 'exit' GOTO EXIT
IF '%command%' == 'add' GOTO ADD
IF '%command%' == 'commit' GOTO COMMIT_PROMPT
IF '%command%' == 'full_reset' GOTO FULL_RESET
IF '%command%' == 'log' GOTO LOG
IF '%command%' == 'status' GOTO STATUS
IF '%command%' == 'test' GOTO TEST
IF '%command%' == 'push' GOTO PUSH_PROMPT
IF '%command%' == 'cls' CLS
GOTO START

:ADD
git add .
git status
echo adding

:COMMIT_PROMPT
set /p choice="Would you like to commit?: "
IF '%choice%' == 'yes' GOTO COMMIT_TRIGGER
IF '%choice%' == 'no' GOTO START
GOTO COMMIT_PROMPT

:COMMIT_TRIGGER
set /p message="Enter message: "
git commit -m "%message%"
GOTO START


:TEST

:FULL_RESET
git reset
GOTO START
:LOG
git log
GOTO START

:STATUS
git status
GOTO START

:PUSH _PROMPT
git status
set /p choice="Confirm push?: "
IF '%choice%' == 'yes'  GOTO PUSH
IF '%choice%' == 'no' GOTO START
GOTO PUSH _PROMPT
:PUSH
git push

:EXIT