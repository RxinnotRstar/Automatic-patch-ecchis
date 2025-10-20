rem “起手式”
@echo off
setlocal enabledelayedexpansion
mode 49,25
title 自动加密文件脚本（基于 7-zip ）

rem ——————————————————————————
rem ### 文件加密脚本 by Rxinns & ChatGPT & Deepseek ###
rem 鸣谢：batch之家
rem 这个脚本可以调用7-zip将任意单个文件或单个文件夹进行
rem 加密打包，密码为程序随机生成的大小写字母+数字。
rem https://github.com/RxinnotRstar/
rem ——————————————————————————

REM ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

REM ▓ 7-zip程序路径，可手动修改为自己的7z程序
REM ▓ 看不懂的请重新安装7-zip
REM ▓ 7-zip 官网：【 https://www.7-zip.org/ 】

set "ZipProgram=C:\Program Files\7-Zip\7z.exe"

rem ——————————————————————————

REM ▓ “自动写入密码”开关
REM ▓ 如果需要请在等号后面输入“Ｙ”，否则请改成别的字

set AddPassword=Ｙ

rem ——————————————————————————

REM ▓ 密码位数（不可超过128或小于1）
REM ▓ 也不推荐超过64，因为密码太长可能会导致文件名过长

set PasswordCount=27

REM ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓

rem ——————————————————————————

REM 防呆设计：检测上面的3个变量是否存在，以免小白删错
set "3VarHasError=0"
if defined ZipProgram (
    echo 变量已定义 >nul
) else (
	color 60
	echo.
	set "3VarHasError=1"
	set "ZipProgram=C:\Program Files\7-Zip\7z.exe"
    echo 检测到“ZipProgram”变量不存在，已重设变量。
	echo.
)

if defined AddPassword (
    echo 变量已定义 >nul
) else (
	color 60
	echo.
	set "3VarHasError=1"
	set AddPassword=Ｙ
    echo 检测到“AddPassword”变量不存在，已重设变量。
	echo.
)

if defined PasswordCount (
    echo 变量已定义 >nul
) else (
	color 60
	echo.
	set "3VarHasError=1"
	set PasswordCount=16
    echo 检测到“PasswordCount”变量不存在，已重设变量。
	echo.
)

REM 防呆设计：检测PasswordCount密码位数输入是否正确
echo %PasswordCount%|findstr /r "^[0-9][0-9]*$" >nul
if %errorlevel% equ 0 (
    echo %PasswordCount% 是数字 >nul
) else (
	cls
	color 60
	echo.
	set "3VarHasError=1"
	set PasswordCount=16
    echo 检测到“PasswordCount”变量非正整数，已重设变量。
	echo.
)
if !PasswordCount! LSS 1 (
	cls
	color 60
	echo.
	set "3VarHasError=1"
	set PasswordCount=16
	echo 检测到"PasswordCount"数值小于1，已重设变量。
	echo.
) else if !PasswordCount! GTR 128 (
	cls
	color 60
	echo.
	set "3VarHasError=1"
	set PasswordCount=16
	echo 检测到"PasswordCount"数值大于128，已重设变量。
	echo.
)
REM 报错信息加pause
if "!3VarHasError!"=="1" (
	pause
)

REM 防呆设计：“转译”圆角和大小写字符，避免设置失败
if "%AddPassword%"=="Ｙ" set "AddPassword=Y"
if "%AddPassword%"=="ｙ" set "AddPassword=y"
if "%AddPassword%"=="Y" set "AddPassword=y"
)

rem ——————————————————————————

REM 检查是否存在 7-Zip 程序
if not exist "%zipProgram%" (
    cls
    color 4E
    echo.
    echo  -----------------------------------------------
    echo   错误：找不到 7-Zip 程序。请确保程序已正确安装，
    echo   并修改脚本中的“zipProgram”变量指向正确路径。
	echo     7-zip软件下载地址：https://www.7-zip.org/
    echo  -----------------------------------------------
    echo.
    pause 
    goto :Error
)

rem ——————————————————————————

rem 检查AddPassword的值，然后显示到CLI上
set "ShowAddPassword=关"
if "%AddPassword%"=="y" set "ShowAddPassword=开"

rem ——————————————————————————

REM 提示用户输入要压缩的文件路径
:fileinput
color 1E
cls
echo.
echo  -----------------------------------------------
echo                        提示
echo.
echo      仅支持单个文件、文件夹处理，不支持多个
echo.
echo            文件将会保存到你的电脑桌面
echo.
echo  -----------------------------------------------
echo    可右键编辑脚本，修改下列设置（需要重启脚本）
echo.
echo            自动写密码到文件名：【%ShowAddPassword%】
echo.
echo                    密码位数：【!PasswordCount!】
echo  -----------------------------------------------
echo.
set "filepath=（空白）"
set /p "filePath=请输入要压缩的文件/文件夹的路径（支持拖动），然后按 Enter 键: "
set "filePath=%filePath:"=%"
rem ——————————————————————————

