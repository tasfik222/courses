<#
.SYNOPSIS
    Triages recovered files: generates hashes and flags extension/magic-byte
    mismatches for manual review.

.DESCRIPTION
    Part of the "Windows Temp Forensics & File Recovery" course (Chapter 5).
    This script performs static, read-only inspection only (hashing and
    header/magic-byte checks). It does NOT execute, unpack, or analyze
    behaviorally any recovered file, and it makes no judgement about whether
    a file is malicious. Use it purely to organize files for manual /
    professional review (e.g. via your organization's security tooling).

.PARAMETER RecoveredPath
    Folder containing recovered files (e.g. output from winfr).

.PARAMETER OutputDir
    Where to write the triage CSV.

.EXAMPLE
    .\triage-recovered.ps1 -RecoveredPath E:\Recovery_20260908_140000 -OutputDir E:\reports
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$RecoveredPath,

    [Parameter(Mandatory = $true)]
    [string]$OutputDir
)

if (-not (Test-Path $OutputDir)) {
    New-Item -ItemType Directory -Path $OutputDir -Force | Out-Null
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$csvPath = Join-Path $OutputDir "triage_summary_$timestamp.csv"

# Known magic-byte signatures (hex, first bytes) -> friendly type name
$signatures = [ordered]@{
    "4D5A"       = "PE (exe/dll/sys)"
    "504B0304"   = "ZIP-based (zip/docx/xlsx/apk)"
    "25504446"   = "PDF"
    "1F8B"       = "GZIP"
    "377ABCAF271C" = "7-Zip"
    "526172211A0700" = "RAR"
}

function Get-MagicHex {
    param([string]$Path, [int]$ByteCount = 8)
    try {
        $bytes = [System.IO.File]::ReadAllBytes($Path)
        $take = [Math]::Min($ByteCount, $bytes.Length)
        return (($bytes[0..($take - 1)] | ForEach-Object { $_.ToString("X2") }) -join "")
    } catch {
        return $null
    }
}

function Resolve-FileType {
    param([string]$MagicHex)
    foreach ($sig in $signatures.Keys) {
        if ($MagicHex -and $MagicHex.StartsWith($sig)) {
            return $signatures[$sig]
        }
    }
    return "Unknown/Unidentified"
}

$files = Get-ChildItem -Path $RecoveredPath -Recurse -File -ErrorAction SilentlyContinue
$total = $files.Count
Write-Host "Triaging $total recovered file(s)..." -ForegroundColor Cyan

$results = New-Object System.Collections.Generic.List[Object]
$i = 0

foreach ($file in $files) {
    $i++
    Write-Progress -Activity "Triaging" -Status $file.Name -PercentComplete (($i / [Math]::Max($total,1)) * 100)

    $hash = $null
    try { $hash = (Get-FileHash -Path $file.FullName -Algorithm SHA256 -ErrorAction Stop).Hash } catch { $hash = "ERROR" }

    $magic = Get-MagicHex -Path $file.FullName
    $detectedType = Resolve-FileType -MagicHex $magic

    $extClaim = switch ($file.Extension.ToLower()) {
        ".exe" { "PE (exe/dll/sys)" }
        ".dll" { "PE (exe/dll/sys)" }
        ".zip" { "ZIP-based (zip/docx/xlsx/apk)" }
        ".pdf" { "PDF" }
        default { "N/A" }
    }

    $mismatch = ($extClaim -ne "N/A") -and ($extClaim -ne $detectedType)

    $results.Add([PSCustomObject]@{
        FullName      = $file.FullName
        Name          = $file.Name
        Extension     = $file.Extension
        SizeBytes     = $file.Length
        SHA256        = $hash
        MagicHex      = $magic
        DetectedType  = $detectedType
        ExtensionClaimsType = $extClaim
        PossibleMismatch    = $mismatch
    })
}

$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

$mismatches = $results | Where-Object { $_.PossibleMismatch }
Write-Host "`nTriage complete. Report: $csvPath" -ForegroundColor Green
Write-Host "$($mismatches.Count) file(s) flagged with possible extension/type mismatch — review manually." -ForegroundColor Yellow
