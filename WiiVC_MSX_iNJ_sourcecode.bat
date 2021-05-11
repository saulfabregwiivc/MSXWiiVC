@echo off
cls
@echo off

title MSX Wii Virtual Console iNJECTOR ***BETA TEST VERSiON*** by saulfabreg v2.4

echo MSX Wii Virtual Console (Wii VC) iNJECTOR ***BETA VERSION***
echo ----------------------------------------------------- v2.4 ---
echo By saulfabreg (special thanks to icefire, BFGR and Superken7)
echo --------------------------------------------------------------
echo u8it.exe tool (from WADder) (c) 2009 icefire
echo Wii.cs-Tools WadMii (c) 2010 Leathl
echo FreeTheWads.exe tool (c) 2009 Superken7
echo everything else (c) 2020 saulfabreg
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
echo First copy your MSX1/MSX2 ROM file into the folder
echo 'ROM_INPUT'
echo.
echo Then copy an MSX1 / MSX2 WAD into the folder 'WAD_INPUT'
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
echo // Unpack the WAD.
echo // Make sure to use the "WAD_temp.wad" WAD file from "temp_01"
echo    folder!!
echo.
echo "WadMii.exe" will be opened for extract the WAD.
echo 1. When the WadMii tool opens, choose the mode to "Unpack"
echo 2. Click in the ".." button of the "File" box
echo 3. Choose the "WAD_temp.wad" file from "temp_01" folder
echo 4. Click in the Unpack button
echo 5. Once a message appears, close the message.
echo.
echo // When you finished close WadMii.exe and press Enter
rename *.wad WAD_temp.wad
start WadMii.exe
pause>nul
echo // Copying 5.app file to temp folder...
cd WAD_temp
copy 00000005.app ..\
echo Deleting temporal folder of 5.app... Write "y" and
echo press Enter if a message appears.
rd content5 /s
cd..
u8it 00000005.app 00000005_app_OUT
pause
goto :pickROMinput

:pickROMinput
cls
echo // Checking ROM file into 'ROM_INPUT'...
cd..
cd ROM_INPUT
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
pause
exit

:msx2
cls
echo MSX2 ROM found into 5.app file (MEGAROM.ROM), do you want to
echo inject your ROM into here? (Y = Yes, N = No)
CHOICE /C:yn /N /M "Your input:"
if "%ERRORLEVEL%"=="1" goto :iNJECT_MSX2
if "%ERRORLEVEL%"=="2" goto :notinjected

:msx1
cls
echo MSX1 ROM found into 5.app file (SLOT1.ROM), do you want to
echo inject your ROM into here? (Y = Yes, N = No)
CHOICE /C:yn /N /M "Your input (Up next: Location):"
if "%ERRORLEVEL%"=="1" goto :iNJECT_MSX1
if "%ERRORLEVEL%"=="2" goto :notinjected

:iNJECT_MSX1
cls
echo Injecting your ROM into the MSX1 5.app file...
cd..
copy SLOT1.ROM 00000005_app_OUT
echo ROM file injected successfully! =)
pause
GOTO :pack5app

:iNJECT_MSX2
cls
echo Injecting your ROM into the MSX2 5.app file...
cd..
copy MEGAROM.ROM 00000005_app_OUT
echo ROM file injected successfully! =)
pause
GOTO :pack5app

:notinjected
cls
echo Cannot be injected. You canceled the injection.
echo ------------------------------------------------
echo NOTE: Please delete the folder 'temp_01' before
echo using again the tool.
echo ------------------------------------------------
echo Failed =(
echo ------------------------------------------------
pause
exit

:pack5app
cls
echo // Packing the new 5.app file...
u8it 00000005_app_OUT 00000005.app -pack
echo CONGRATULATIONS!! New 5.app created with your ROM!
pause
goto :move5app

:move5app
cls
cd..
mkdir WAD_OUTPUT
cd temp_01
echo Replacing 5.app file with your ROM...
echo If a warning message appears, write "yes"
echo and press Enter to continue.
move 00000005.app WAD_temp
GOTO :packwad

:packwad
cls
echo // Now pack the WAD.
echo // Make sure to use the "WAD_temp" folder from "temp_01"
echo    folder!!
echo.
echo "WadMii.exe" will be opened for extract the WAD.
echo 1. When the WadMii tool opens, choose the mode to "Pack"
echo 2. Click in the ".." button of the "Folder" box
echo 3. Choose the "WAD_temp" folder from "temp_01" folder
echo 4. Click in the ".." button of the "File" box
echo 3. In "File name" box, write "output.wad" and choose the
echo    "temp_01" folder as place to save the WAD
echo 4. If you wish, check the "Change Title ID" box and then
echo    change the ID of the new WAD in the ID box.
echo 5. Click in the Pack button
echo 6. Once a message appears, close the message.
echo.
echo // When you finished close WadMii.exe and press Enter
start WadMii.exe
pause>nul
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
rd temp_01 /s
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