@echo off
REM Build godot bindings if not already built
if not exist thirdparty\godot-cpp\bin\libgodot-cpp.windows.debug.64.lib (
	cd thirdparty\godot-cpp
	call scons platform=windows bits=64 generate_bindings=yes -j%NUMBER_OF_PROCESSORS%
	cd ..
)

set GODOT_LIBRARY_NAME=libgdexample

REM On windows, we have to move the dll, otherwise we can't overwrite it.
if exist bin\win64 (
	cd bin\win64
	if exist %GODOT_LIBRARY_NAME%.dll move /Y %GODOT_LIBRARY_NAME%.dll %GODOT_LIBRARY_NAME%.dll.old
	cd ..\..
)

scons platform=windows bits=64 target_name=%GODOT_LIBRARY_NAME% -j%NUMBER_OF_PROCESSORS%
