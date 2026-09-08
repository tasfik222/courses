<#
.SYNOPSIS
    End-to-end workflow: live collection -> winfr recovery -> triage -> report.

.DESCRIPTION
    Part of the "Windows Temp Forensics & File Recovery" course (Chapter 7).
    Orchestrates collect-temp.ps1, recover-temp-batch.ps1 and
    triage-recovered.ps1, then produces a combined JSON summary report.

    Run only in a lab VM you own, with Administrator privileges.

.PARAMETER SourceDrive
    Drive letter containing the Temp folder to analyze, e.g. "C:".

.PARAMETER DestDrive
    Drive letter for winfr recovery output (must differ from SourceDrive), e.g. "E:".

.PARAMETER ReportDir
    Where all reports (CSV + final JSON) are written.

.PARAMETER Extensions
    Extensions to target for both live collection filtering and winfr recovery.

.EXAMPLE
    .\full-temp-workflow.ps1 -SourceDrive C: -DestDrive E: -ReportDir E:\reports
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SourceDrive,

    [Parameter(Mandatory = $true)]
    [string]$DestDrive,

    [Parameter(Mandatory = $true)]
    [string]$ReportDir,

    [string[]]$Extensions = @("exe","dll","tmp","dat","dmp","zip")
)

$ErrorActionPreference = "Continue"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

if (-not (Test-Path $ReportDir)) {
    New-Item -ItemType Directory -Path $ReportDir -Force | Out-Null
}

Write-Host "`n===== STEP 1/3: Live Collection =====" -ForegroundColor Magenta
& (Join-Path $scriptDir "collect-temp.ps1") `
    -OutputDir $ReportDir `
    -Extensions ($Extensions | ForEach-Object { ".$_" }) `
    -CopyFiles

Write-Host "`n===== STEP 2/3: winfr Batch Recovery =====" -ForegroundColor Magenta
& (Join-Path $scriptDir "recover-temp-batch.ps1") `
    -SourceDrive $SourceDrive `
    -DestDrive $DestDrive `
    -Extensions $Extensions

# Find the most recent Recovery_* output folder on the dest drive
$recoveryFolder = Get-ChildItem -Path "$DestDrive\" -Directory -Filter "Recovery_*" -ErrorAction SilentlyContinue |
    Sort-Object LastWriteTime -Descending |
    Select-Object -First 1

Write-Host "`n===== STEP 3/3: Triage Recovered Files =====" -ForegroundColor Magenta
if ($recoveryFolder) {
    & (Join-Path $scriptDir "triage-recovered.ps1") `
        -RecoveredPath $recoveryFolder.FullName `
        -OutputDir $ReportDir
} else {
    Write-Warning "No Recovery_* folder found on $DestDrive — skipping triage step."
}

# --- Build combined summary -------------------------------------------

$inventoryCsv = Get-ChildItem $ReportDir -Filter "temp_inventory_*.csv" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$triageCsv    = Get-ChildItem $ReportDir -Filter "triage_summary_*.csv" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

$inventory = if ($inventoryCsv) { Import-Csv $inventoryCsv.FullName } else { @() }
$triage    = if ($triageCsv)    { Import-Csv $triageCsv.FullName }    else { @() }

$topExtensions = $inventory | Group-Object Extension | Sort-Object Count -Descending |
    Select-Object -First 10 Name, Count

$topSizeFiles = $inventory | Sort-Object { [long]$_.SizeBytes } -Descending |
    Select-Object -First 10 FullName, SizeBytes

$mismatches = $triage | Where-Object { $_.PossibleMismatch -eq "True" }

$summary = [PSCustomObject]@{
    GeneratedAt        = (Get-Date).ToString("o")
    SourceDrive        = $SourceDrive
    DestDrive          = $DestDrive
    InventoryFileCount = $inventory.Count
    RecoveredFileCount = $triage.Count
    PossibleMismatchCount = $mismatches.Count
    TopExtensions      = $topExtensions
    TopSizeFiles       = $topSizeFiles
    FlaggedMismatches  = $mismatches
}

$jsonPath = Join-Path $ReportDir "final_report_$timestamp.json"
$summary | ConvertTo-Json -Depth 6 | Out-File -FilePath $jsonPath -Encoding UTF8

Write-Host "`n===== WORKFLOW COMPLETE =====" -ForegroundColor Green
Write-Host "Final report: $jsonPath" -ForegroundColor Green
