
:: Not currently working...

:: Set Visual Studio Developer environment
:: https://learn.microsoft.com/en-us/visualstudio/ide/reference/command-prompt-powershell?view=vs-2022#command-line-arguments
"C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\VsDevCmd.bat"

echo "made it here 1"

set file=%1

:: https://blog.code-cop.org/2015/07/hello-world-windows-32-assembly.html
nasm.exe -f win32  %file%

echo "made it here 2"

:: https://blog.code-cop.org/2015/07/hello-world-windows-32-assembly.html
link.exe /entry:main %file:~0,-4%.obj /subsystem:console /nodefaultlib kernel32.lib

del %file:~0,-4%.obj
