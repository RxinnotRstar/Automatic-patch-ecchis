rem ������ʽ��
@echo off
setlocal enabledelayedexpansion
mode 49,25
title �Զ������ļ��ű������� 7-zip ��

rem ����������������������������������������������������
rem ### �ļ����ܽű� by Rxinns & ChatGPT & Deepseek ###
rem ��л��batch֮��
rem ����ű����Ե���7-zip�����ⵥ���ļ��򵥸��ļ��н���
rem ���ܴ��������Ϊ����������ɵĴ�Сд��ĸ+���֡�
rem https://github.com/RxinnotRstar/
rem ����������������������������������������������������

REM ����������������������������������������������������

REM �� 7-zip����·�������ֶ��޸�Ϊ�Լ���7z����
REM �� �������������°�װ7-zip
REM �� 7-zip �������� https://www.7-zip.org/ ��

set "ZipProgram=C:\Program Files\7-Zip\7z.exe"

rem ����������������������������������������������������

REM �� ���Զ�д�����롱����
REM �� �����Ҫ���ڵȺź������롰�١���������ĳɱ����

set AddPassword=��

rem ����������������������������������������������������

REM �� ����λ�������ɳ���128��С��1��
REM �� Ҳ���Ƽ�����64����Ϊ����̫�����ܻᵼ���ļ�������

set PasswordCount=27

REM ����������������������������������������������������

rem ����������������������������������������������������

REM ������ƣ���������3�������Ƿ���ڣ�����С��ɾ��
set "3VarHasError=0"
if defined ZipProgram (
    echo �����Ѷ��� >nul
) else (
	color 60
	echo.
	set "3VarHasError=1"
	set "ZipProgram=C:\Program Files\7-Zip\7z.exe"
    echo ��⵽��ZipProgram�����������ڣ������������
	echo.
)

if defined AddPassword (
    echo �����Ѷ��� >nul
) else (
	color 60
	echo.
	set "3VarHasError=1"
	set AddPassword=��
    echo ��⵽��AddPassword�����������ڣ������������
	echo.
)

if defined PasswordCount (
    echo �����Ѷ��� >nul
) else (
	color 60
	echo.
	set "3VarHasError=1"
	set PasswordCount=16
    echo ��⵽��PasswordCount�����������ڣ������������
	echo.
)

REM ������ƣ����PasswordCount����λ�������Ƿ���ȷ
echo %PasswordCount%|findstr /r "^[0-9][0-9]*$" >nul
if %errorlevel% equ 0 (
    echo %PasswordCount% ������ >nul
) else (
	cls
	color 60
	echo.
	set "3VarHasError=1"
	set PasswordCount=16
    echo ��⵽��PasswordCount���������������������������
	echo.
)
if !PasswordCount! LSS 1 (
	cls
	color 60
	echo.
	set "3VarHasError=1"
	set PasswordCount=16
	echo ��⵽"PasswordCount"��ֵС��1�������������
	echo.
) else if !PasswordCount! GTR 128 (
	cls
	color 60
	echo.
	set "3VarHasError=1"
	set PasswordCount=16
	echo ��⵽"PasswordCount"��ֵ����128�������������
	echo.
)
REM ������Ϣ��pause
if "!3VarHasError!"=="1" (
	pause
)

REM ������ƣ���ת�롱Բ�Ǻʹ�Сд�ַ�����������ʧ��
if "%AddPassword%"=="��" set "AddPassword=Y"
if "%AddPassword%"=="��" set "AddPassword=y"
if "%AddPassword%"=="Y" set "AddPassword=y"
)

rem ����������������������������������������������������

REM ����Ƿ���� 7-Zip ����
if not exist "%zipProgram%" (
    cls
    color 4E
    echo.
    echo  -----------------------------------------------
    echo   �����Ҳ��� 7-Zip ������ȷ����������ȷ��װ��
    echo   ���޸Ľű��еġ�zipProgram������ָ����ȷ·����
	echo     7-zip������ص�ַ��https://www.7-zip.org/
    echo  -----------------------------------------------
    echo.
    pause 
    goto :Error
)

rem ����������������������������������������������������

rem ���AddPassword��ֵ��Ȼ����ʾ��CLI��
set "ShowAddPassword=��"
if "%AddPassword%"=="y" set "ShowAddPassword=��"

rem ����������������������������������������������������

REM ��ʾ�û�����Ҫѹ�����ļ�·��
:fileinput
color 1E
cls
echo.
echo  -----------------------------------------------
echo                        ��ʾ
echo.
echo      ��֧�ֵ����ļ����ļ��д�����֧�ֶ��
echo.
echo            �ļ����ᱣ�浽��ĵ�������
echo.
echo  -----------------------------------------------
echo    ���Ҽ��༭�ű����޸��������ã���Ҫ�����ű���
echo.
echo            �Զ�д���뵽�ļ�������%ShowAddPassword%��
echo.
echo                    ����λ������!PasswordCount!��
echo  -----------------------------------------------
echo.
set "filepath=���հף�"
set /p "filePath=������Ҫѹ�����ļ�/�ļ��е�·����֧���϶�����Ȼ�� Enter ��: "
set "filePath=%filePath:"=%"
rem ����������������������������������������������������

