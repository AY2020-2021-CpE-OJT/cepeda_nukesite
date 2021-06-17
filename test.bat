:START
@echo off
:START
set /p command="<--------------CLI--------------> ENTER COMMAND: "
IF '%command%' == 'exit' GOTO EXIT

IF '%command%' == 'add' GOTO ADD

IF '%command%' == 'commit' GOTO COMMIT_PROMPT
IF '%command%' == 'force_commit' GOTO COMMIT_TRIGGER
IF '%command%' == 'force_comm' GOTO COMMIT_TRIGGER

IF '%command%' == 'fc' GOTO PUSH_TRIGGER

rem IF '%command%' == 'full_update' GOTO FULL_UPDATE

IF '%command%' == 'full_reset' GOTO FULL_RESET

IF '%command%' == 'log' GOTO LOG

IF '%command%' == 'status' GOTO STATUS
IF '%command%' == 'stat' GOTO STATUS

IF '%command%' == 'test' GOTO TEST

IF '%command%' == 'push' GOTO PUSH_PROMPT
IF '%command%' == 'force_push' GOTO PUSH_TRIGGER
IF '%command%' == 'fpush' GOTO PUSH_TRIGGER

IF '%command%' == 'pull' GOTO PULL_PROMPT
IF '%command%' == 'force_pull' GOTO PULL_TRIGGER
IF '%command%' == 'fpull' GOTO PULL_TRIGGER

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
echo ">>>>>>>>>>>>>>>>> UPLOADING<<<<<<<<<<<<<<<<<<"
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
echo ">>>>>>>>>>>>>>>>> DOWNLOADING <<<<<<<<<<<<<<<<<<"
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