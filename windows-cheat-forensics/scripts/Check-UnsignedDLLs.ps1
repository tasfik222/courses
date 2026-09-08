<#
.SYNOPSIS
    Detects unsigned or invalid-signature DLLs loaded by a running process.

.PARAMETER ProcessName
    Name of the process (without .exe), e.g. "notepad"

.PARAMETER Continuous
    If set, keeps monitoring every few seconds for newly loaded modules.

.EXAMPLE
    .\Check-UnsignedDLLs.ps1 -ProcessName "myapp"
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$ProcessName,

    [switch]$Continuous,

    [int]$IntervalSeconds = 5
)

function Check-ProcessModules {
    param([string]$Name)

    $procs = Get-Process -Name $Name -ErrorAction SilentlyContinue

    if (-not $procs) {
        Write-Warning "Process '$Name' not found running."
        return
    }

    foreach ($proc in $procs) {
        Write-Host "`n=== PID: $($proc.Id) | Process: $($proc.ProcessName) ===" -ForegroundColor Cyan

        try {
            $modules = $proc.Modules
        }
        catch {
            Write-Warning "PID $($proc.Id) - could not read modules (may be a permission issue). Try running as Administrator."
            continue
        }

        foreach ($mod in $modules) {
            $path = $mod.FileName
            if (-not $path) { continue }

            try {
                $sig = Get-AuthenticodeSignature -FilePath $path -ErrorAction Stop

                switch ($sig.Status) {
                    "Valid" {
                        # Signed & valid - skip/optionally show
                        # Write-Host "[OK] $path" -ForegroundColor Green
                    }
                    "NotSigned" {
                        Write-Host "[UNSIGNED] $path" -ForegroundColor Red
                    }
                    default {
                        Write-Host "[SUSPECT: $($sig.Status)] $path" -ForegroundColor Yellow
                        if ($sig.SignerCertificate) {
                            Write-Host "    Signer: $($sig.SignerCertificate.Subject)" -ForegroundColor DarkYellow
                        }
                    }
                }
            }
            catch {
                Write-Host "[ERROR reading signature] $path - $($_.Exception.Message)" -ForegroundColor DarkRed
            }
        }
    }
}

if ($Continuous) {
    Write-Host "Starting continuous monitoring ($IntervalSeconds sec interval). Press Ctrl+C to stop." -ForegroundColor Magenta
    while ($true) {
        Check-ProcessModules -Name $ProcessName
        Start-Sleep -Seconds $IntervalSeconds
    }
}
else {
    Check-ProcessModules -Name $ProcessName
}
