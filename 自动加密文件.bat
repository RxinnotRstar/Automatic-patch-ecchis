@echo off

rem ——————————————————————————

rem #####随机加密脚本 by Rxinns & ChatGPT-3.5#####

rem 这个脚本可以调用7-zip将任意单个文件或单个文件夹
rem 加密打包，密码为程序随机生成的64位大小写字母+数字。

rem ——————————————————————————

REM 修改终端外观
mode 49,15
title 自动加密文件脚本（基于 7-zip ）
setlocal enabledelayedexpansion

rem ——————————————————————————

REM ▓▓▓▓▓▓▓▓▓▓▓▓▓▓
REM ▓▓程序路径在这里！！！▓▓
REM ▓▓▓▓▓▓▓▓▓▓▓▓▓▓
set "zipProgram=C:\Program Files\7-Zip\7z.exe"

rem ——————————————————————————


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

REM 提示用户输入要压缩的文件路径
:fileinput
color 1E
cls
echo.
echo  -----------------------------------------------
echo                        提示
echo.
echo         仅支持单个文件或者单个文件夹处理
echo.
echo            不支持多个文件、多个文件夹
echo.
echo            文件将会保存到你的电脑桌面
echo  -----------------------------------------------
echo.
set "filepath=（空）"
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
setlocal EnableDelayedExpansion
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
set "password="
for /L %%i in (1,1,64) do (
    set /a "rand=!random! %% 62"
    for /f %%j in ("!rand!") do (
        set "password=!password!!chars:~%%j,1!"
    )
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

REM 压缩文件
"%zipProgram%" a -mx0 -p%password% "%desktopdir%\!compressedFileName!" "%filePath%"

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
echo  %compressedFileName% 的密码是：%password%
echo.
echo  -----------------------------------------------
echo.

rem ——————————————————————————

REM 将密码写入文件名
:RenameForPassword
set /p "addPassword=输入“Y”可以将密码写入文件名： "
if /i "%addPassword%"=="y" (
    set "compressedFileNameWithPassword=!fileName!!extension!（密码：!password!）.7z"
    ren "%outputfolder%!compressedFileName!" "!compressedFileNameWithPassword!"
	cls
	echo  -----------------------------------------------
	echo.
	echo  "%compressedFileName%" 的密码是：%password%
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
	echo  "%compressedFileName%" 的密码是：%password%
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
pause >nul

rem ——————————————————————————

:End
REM 正常结束脚本
endlocal
pause >nul
