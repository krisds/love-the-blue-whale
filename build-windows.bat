del /Q dist\windows\*
cd src
7z a -tzip ..\dist\windows\blue-whale.love *
cd ..\dist\windows
copy "c:\program files\love\love.exe" .
copy /b love.exe+blue-whale.love blue-whale.exe
copy "c:\Program Files\LOVE\*.dll" .
del blue-whale.love
del love.exe
7z a -tzip blue-whale.zip *
cd ..\..