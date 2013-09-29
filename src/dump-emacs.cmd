@echo off
echo Dumping normally increments the Emacs version number, but as I decided
echo to use this number to distinguish different porting versions, I turned 
echo this off.
echo.
echo Dumping Emacs ...
temacs -batch -l loadup dump
echo Stripping a.out-file ...
emxbind -x temacs.exe a.out
echo Binding dumped Emacs ...
emxbind -ccore \emx\bin\emxl.exe a.out xemacs.exe
del a.out
del core
