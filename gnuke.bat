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
IF '%command%' == 'fcomm' GOTO COMMIT_TRIGGER

rem IF '%command%' == 'full_update' GOTO FULL_UPDATE

IF '%command%' == 'reset' GOTO BASE_RESET
IF '%command%' == 'hard_reset' GOTO HARD_RESET

IF '%command%' == 'undo' GOTO BASE_UNDO
IF '%command%' == 'undo_all' GOTO BASE_UNDO_ALL
IF '%command%' == 'revert' GOTO BASE_REVERT

IF '%command%' == 'log' GOTO LOG

IF '%command%' == 'status' GOTO STATUS
IF '%command%' == 'stat' GOTO STATUS

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
IF '%command%' == 'rs_custom' GOTO REMOTE_SET_CUSTOM

IF '%command%' == 'rshow' GOTO REMOTE_SHOW

IF '%command%' == 'branch' GOTO CHECK_BRANCHES
IF '%command%' == 'rbranch' GOTO CHECK_REMOTE_BRANCHES

IF '%command%' == 'set_branch' GOTO SET_BRANCH
IF '%command%' == 'new_branch' GOTO NEW_BRANCH

IF '%command%' == 'custom_command' GOTO CUSTOM_COMMAND
IF '%command%' == 'xcom' GOTO CUSTOM_COMMAND

IF '%command%' == 'cls' CLS
IF '%command%' == 'test' GOTO TEST
IF '%command%' == 'ghelp' GOTO GNUKE_HELP


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
IF '%commit_choice%' == 'YES' GOTO COMMIT_TRIGGER
IF '%commit_choice%' == 'Yes' GOTO COMMIT_TRIGGER
IF '%commit_choice%' == 'yes' GOTO COMMIT_TRIGGER
IF '%commit_choice%' == 'Y' GOTO COMMIT_TRIGGER
IF '%commit_choice%' == 'y' GOTO COMMIT_TRIGGER
IF '%commit_choice%' == 'NO' GOTO START
IF '%commit_choice%' == 'No' GOTO START
IF '%commit_choice%' == 'no' GOTO START
IF '%commit_choice%' == 'N' GOTO START
IF '%commit_choice%' == 'n' GOTO START
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
IF '%push_choice%' == 'YES' GOTO  PUSH_TRIGGER
IF '%push_choice%' == 'Yes' GOTO  PUSH_TRIGGER
IF '%push_choice%' == 'yes' GOTO  PUSH_TRIGGER
IF '%push_choice%' == 'Y' GOTO  PUSH_TRIGGER
IF '%push_choice%' == 'y' GOTO  PUSH_TRIGGER
IF '%push_choice%' == 'NO' GOTO START
IF '%push_choice%' == 'No' GOTO START
IF '%push_choice%' == 'no' GOTO START
IF '%push_choice%' == 'N' GOTO START
IF '%push_choice%' == 'n' GOTO START
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
IF '%pull_choice%' == 'YES' GOTO  PULL_TRIGGER
IF '%pull_choice%' == 'Yes' GOTO  PULL_TRIGGER
IF '%pull_choice%' == 'yes' GOTO  PULL_TRIGGER
IF '%pull_choice%' == 'Y' GOTO  PULL_TRIGGER
IF '%pull_choice%' == 'y' GOTO  PULL_TRIGGER
IF '%pull_choice%' == 'NO' GOTO START
IF '%pull_choice%' == 'No' GOTO START
IF '%pull_choice%' == 'no' GOTO START
IF '%pull_choice%' == 'N' GOTO START
IF '%pull_choice%' == 'n' GOTO START
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


