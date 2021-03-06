param (
    [string] $td = "$PSScriptRoot/../td",
    [string] $Platform = 'x64-windows',
    [Parameter(Mandatory = $true)] [string] $VcpkgToolchain
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

if (-not (Test-Path $td/build)) {
    New-Item -Type Directory $td/build
}

Push-Location $td/build
try {
    $vcpkgArguments = @(
        'install'
        "openssl:$platform"
        "zlib:$platform"
    )
    $cmakeArguments = @(
        "-DCMAKE_TOOLCHAIN_FILE=$VcpkgToolchain"
        '..'
    )
    $cmakeBuildArguments = @(
        '--build'
        '.'
        '--config'
        'Release'
    )

    if ($Platform -eq 'x64-windows') {
        $cmakeArguments += @('-A', 'X64')
    }

    vcpkg $vcpkgArguments
    if (!$?) {
        throw 'Cannot execute vcpkg'
    }

    cmake $cmakeArguments
    if (!$?) {
        throw 'Cannot execute cmake'
    }

    cmake $cmakeBuildArguments
    if (!$?) {
        throw 'Cannot execute cmake --build'
    }
} finally {
    Pop-Location
}
