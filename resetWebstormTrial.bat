setlocal
cd %userprofile%\.webstorm*\config
del eval\webstorm*evaluation.key
del options\options.xml
reg delete HKEY_CURRENT_USER\Software\JavaSoft\Prefs\jetbrains\webstorm /f
endlocal
