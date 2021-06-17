:START
@echo off
 set tick=0
 echo %tick%
:AFT _NIT
set /p command="Enter command: "
IF '%command%' == 'exit' GOTO EXIT
IF '%command%' == 'tick' GOTO TICK
IF '%command%' == 'add_commit' GOTO ADD_COMMIT
IF '%command%' == 'test' GOTO TEST
GOTO START

:TICK
set /p tick=%tick%+1
echo %tick% 
echo.
pause >nul
GOTO AFT _NIT


:ADD_COMMIT
git add .
set /p message="Enter message: "
git commit -m %message%

:TEST

:EXIT