REM ����ļ����ļ����Ƿ����
if not exist "%filePath%" (
    cls
    color 4E
    echo.
    echo  -----------------------------------------------
    echo   �����Ҳ����ļ�/�ļ��С�����·���Ƿ�����
    echo  -----------------------------------------------
    echo.
    echo �������·��Ϊ��
    echo.
    echo "%filePath%"
    echo.
    pause 
    goto :fileinput
)

rem ����������������������������������������������������

REM �����������
REM ���뼶���������������
setlocal EnableDelayedExpansion
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

:: ȡ���뼶ʱ��� + ���� random ������
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value ^| findstr "="') do set "ts=%%a"
set /a "seed=!ts:~-4!*37+!random!*!random!"
set "password="

for /L %%i in (1,1,%PasswordCount%) do (
    set /a "rand=(seed %% 62)"
    for /f %%j in ("!rand!") do set "password=!password!!chars:~%%j,1!"
    set /a "seed=(seed*214013+2531011) %% 65536"
)
endlocal & set "password=%password%"
rem ����������������������������������������������������

REM ��ȡԭ�ļ����ļ�������չ��
for %%F in ("%filePath%") do set "fileName=%%~nF"
for %%F in ("%filePath%") do set "extension=%%~xF"

rem ����������������������������������������������������

REM ��ϳ�ѹ�������ļ���
set "compressedFileName=!fileName!!extension!.7z"

rem ����������������������������������������������������

REM �����������λ��
for /f "tokens=2,*" %%i in ('reg query "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Desktop"') do set "desktopdir=%%j"

rem ����������������������������������������������������

REM ����7-zip��ѹ���ļ�
"%ZipProgram%" a -mx0 -p%password% "%desktopdir%\!compressedFileName!" "%filePath%"

rem ����������������������������������������������������

REM ���ѹ���Ƿ�ɹ�
if %errorlevel% neq 0 (
    color 4E
    echo ѹ���ļ�ʱ��������
    goto :Error
)

rem ����������������������������������������������������

REM ��ʾ����
cls 
color 2E
echo.
echo                     ѹ���ɹ�
echo.
echo      �� �븴�����룬�رմ��ڽ��޷��һ����먈
echo      �� �븴�����룬�رմ��ڽ��޷��һ����먈
echo      �� �븴�����룬�رմ��ڽ��޷��һ����먈
echo  -----------------------------------------------
echo.
echo  "%compressedFileName% �������ǣ�"
echo.
echo %password%
echo.
echo  -----------------------------------------------
echo.

rem ����������������������������������������������������


REM �жϡ�AddPassword�������ǲ���Y������ǣ�ֱ��д������
if "%AddPassword%"=="y" (
	goto DirectlyRenameForPassword
)
	
)
rem ����������������������������������������������������

REM ѯ���û��Ƿ�����д���ļ���
:RenameForPassword
set /p "AddPassword=���롰Y�����Խ�����д���ļ����� "

REM ������ƣ���ת�롱Բ�Ǻʹ�Сд�ַ�����������ʧ��
if "%AddPassword%"=="��" set "AddPassword=Y"
if "%AddPassword%"=="��" set "AddPassword=y"
if "%AddPassword%"=="Y" set "AddPassword=y"

REM ��ʼ������д���ļ���
:DirectlyRenameForPassword
if /i "%AddPassword%"=="y" (
    set "compressedFileNameWithPassword=!fileName!!extension!�����룺!password!��.7z"
    ren "%desktopdir%\!compressedFileName!" "!compressedFileNameWithPassword!"
	cls
	echo  -----------------------------------------------
	echo.
	echo  "%compressedFileName% �������ǣ�"
	echo.
	echo %password%
	echo.
	echo  -----------------------------------------------
	echo.
	echo      �ѳ��Խ�����д���ļ����������Ƿ�ɹ�
	echo.
	echo  -----------------------------------------------
	endlocal
) else (
	cls
	echo  -----------------------------------------------
	echo.
	echo  "%compressedFileName% �������ǣ�"
	echo.
	echo %password%	
	echo.
	echo  -----------------------------------------------
	echo.
	echo �������ݴ����粻��Ҫд�룬�ɹرմ���
	echo.
    goto :RenameForPassword
)

goto :End

rem ����������������������������������������������������

:Error
REM �����˳��ű�
endlocal
echo.
echo                 ��������˳��ű�
pause >nul
exit 1
rem ����������������������������������������������������

:End
REM ���������ű�
endlocal
echo.
echo                 ��������˳��ű�
pause >nul
exit 0