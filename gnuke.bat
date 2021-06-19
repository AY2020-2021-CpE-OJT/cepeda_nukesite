@echo off
TITLE Gnuke
set remote_nukesite="https://github.com/KaiEzeckai22/nukesite.git"
set remote_school_mirror="https://github.com/KaiEzeckai22/school_mirror.git"
set remote_school="https://github.com/AY2020-2021-CpE-OJT/cepeda_nukesite.git"

:START
echo.
echo [4;43;97m                        GNUKE CLI                        [0m
set  /p  command="[4;104;30m ENTER COMMAND [0m "

IF '%command%' == 'res' GOTO START
IF '%command%' == 'exit' GOTO EXIT

IF '%command%' == 'init' GOTO GIT_INIT

IF '%command%' == 'add' GOTO ADD
IF '%command%' == 'add_file' GOTO ADD_FILE
IF '%command%' == 'addf' GOTO ADD_FILE

IF '%command%' == 'commit' GOTO COMMIT_PROMPT
IF '%command%' == 'force_commit' GOTO COMMIT_TRIGGER
IF '%command%' == 'force_comm' GOTO COMMIT_TRIGGER

IF '%command%' == 'fc' GOTO PUSH_TRIGGER

rem IF '%command%' == 'full_update' GOTO FULL_UPDATE

IF '%command%' == 'reset' GOTO BASE_RESET
IF '%command%' == 'hard_reset' GOTO HARD_RESET

IF '%command%' == 'undo' GOTO BASE_UNDO
IF '%command%' == 'undo_all' GOTO BASE_UNDO_ALL
IF '%command%' == 'revert' GOTO BASE_REVERT

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

IF '%command%' == 'rshow' GOTO REMOTE_SHOW

IF '%command%' == 'branch' GOTO CHECK_BRANCHES
IF '%command%' == 'rbranch' GOTO CHECK_REMOTE_BRANCHES

IF '%command%' == 'set_branch' GOTO SET_BRANCH
IF '%command%' == 'new_branch' GOTO NEW_BRANCH

IF '%command%' == 'custom_command' GOTO CUSTOM_COMMAND
IF '%command%' == 'xcom' GOTO CUSTOM_COMMAND
IF '%command%' == 'cls' CLS
GOTO START

:GIT_INIT
echo.
echo [4;104;30m                          INIT                           [0m
git init
GOTO START

:ADD_FILE
echo.
echo [4;104;30m                        ADDING FILE                      [0m
set  /p  file_to_add="[4;104;30m ENTER FILE NAME [0m "
echo.
git add %file_to_add%
git status
GOTO COMMIT_PROMPT

:ADD
echo.
echo [4;104;30m                        ADDING                           [0m
git add .
echo.
git status

:COMMIT_PROMPT
echo.
set  /p  commit_choice="[4;104;30m Would you like to commit? [0m "
IF '%commit_choice%' == 'yes' GOTO COMMIT_TRIGGER
IF '%commit_choice%' == 'no' GOTO START
GOTO COMMIT_PROMPT

:COMMIT_TRIGGER
echo.
echo [4;104;30m                        COMMITING                        [0m
set  /p  message="[4;104;30m Enter message: [0m "
git commit -m "%message%"
GOTO START

:PUSH_PROMPT
echo.
echo [4;104;30m                        PUSHING                          [0m
git status
set  /p  push_choice="[4;104;30m Confirm Push? [0m "
IF '%push_choice%' == 'yes' GOTO PUSH_TRIGGER
IF '%push_choice%' == 'no' GOTO START
GOTO PUSH_PROMPT

:PUSH_TRIGGER
echo.
echo [4;104;30m                        UPLOADING                        [0m
git push
GOTO START

:FETCH
echo.
echo [4;104;30m                        FETCHING                         [0m
git fetch
GOTO START

:PULL_PROMPT
echo.
echo [4;104;30m                        PULLING                          [0m
git status
set  /p  pull_choice="[4;104;30m Confirm Pull? [0m "
IF '%pull_choice%' == 'yes' GOTO PULL_TRIGGER
IF '%pull_choice%' == 'no' GOTO START
GOTO PUSH_PROMPT

:PULL_TRIGGER
echo.
echo [4;104;30m                        DOWNLOADING                      [0m
git pull
GOTO START

:CLONE
echo.
echo [4;104;30m                        CLONING                           [0m
set  /p  clone_link="[4;104;30m Enter URL: [0m "
git clone %clone_link%
GOTO START

:CHECK_BRANCHES
echo.
echo [4;104;30m                        CHECK BRANCHES                   [0m
git branch
GOTO START

:CHECK_REMOTE_BRANCHES
echo.
echo [4;104;30m                        CHECK REMOTE BRANCHES            [0m
git branch _r
GOTO START

:SET_BRANCH
echo.
echo [4;104;30m                        SET LOCAL BRANCH                 [0m
git branch
echo.
set  /p  branch_transfer="[4;104;30mEnter branch name: [0m "
git checkout %branch_transfer%
GOTO START

rem YOU ARE CURRENTLY EDITING HERE
: NEW_BRANCH
echo.
echo ">>>>>>>>>>>>>>>>> NEW BRANCH <<<<<<<<<<<<<<<<<<"
set  /p  branch_new="[4;104;30m WHICH BRANCH? [0m "
git checkout _b %branch_new%
echo.
git branch
GOTO START

:REMOTE_SHOW
echo.
echo ">>>>>>>>>>>>>>>>> REMOTE SHOW _ URL<<<<<<<<<<<<<<<<<<"
git remote show
echo FROM: 
git remote get_url --all origin
echo.

GOTO START

:REMOTE_SET_CUSTOM
echo.
echo ">>>>>>>>>>>>>>>>> REMOTE_SET <<<<<<<<<<<<<<<<<<"
set /p clone_link="Enter url: "
git remote add origin %clone_link%
GOTO START

:REMOTE_SET_SCHOOL
git remote remove origin
echo.
echo ">>>>>>>>>>>>>>>>> SETTING DEFAULT SCHOOL REMOTE <<<<<<<<<<<<<<<<<<"
git remote add origin %remote_school%
echo.
git branch
echo.
set  /p  branch_transfer="[4;104;30m WHICH BRANCH? [0m "
git checkout %branch_transfer%
echo.
git push --set_upstream origin %branch_transfer%
GOTO START

:REMOTE_SET_SP_MIRROR
git remote remove origin
echo.
echo ">>>>>>>>>>>>>>>>> SETTING DEFAULT SCHOOL_PERSONAL MIRROR REMOTE <<<<<<<<<<<<<<<<<<"
git remote add origin %remote_school_mirror%
echo.
git branch
echo.
set  /p  branch_transfer="[4;104;30m WHICH BRANCH? [0m "
git checkout %branch_transfer%
echo.
git push --set_upstream origin %branch_transfer%
GOTO START

:REMOTE_SET_NUKESITE
git remote remove origin
echo.
echo ">>>>>>>>>>>>>>>>> SETTING DEFAULT NUKESITE REMOTE <<<<<<<<<<<<<<<<<<"
git remote add origin %remote_nuksite%
echo.
git branch
echo.
set  /p  branch_transfer="[4;104;30m WHICH BRANCH? [0m "
git checkout %branch_transfer%
echo.
git push --set_upstream origin %branch_transfer%
GOTO START

:TEST
echo.
echo [4;40;97m                          TEST                           [0m
echo [4;41;97m                          TEST                           [0m
echo [4;42;97m                          TEST                           [0m
echo [4;43;97m                        GNUKE CLI                        [0m
echo [4;44;97m                        GNUKE CLI                        [0m
echo [4;46;97m                          TEST                           [0m
echo [4;47;97m                          TEST                           [0m
echo.
echo [4;100;30m                          TEST                           [0m
echo [4;101;30m                          TEST                           [0m
echo [4;102;30m                          TEST                           [0m
echo [4;103;30m                          TEST                           [0m

echo [4;104;30m                        GNUKE CLI                        [0m
echo [4;105;30m                          TEST                           [0m
echo [4;106;30m                          TEST                           [0m
echo [4;107;30m                          TEST                           [0m
GOTO START

:CUSTOM_COMMAND
echo.
echo [4;104;30m                         CUSTOM                          [0m
echo.
set  /p  custom_command="[4;104;30m ENTER COMMAND [0m "
%custom_command%
GOTO START 

:BASE_RESET
echo.
echo ">>>>>>>>>>>>>>>>> RESETTING <<<<<<<<<<<<<<<<<<"
git reset
GOTO START

:HARD_RESET
echo.
echo ">>>>>>>>>>>>>>>>> HARD RESET <<<<<<<<<<<<<<<<<<"
git log
echo.
set /p hard_reset_id="Revert to (ID): "
git reset  --hard %hard_reset_id%
GOTO START

:BASE_UNDO
echo.
echo ">>>>>>>>>>>>>>>>> UNDO <<<<<<<<<<<<<<<<<<"
set /p file_to_undo="Undo changes to: "
git checkout -- %file_to_undo%
GOTO START

:BASE_UNDO_ALL
echo.
echo ">>>>>>>>>>>>>>>>> UNDO ALL <<<<<<<<<<<<<<<<<<"
git checkout -- .
GOTO START

:BASE_REVERT
echo.
echo ">>>>>>>>>>>>>>>>> REVERT <<<<<<<<<<<<<<<<<<"
git log
echo.
set /p revert_id="Revert to (ID): "
git revert %revert_id%
GOTO START

:LOG
echo.
echo ">>>>>>>>>>>>>>>>> LOG <<<<<<<<<<<<<<<<<<"
git log
GOTO START

:STATUS
echo.
echo [4;104;30m                         STATUS                          [0m
git status
GOTO START

:EXIT