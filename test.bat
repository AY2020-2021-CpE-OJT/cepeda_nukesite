:START
@echo off
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
echo ">>>>>>>>>>>>>>>>> ADDING <<<<<<<<<<<<<<<<<<"
git add .
git status

:COMMIT_PROMPT
set /p commit_choice="Would you like to commit?: "
IF '%commit_choice%' == 'yes' GOTO COMMIT_TRIGGER
IF '%commit_choice%' == 'no' GOTO START
GOTO COMMIT_PROMPT

:COMMIT_TRIGGER
echo ">>>>>>>>>>>>>>>>>COMMITING<<<<<<<<<<<<<<<<<<"
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
set /p push_choice="Confirm push?: "
IF '%push_choice%' == 'yes'  GOTO PUSH
IF '%push_choice%' == 'no' GOTO START
GOTO PUSH _PROMPT
:PUSH
git push
GOTO START

:EXIT