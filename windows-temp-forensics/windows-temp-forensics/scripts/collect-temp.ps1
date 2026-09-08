<#
.SYNOPSIS
    Collects an inventory (and optional copy) of files currently present in
    the Windows %TEMP% folder, with SHA-256 hashes, exported to CSV.

.DESCRIPTION
    Part of the "Windows Temp Forensics & File Recovery" course (Chapter 2).
    Intended for use in an isolated lab VM that you own, for learning
    purposes only.

.PARAMETER SourcePath
    Path to scan. Defaults to $env:TEMP.

.PARAMETER OutputDir
    Where to write the CSV report and (optionally) copied files.

.PARAMETER CopyFiles
    If set, files are also copied to $OutputDir\copied\ (preserving relative
    structure) in addition to being inventoried.

.PARAMETER Extensions
    Optional array of extensions to filter on, e.g. ".exe",".dll",".tmp".
    If omitted, all files are inventoried.

.PARAMETER HoursBack
    Only include files modified within the last N hours. Omit for no time filter.

.EXAMPLE
    .\collect-temp.ps1 -OutputDir E:\reports -CopyFiles -Extensions .exe,.dll,.tmp -HoursBack 24
#>

[CmdletBinding()]
param(
    [string]$SourcePath = $env:TEMP,
    [Parameter(Mandatory = $true)]
    [string]$OutputDir,
    [switch]$CopyFiles,
    [string[]]$Extensions,
    [int]$HoursBack
)

$ErrorActionPreference = "Continue"

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$csvPath = Join-Path $OutputDir "temp_inventory_$timestamp.csv"

Write-Host "Scanning: $SourcePath" -ForegroundColor Cyan

$files = Get-ChildItem -Path $SourcePath -Recurse -File -ErrorAction SilentlyContinue

if ($Extensions) {
    $files = $files | Where-Object { $Extensions -contains $_.Extension }
}

if ($HoursBack) {
    $cutoff = (Get-Date).AddHours(-$HoursBack)
    $files = $files | Where-Object { $_.LastWriteTime -gt $cutoff }
}

$total = $files.Count
Write-Host "Found $total file(s) matching filters." -ForegroundColor Yellow

$results = New-Object System.Collections.Generic.List[Object]
$i = 0

foreach ($file in $files) {
    $i++
    Write-Progress -Activity "Hashing files" -Status $file.Name -PercentComplete (($i / [Math]::Max($total,1)) * 100)

    $hash = $null
    try {
        $hash = (Get-FileHash -Path $file.FullName -Algorithm SHA256 -ErrorAction Stop).Hash
    } catch {
        $hash = "ERROR: $($_.Exception.Message)"
    }

    $results.Add([PSCustomObject]@{
        FullName       = $file.FullName
        Name           = $file.Name
        Extension      = $file.Extension
        SizeBytes      = $file.Length
        CreationTime   = $file.CreationTime
        LastWriteTime  = $file.LastWriteTime
        SHA256         = $hash
    })

    if ($CopyFiles) {
        $relative = $file.FullName.Substring($SourcePath.Length).TrimStart('\')
        $destPath = Join-Path (Join-Path $OutputDir "copied") $relative
        $destDir = Split-Path $destPath -Parent
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        try {
            Copy-Item -Path $file.FullName -Destination $destPath -Force -ErrorAction Stop
        } catch {
            Write-Warning "Could not copy $($file.FullName): $($_.Exception.Message)"
        }
    }
}

$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

Write-Host "`nDone. Inventory written to: $csvPath" -ForegroundColor Green
if ($CopyFiles) {
    Write-Host "Copied files under: $(Join-Path $OutputDir 'copied')" -ForegroundColor Green
}
