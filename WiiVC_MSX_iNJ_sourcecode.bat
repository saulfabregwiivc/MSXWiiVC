@echo off
cls
@echo off

title MSX Wii Virtual Console iNJECTOR ***BETA VERSiON*** by saulfabreg v2.7.0

echo MSX Wii Virtual Console (Wii VC) iNJECTOR ***BETA VERSiON***
echo ---- compatible with: ----
echo - Microsoft MSX (MSX1)
echo - Microsoft MSX2
echo --------------------------------------------------- v2.7.0 ---
echo By saulfabreg (special thanks to icefire, BFGR, G0dLiKe
echo and Superken7)
echo --------------------------------------------------------------
echo u8it.exe tool (from WADder) (c) 2009 icefire
echo MSX/MSX2 VC iNJECT info (c) 2011-2013 G0dLiKe
echo WAD (un)packer (c) 2009 BFGR
echo FreeTheWads.exe tool (c) 2009 Superken7
echo everything else (c) 2020-2021 saulfabreg
echo Made with love by saulfabreg (saulfabregamboa@outlook.com)
echo http://saulfabreg-wiivc.blogspot.com
echo ---------------------------------------------------------------
echo CAUTION: This is a BETA test version. May have a lot of bugs.
echo ---------------------------------------------------------------
echo.
echo Welcome to the MSX Wii VC iNJECTOR!!
echo.
echo Let's start :D
echo.
echo First copy your MSX1/MSX2 ROM (.rom/.mx1/.mx2) file into the folder
echo 'ROM_INPUT'
echo.
echo Then copy an MSX1/MSX2 WAD into the folder 'WAD_INPUT'
echo.
echo Press Enter when you are ready
pause>nul

mkdir temp_01
copy *.dll temp_01
copy *.exe temp_01
copy *.ocx temp_01
copy *.bin temp_01
GOTO :unpackwad

:unpackwad
cls
echo // Checking WAD file into 'WAD_INPUT'...
cd WAD_INPUT
copy *.wad ..\temp_01
cd..
cd temp_01
rename *.wad unpack.wad
echo // Unpacking the WAD... Please wait!
wadunpacker.exe unpack.wad
echo // Copying 5.app file to temp folder...
cd 00010001*
set WADfolder=%cd%
copy 00000005.app ..\
cd..
u8it 00000005.app 00000005_app_OUT
goto :pickROMinput

:pickROMinput
cls
echo // Checking ROM file into 'ROM_INPUT'...
cd..
cd ROM_INPUT
rename *.mx1 *.rom
rename *.mx2 *.rom
copy *.rom ..\temp_01
cd..
cd temp_01
echo // Make copy of the ROM for use one of them depending of the MSX WAD
rename *.rom *_backup.rom
copy *.rom *_copy.rom
echo // Make ROM file for VC MSX1 WAD (SLOT1.ROM)
rename *_backup.rom SLOT1.ROM
echo // Make ROM file for VC MSX2 WAD (MEGAROM.ROM)
rename *_copy.rom MEGAROM.ROM
pause
GOTO :checkROM_5app

:checkROM_5app
cls
echo // Checking if ROM file exists in 5.app file...
cd 00000005_app_OUT
GOTO :errorcheck

:errorcheck
IF EXIST MEGAROM.ROM GOTO :msx2
IF EXIST SLOT1.ROM GOTO :msx1
cls
echo ERROR! There isn't any ROM file on the 5.app.
echo Maybe this is not a MSX1/MSX2 WAD.
echo ---------------------------------------
echo Failed =(
echo ---------------------------------------
cd..
cd..
rd /s /q temp_01
pause
exit

:msx2
cls
echo // MSX2 ROM found into 5.app file (MEGAROM.ROM), do you want to
echo    inject your ROM into here? (Y = Yes, N = No)
choice /C:yn /N /M "Your input:"
if "%errorlevel%"=="1" goto :iNJECT_MSX2
if "%errorlevel%"=="2" goto :notinjected

:msx1
cls
echo //  MSX1 ROM found into 5.app file (SLOT1.ROM), do you want to
echo     inject your ROM into here? (Y = Yes, N = No)
choice /C:yn /N /M "Your input (Up next: Location):"
if "%errorlevel%"=="1" goto :iNJECT_MSX1
if "%errorlevel%"=="2" goto :notinjected

:iNJECT_MSX1
cls
echo Injecting your ROM into the MSX1 5.app file...
cd..
copy SLOT1.ROM 00000005_app_OUT
echo ROM file injected successfully! =)
echo Press Enter to pack the new 5.app file
pause>nul
GOTO :packmove5app

