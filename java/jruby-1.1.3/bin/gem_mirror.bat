@ECHO OFF
IF NOT "%~f0" == "~f0" GOTO :WinNT
@"jruby.bat" -S "gem_mirror" %1 %2 %3 %4 %5 %6 %7 %8 %9
GOTO :EOF
:WinNT
@"jruby.bat" "%~dpn0" %*