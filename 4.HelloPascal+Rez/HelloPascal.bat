@echo off
if %errorlevel% neq 0 exit /b %errorlevel%
echo --------------- Variables ---------------
rem Name of program (main file name). Change it to your own program name
Set PRG=HelloPascal
rem Extention of your program, indicate the language used 
rem .pas for Pascal, .asm or .sfor assembly, etc.
Set lang=.pas

rem Path to you Apple IIGS image disk
rem Change it to your own path
Set AppleDiskPath="C:\dev\apple2gs\system.po"
rem destination path to your compiled program in the Apple IIGS image disk
rem Change it to your own path
Set ProdosDir="/SYSTEM6/"

echo -------------- Golden Gate ---------------
rem compile the program 
iix compile %PRG%%lang% 

rem link the program
iix -DKeepType=S16 link %PRG% keep=%PRG%

rem comile the resource file
iix compile %PRG%.rez  keep=%PRG%

rem create resource fork
iix rexport -i cadius %PRG% 

rem delete the intermediate files
del %PRG%.a
del %PRG%.root

echo --------------- Cadius ---------------
 Cadius.exe DELETEFILE %AppleDiskPath% %ProdosDir%%PRG%
 Cadius.exe ADDFILE %AppleDiskPath% %ProdosDir% .\%PRG%
echo --------------- Done ---------------