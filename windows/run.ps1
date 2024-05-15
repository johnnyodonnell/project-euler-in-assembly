
$cwd = (Get-Item .).FullName

# Set Visual Studio Developer environment
# https://learn.microsoft.com/en-us/visualstudio/ide/reference/command-prompt-powershell?view=vs-2022#command-line-arguments
& 'C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\Tools\Launch-VsDevShell.ps1'

Set-Location $cwd

$asm_file = $args[0]
$base_file = [io.path]::GetFileNameWithoutExtension($asm_file)
$obj_file = $base_file + ".obj"
$exe_file = $base_file + ".exe"

# https://blog.code-cop.org/2015/07/hello-world-windows-32-assembly.html
nasm.exe -f win32  $asm_file

# https://blog.code-cop.org/2015/07/hello-world-windows-32-assembly.html
link.exe $obj_file /entry:main /subsystem:console kernel32.lib

$output = cmd /c (".\" + $exe_file)
[convert]::ToInt32($output, 16)

Remove-Item $obj_file
# Remove-Item $exe_file
