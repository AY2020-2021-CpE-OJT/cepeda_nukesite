:START
@echo off
:START
echo.
set /p command="<--------------CLI--------------> ENTER COMMAND: "

IF '%command%' == 'exit' GOTO EXIT

IF '%command%' == 'add' GOTO ADD
IF '%command%' == 'add_file' GOTO ADD_FILE


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

IF '%command%' == 'rs_nukesite' GOTO REMOTE_SET_NUKESITE
IF '%command%' == 'rs_school' GOTO REMOTE_SET_SCHOOL
IF '%command%' == 'rs_school_mirror' GOTO REMOTE_SET_SP_MIRROR

IF '%command%' == 'branch' GOTO CHECK_BRANCHES
IF '%command%' == 'rbranch' GOTO CHECK_REMOTE_BRANCHES

IF '%command%' == 'set_branch' GOTO SET_BRANCH
IF '%command%' == 'new_branch' GOTO NEW_BRANCH

IF '%command%' == 'cls' CLS
GOTO START

:ADD_FILE
echo.
echo ">>>>>>>>>>>>>>>>> ADDING <<<<<<<<<<<<<<<<<<"
set /p file_to_add="Enter file name: "
git add %file_to_add%
git status
GOTO COMMIT_PROMPT

:ADD
echo.
echo ">>>>>>>>>>>>>>>>> ADDING <<<<<<<<<<<<<<<<<<"
git add .
git status

:COMMIT_PROMPT
echo.
set /p commit_choice="Would you like to commit?: "
IF '%commit_choice%' == 'yes' GOTO COMMIT_TRIGGER
IF '%commit_choice%' == 'no' GOTO START
GOTO COMMIT_PROMPT

:COMMIT_TRIGGER
echo.
echo ">>>>>>>>>>>>>>>>> COMMITING <<<<<<<<<<<<<<<<<<"
set /p message="Enter message: "
git commit -m "%message%"
GOTO START

:PUSH_PROMPT
echo.
echo ">>>>>>>>>>>>>>>>> PUSHING <<<<<<<<<<<<<<<<<<"
git status
set /p push_choice="Confirm push?: "
IF '%push_choice%' == 'yes' GOTO PUSH_TRIGGER
IF '%push_choice%' == 'no' GOTO START
GOTO PUSH_PROMPT

:PUSH_TRIGGER
echo.
echo ">>>>>>>>>>>>>>>>> UPLOADING<<<<<<<<<<<<<<<<<<"
git push
GOTO START

:FETCH
echo.
echo ">>>>>>>>>>>>>>>>> FETCHING <<<<<<<<<<<<<<<<<<"
git fetch
GOTO START

:PULL_PROMPT
echo.
echo ">>>>>>>>>>>>>>>>> PULLING <<<<<<<<<<<<<<<<<<"
git status
set /p pull_choice="Confirm pull?: "
IF '%pull_choice%' == 'yes' GOTO PULL_TRIGGER
IF '%pull_choice%' == 'no' GOTO START
GOTO PUSH_PROMPT

:PULL_TRIGGER
echo.
echo ">>>>>>>>>>>>>>>>> DOWNLOADING <<<<<<<<<<<<<<<<<<"
git pull
GOTO START

:CLONE
echo.
echo ">>>>>>>>>>>>>>>>> DOWNLOADING <<<<<<<<<<<<<<<<<<"
set /p clone_link="Enter url: "
git clone %clone_link%
GOTO START

:CHECK_BRANCHES
echo.
echo ">>>>>>>>>>>>>>>>> CHECKING BRANCHES <<<<<<<<<<<<<<<<<<"
git branch
GOTO START

:CHECK_REMOTE_BRANCHES
echo.
echo ">>>>>>>>>>>>>>>>> CHECKING REMOTE BRANCHES <<<<<<<<<<<<<<<<<<"
git branch -r
GOTO START

:SET_BRANCH
echo.
echo ">>>>>>>>>>>>>>>>> SETTING BRANCH <<<<<<<<<<<<<<<<<<"
git branch
echo.
set /p branch_transfer="Enter branch name: "
git checkout %branch_transfer%
GOTO START

: NEW_BRANCH
echo.
echo ">>>>>>>>>>>>>>>>> NEW BRANCH <<<<<<<<<<<<<<<<<<"
set /p branch_new="Enter branch name: "
git checkout -b %branch_new%
echo.
git branch
GOTO START

:REMOTE_SET_CUSTOM
echo.
echo ">>>>>>>>>>>>>>>>> REMOTE-SET <<<<<<<<<<<<<<<<<<"
set /p clone_link="Enter url: "
git remote add origin %clone_link%
GOTO START

:REMOTE_SET_SCHOOL
git remote remove origin
echo.
echo ">>>>>>>>>>>>>>>>> SETTING DEFAULT SCHOOL REMOTE <<<<<<<<<<<<<<<<<<"
git remote add origin https://github.com/AY2020-2021-CpE-OJT/cepeda_nukesite.git
echo.
git branch
echo.
set /p branch_transfer="Which branch?: "
git checkout %branch_transfer%
echo.
git push --set-upstream origin %branch_transfer%
GOTO START

:REMOTE_SET_SP_MIRROR
git remote remove origin
echo.
echo ">>>>>>>>>>>>>>>>> SETTING DEFAULT SCHOOL-PERSONAL MIRROR REMOTE <<<<<<<<<<<<<<<<<<"
git remote add origin https://github.com/KaiEzeckai22/school_mirror.git
echo.
git branch
echo.
set /p branch_transfer="Which branch?: "
git checkout %branch_transfer%
echo.
git push --set-upstream origin %branch_transfer%
GOTO START

:REMOTE_SET_NUKESITE
git remote remove origin
echo.
echo ">>>>>>>>>>>>>>>>> SETTING DEFAULT NUKESITE REMOTE <<<<<<<<<<<<<<<<<<"
git remote add origin https://github.com/KaiEzeckai22/nukesite.git
GOTO START

:TEST
echo.
echo ">>>>>>>>>>>>>>>>> TESTING <<<<<<<<<<<<<<<<<<"
GOTO START

:FULL_RESET
echo.
echo ">>>>>>>>>>>>>>>>> RESETTING <<<<<<<<<<<<<<<<<<"
git reset
GOTO START
:LOG
echo.
echo ">>>>>>>>>>>>>>>>> LOG <<<<<<<<<<<<<<<<<<"
git log
GOTO START

:STATUS
echo.
echo ">>>>>>>>>>>>>>>>> STATUS <<<<<<<<<<<<<<<<<<"
git status
GOTO START

:EXIT