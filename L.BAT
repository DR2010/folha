@echo off

rem  PATH=%PATH%;F:\CLIPPER5\BIN
SET LIB=C:\CLIPPER5
SET PLL=C:\CLIPPER5
SET BIN=C:\CLIPPER5
SET INCLUDE=C:\CLIPPER5
SET DIRFOLHA=D:\SISTEMA\FOLHA

SET CLIPPER=F100

\clipper\rmake FPG
if errorlevel 1 goto erro
rtlink @fpg
if errorlevel 1 goto erro

echo..
echo..
echo              A compila‡„o finalizou com sucesso!!
echo..
echo..
goto fim

:erro
echo.
echo.
echo **************************************  Deu Pau!  ******************************
pause > NUL

:fim
