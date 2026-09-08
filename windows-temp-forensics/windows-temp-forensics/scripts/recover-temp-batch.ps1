<#
.SYNOPSIS
    Batch-runs the official Windows File Recovery tool (winfr) against the
    Temp folder for a list of extensions.

.DESCRIPTION
    Part of the "Windows Temp Forensics & File Recovery" course (Chapter 4).
    Requires:
      - Windows File Recovery installed (Microsoft Store, id 9N26S50LN705)
      - Administrator privileges
      - Destination drive DIFFERENT from the source drive (winfr requirement)

    Run only against systems/VMs you own, for learning purposes only.

.PARAMETER SourceDrive
    Drive letter to recover from, e.g. "C:".

.PARAMETER DestDrive
    Drive letter to write recovered files to, e.g. "E:". Must differ from
    SourceDrive.

.PARAMETER UserName
    Windows username whose Temp folder should be scanned. Defaults to the
    current user.

.PARAMETER Extensions
    List of extensions to recover (without the dot), e.g. exe,dll,tmp,dat,dmp,zip.

.PARAMETER Mode
    winfr scan mode: "regular" or "extensive". Extensive is recommended for
    Temp folder recovery (default).

.EXAMPLE
    .\recover-temp-batch.ps1 -SourceDrive C: -DestDrive E: -Extensions exe,dll,tmp,zip
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SourceDrive,

    [Parameter(Mandatory = $true)]
    [string]$DestDrive,

    [string]$UserName = $env:USERNAME,

    [string[]]$Extensions = @("exe","dll","tmp","dat","dmp","zip"),

    [ValidateSet("regular","extensive")]
    [string]$Mode = "extensive"
)

# --- Safety checks -----------------------------------------------------

if ($SourceDrive.TrimEnd(':') -ieq $DestDrive.TrimEnd(':')) {
    Write-Error "SourceDrive and DestDrive must be different (winfr requirement). Aborting."
    exit 1
}

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Error "This script must be run as Administrator (winfr requirement). Aborting."
    exit 1
}

$winfr = Get-Command winfr.exe -ErrorAction SilentlyContinue
if (-not $winfr) {
    Write-Error "winfr.exe not found in PATH. Install 'Windows File Recovery' from the Microsoft Store first."
    exit 1
}

# --- Run recovery passes -------------------------------------------------

$tempPath = "\Users\$UserName\AppData\Local\Temp"
$srcLetter = $SourceDrive.TrimEnd(':')
$dstLetter = $DestDrive.TrimEnd(':')

Write-Host "Recovering from $srcLetter`: to $dstLetter`: | mode=$Mode | path=$tempPath" -ForegroundColor Cyan

foreach ($ext in $Extensions) {
    $filter = "$tempPath\*.$ext"
    Write-Host "`n=== Recovering *.$ext ===" -ForegroundColor Yellow
    Write-Host "winfr $srcLetter`: $dstLetter`: /$Mode /n `"$filter`" /y"

    & winfr.exe "$srcLetter`:" "$dstLetter`:" "/$Mode" /n "$filter" /y

    if ($LASTEXITCODE -ne 0) {
        Write-Warning "winfr exited with code $LASTEXITCODE for extension .$ext"
    }
}

Write-Host "`nAll passes complete. Check $DestDrive\Recovery_* for output." -ForegroundColor Green
