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
IF '%command%' == 'pull' GOTO PULL_PROMPT
IF '%command%' == 'fetch' GOTO FETCH
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
echo ">>>>>>>>>>>>>>>>> COMMITING <<<<<<<<<<<<<<<<<<"
set /p message="Enter message: "
git commit -m "%message%"
GOTO START

:PUSH_PROMPT
echo ">>>>>>>>>>>>>>>>> PUSHING <<<<<<<<<<<<<<<<<<"
git status
set /p push_choice="Confirm push?: "
IF '%push_choice%' == 'yes' GOTO PUSH_TRIGGER
IF '%push_choice%' == 'no' GOTO START
GOTO PUSH_PROMPT

:PUSH_TRIGGER
git push
GOTO START

:FETCH
echo ">>>>>>>>>>>>>>>>> FETCHING <<<<<<<<<<<<<<<<<<"
git fetch
GOTO START

:PULL_PROMPT
echo ">>>>>>>>>>>>>>>>> PULLING <<<<<<<<<<<<<<<<<<"
git status
set /p pull_choice="Confirm pull?: "
IF '%pull_choice%' == 'yes' GOTO PULL_TRIGGER
IF '%pull_choice%' == 'no' GOTO START
GOTO PUSH_PROMPT

:PULL_TRIGGER
git pull
GOTO START

:TEST

:FULL_RESET
echo ">>>>>>>>>>>>>>>>> RESETTING <<<<<<<<<<<<<<<<<<"
git reset
GOTO START
:LOG
echo ">>>>>>>>>>>>>>>>> LOG <<<<<<<<<<<<<<<<<<"
git log
GOTO START

:STATUS
echo ">>>>>>>>>>>>>>>>> STATUS <<<<<<<<<<<<<<<<<<"
git status
GOTO START

:EXIT