: NEW_BRANCH
echo.
echo [4;104;30m                        NEW BRANCH                       [0m
set  /p  branch_new="[4;104;30m BRANCH NAME? [0m "
git checkout -b %branch_new%
echo.
git branch
GOTO START

:REMOTE_SHOW
echo.
echo [4;104;30m                        REMOTE SHOW URL                  [0m
git remote show
echo FROM: 
git remote get-url --all origin
echo.

GOTO START

:BASE_CLONE
echo.
git remote remove origin
echo [4;104;30m                        CLONE                            [0m
set  /p  clone_link="[4;104;30m Clone URL [0m "
git remote add origin %clone_link%
GOTO START

:REMOTE_SET_CUSTOM
git remote remove origin
echo.
echo [4;104;30m                        SET CUSTOM REMOTE                [0m
set  /p  custom_remote_link="[4;104;30m Remote URL [0m "
git remote add origin %custom_remote_link%
echo.
git branch
echo.
set  /p  branch-transfer="[4;104;30m WHICH BRANCH? [0m "
git checkout %branch_transfer%
echo.
git push --set-upstream origin %branch_transfer%
GOTO START

:REMOTE_SET_SCHOOL
git remote remove origin
echo.
echo [4;104;30m                        SET SCHOOL REMOTE                [0m
git remote add origin %remote_school%
echo.
git branch
echo.
set  /p  branch-transfer="[4;104;30m WHICH BRANCH? [0m "
git checkout %branch_transfer%
echo.
git push --set-upstream origin %branch_transfer%
GOTO START

:REMOTE_SET_SP_MIRROR
git remote remove origin
echo.
echo [4;104;30m                        SET SCHOOL MIRROR REMOTE         [0m
git remote add origin %remote_school_mirror%
echo.
git branch
echo.
set  /p  branch_transfer="[4;104;30m WHICH BRANCH? [0m "
git checkout %branch_transfer%
echo.
git push --set-upstream origin %branch_transfer%
GOTO START

:REMOTE_SET_NUKESITE
git remote remove origin
echo.
echo [4;104;30m                        SET DEFAULT NUKESITE REMOTE      [0m
git remote add origin %remote_nuksite%
echo.
git branch
echo.
set  /p  branch-transfer="[4;104;30m WHICH BRANCH? [0m "
git checkout %branch_transfer%
echo.
git push --set-upstream origin %branch_transfer%
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
echo [4;104;30m                        RESETTING                        [0m
git reset
GOTO START

:HARD_RESET
echo.
echo [4;104;30m                        HARD RESET                       [0m
git log
echo.
set  /p  hard_reset_id="[4;104;30m HARD RESET TO (ID) [0m "
git reset  --hard %hard_reset_id%
GOTO START

:BASE_UNDO
echo.
echo [4;104;30m                        UNDO STAGED                      [0m
set  /p  file_to_undo="[4;104;30m UNDO CHANGES TO (FILENAME) [0m "
git checkout -- %file_to_undo%
GOTO START

:BASE_UNDO_ALL
echo.
echo [4;104;30m                        UNDO ALL STAGED                  [0m
git checkout -- .
GOTO START

:BASE_REVERT
echo.
echo [4;104;30m                        REVERTING                       [0m
git log
echo.
set  /p  revert_id="[4;104;30m REVERT TO (ID) [0m "
git revert %revert_id%
GOTO START

:LOG
echo.
echo [4;104;30m                        LOG                              [0m
git log
GOTO START

:STATUS
echo.
echo [4;104;30m                         STATUS                          [0m
git status
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

:GNUKE_HELP
echo [4;44;97m                        ALL COMMANDS                     [0m
echo "init = git init"
echo "add = git add ."
echo "addf = git add <filename>"
echo "commit = git commit -m <message>"
echo "reset = git reset"
echo "hard_reset = git reset --hard <ID>"
echo "hard_reset = git reset --hard <ID>"
echo "push/fpush = git push"
echo "pull/fpull = git pull"
echo "fetch = git fetch"
echo "clone = git clone <url>"
echo "set_branch = git branch <branch_name>"
echo "new_branch = git branch -b <branch_name>"
echo "TBA = git merge <branch> <branch>"
echo "rs functions = git remote add origin <URL>"
echo "rs defaults are SCHOOL/SCHOOL_MIRROR/NUKESITE"
echo "branch/rbranch= git branch /-r"
echo "custom_command/xcom = direct to command line"


GOTO START

:EXIT