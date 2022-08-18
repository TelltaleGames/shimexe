$VSWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vspath = & $VSWhere -prerelease -latest -property installationPath -products *
$vsdevcmd = "$vspath\Common7\Tools\vsdevcmd.bat"
$vsarch = "x64"
$vshostarch = "x64"

& "${env:COMSPEC}" /s /c "`"$vsdevcmd`" -arch=$vsarch -host_arch=$vshostarch -no_logo && set" | foreach-object {
    $name, $value = $_ -split '=', 2
    set-content env:\"$name" $value
}

cl /O1 shim.c