:iNJECT_MSX2
cls
echo Injecting your ROM into the MSX2 5.app file...
cd..
copy MEGAROM.ROM 00000005_app_OUT
echo ROM file injected successfully! =)
echo Press Enter to pack the new 5.app file
pause>nul
GOTO :packmove5app

:notinjected
cls
echo Cannot be injected. You canceled the injection.
echo ------------------------------------------------
echo NOTE: Please delete the folder 'temp_01' before
echo using again the tool.
echo ---------------------------------------
echo Failed =(
echo ---------------------------------------
cd..
cd..
rd /s /q temp_01
pause
exit

:packmove5app
cls
echo // Packing the new 5.app file...
u8it 00000005_app_OUT 00000005.app -pack
cd..
mkdir WAD_OUTPUT
cd temp_01
echo Replacing 5.app file with your ROM...
echo If a warning message appears, write "yes"
echo and press Enter to continue.
move /y 00000005.app "%WADfolder%"
GOTO :wadidquestion

:wadidquestion
cls
echo // Do you wish to modify the game ID for your new WAD?
echo.
echo    (Y = Yes, N = No)
CHOICE /C:yn /N /M "Your input (Up next: Location):"
if "%ERRORLEVEL%"=="1" goto :packwadid
if "%ERRORLEVEL%"=="2" goto :packwadnoid

:packwadid
echo // Write a new ID for your new WAD, by following these conditions:
echo.
echo    1. The ID MUST have 4 characters (XXXX).
echo    2. Your ID MUST have CAPITAL LETTERS (MAYUSCULAS) and numbers (0-9).
echo       EXAMPLE: X4AJ
echo.
SET/P WADID=// Write the new ID here and then hit Enter:
echo // Copying the modified WAD contents... Please wait!
cd "%WADfolder%"
copy *.app ..\
copy *.cert ..\
copy *.tik ..\
copy *.tmd ..\
copy *.trailer ..\
cd..
echo // Packing the new WAD... Please wait!
wadpacker_bfgr.exe *.tik *.tmd *.cert output.wad -sign -i %WADID%
GOTO :questionRF

:packwadnoid
cls
echo // Copying the modified WAD contents... Please wait!
cd "%WADfolder%"
copy *.app ..\
copy *.cert ..\
copy *.tik ..\
copy *.tmd ..\
copy *.trailer ..\
cd..
echo // Packing the new WAD... Please wait!
wadpacker_bfgr.exe *.tik *.tmd *.cert output.wad -sign
GOTO :questionRF

:questionRF
cls
echo // Do you wish to patch the outputed WAD for
echo    make it Region Free?
echo.
echo    (Region Free means play the WAD in any Wii
echo    of any region)
echo    (Y = Yes, N = No)
CHOICE /C:yn /N /M "Your input (Up next: Location):"
if "%ERRORLEVEL%"=="1" goto :regFreeWAD
if "%ERRORLEVEL%"=="2" goto :moveWAD_norm

:regFreeWAD
echo // Patching the WAD to Region Free... Please wait!
freethewads.exe output.wad
rename output.wad output_regFree.wad
GOTO :moveWAD_regFr

:moveWAD_regFr
copy output_regFree.wad ..\WAD_OUTPUT
GOTO :successWAD

:moveWAD_norm
copy output.wad ..\WAD_OUTPUT
GOTO :successWAD

:successWAD
cls
cd..
echo Deleting temporal folder... Write "y" and
echo press Enter if a message appears.
rd /s /q temp_01
cls
echo // CONGRATULATIONS!! New WAD created with your ROM
echo    injected!!
echo.
echo // You can find it in the 'WAD_OUTPUT' folder.
echo -----------------------------------------------
echo Hope you enjoy it...
echo Mission Completed!
echo -----------------------------------------------
echo All done! =)
echo -----------------------------------------------
pause
exit