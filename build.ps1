Param(
    [string]$Icon
)
$VSWhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
$vspath = & $VSWhere -prerelease -latest -property installationPath -products *
$vsdevcmd = "$vspath\Common7\Tools\vsdevcmd.bat"
$vsarch = "x64"
$vshostarch = "x64"

& "${env:COMSPEC}" /s /c "`"$vsdevcmd`" -arch=$vsarch -host_arch=$vshostarch -no_logo && set" | foreach-object {
    $name, $value = $_ -split '=', 2
    set-content env:\"$name" $value
}

$source = @("shim.c")

Push-Location
cd $PSScriptRoot

if(![string]::IsNullOrEmpty($Icon)) {

    $IconPath = (Get-Item $Icon).FullName -replace "\\", "\\"

    $res = @"
#ifndef _resource_rc
#define _resource_rc

MAINICON ICON "$IconPath"

#endif // _resource_rc
"@

    [System.IO.File]::WriteAllLines((Join-Path $PSScriptRoot "resource.rc"), $res);

    rc.exe resource.rc
    $source += @("resource.res")
}

cl /O1 @source
Pop-Location