REM 检测文件或文件夹是否存在
if not exist "%filePath%" (
    cls
    color 4E
    echo.
    echo  -----------------------------------------------
    echo   错误：找不到文件/文件夹。请检查路径是否有误。
    echo  -----------------------------------------------
    echo.
    echo 您输入的路径为：
    echo.
    echo "%filePath%"
    echo.
    pause 
    goto :fileinput
)

rem ——————————————————————————

REM 随机生成密码
REM 毫秒级随机种子生成密码
setlocal EnableDelayedExpansion
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

:: 取毫秒级时间戳 + 两次 random 做种子
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value ^| findstr "="') do set "ts=%%a"
set /a "seed=!ts:~-4!*37+!random!*!random!"
set "password="

for /L %%i in (1,1,%PasswordCount%) do (
    set /a "rand=(seed %% 62)"
    for /f %%j in ("!rand!") do set "password=!password!!chars:~%%j,1!"
    set /a "seed=(seed*214013+2531011) %% 65536"
)
endlocal & set "password=%password%"
rem ——————————————————————————

REM 提取原文件的文件名和拓展名
for %%F in ("%filePath%") do set "fileName=%%~nF"
for %%F in ("%filePath%") do set "extension=%%~xF"

rem ——————————————————————————

REM 组合出压缩包的文件名
set "compressedFileName=!fileName!!extension!.7z"

rem ——————————————————————————

REM 检测电脑桌面的位置
for /f "tokens=2,*" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Desktop"') do set "desktopdir=%%j"

rem ——————————————————————————

REM 启动7-zip，压缩文件
"%ZipProgram%" a -mx0 -p%password% "%desktopdir%\!compressedFileName!" "%filePath%"

rem ——————————————————————————

REM 检查压缩是否成功
if %errorlevel% neq 0 (
    color 4E
    echo 压缩文件时发生错误！
    goto :Error
)

rem ——————————————————————————

REM 显示密码
cls 
color 2E
echo.
echo                     压缩成功
echo.
echo      ▓ 请复制密码，关闭窗口将无法找回密码▓
echo      ▓ 请复制密码，关闭窗口将无法找回密码▓
echo      ▓ 请复制密码，关闭窗口将无法找回密码▓
echo  -----------------------------------------------
echo.
echo  "%compressedFileName% 的密码是："
echo.
echo %password%
echo.
echo  -----------------------------------------------
echo.

rem ——————————————————————————


REM 判断“AddPassword”变量是不是Y，如果是，直接写入密码
if "%AddPassword%"=="y" (
	goto DirectlyRenameForPassword
)
	
)
rem ——————————————————————————

REM 询问用户是否将密码写入文件名
:RenameForPassword
set /p "AddPassword=输入“Y”可以将密码写入文件名： "

REM 防呆设计：“转译”圆角和大小写字符，避免设置失败
if "%AddPassword%"=="Ｙ" set "AddPassword=Y"
if "%AddPassword%"=="ｙ" set "AddPassword=y"
if "%AddPassword%"=="Y" set "AddPassword=y"

REM 开始将密码写入文件名
:DirectlyRenameForPassword
if /i "%AddPassword%"=="y" (
    set "compressedFileNameWithPassword=!fileName!!extension!（密码：!password!）.7z"
    ren "%desktopdir%\!compressedFileName!" "!compressedFileNameWithPassword!"
	cls
	echo  -----------------------------------------------
	echo.
	echo  "%compressedFileName% 的密码是："
	echo.
	echo %password%
	echo.
	echo  -----------------------------------------------
	echo.
	echo      已尝试将密码写入文件名，请检查是否成功
	echo.
	echo  -----------------------------------------------
	endlocal
) else (
	cls
	echo  -----------------------------------------------
	echo.
	echo  "%compressedFileName% 的密码是："
	echo.
	echo %password%	
	echo.
	echo  -----------------------------------------------
	echo.
	echo 输入内容错误！如不需要写入，可关闭窗口
	echo.
    goto :RenameForPassword
)

goto :End

rem ——————————————————————————

:Error
REM 报错并退出脚本
endlocal
echo.
echo                 按任意键退出脚本
pause >nul
exit 1
rem ——————————————————————————

:End
REM 正常结束脚本
endlocal
echo.
echo                 按任意键退出脚本
pause >nul
exit 0