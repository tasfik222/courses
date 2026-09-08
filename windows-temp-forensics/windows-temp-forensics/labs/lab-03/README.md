# Lab 03 — Full Case-Study Workflow

**Scenario:** You've been told "suspicious activity" occurred on a test VM in
the last 24 hours, and the related files were deleted from Temp. Your job is
to run the full workflow and submit a report.

## Setup (simulate the incident)

```powershell
"payload" | Out-File "$env:TEMP\update_svc.dat"
Copy-Item C:\Windows\System32\notepad.exe "$env:TEMP\9f8e7d6c.exe"
Compress-Archive -Path "$env:TEMP\update_svc.dat" -DestinationPath "$env:TEMP\bundle.zip"

Start-Sleep -Seconds 2
Remove-Item "$env:TEMP\update_svc.dat","$env:TEMP\9f8e7d6c.exe","$env:TEMP\bundle.zip" -Force
```

## Run the full workflow

```powershell
.\scripts\full-temp-workflow.ps1 -SourceDrive C: -DestDrive E: -ReportDir E:\reports
```

## Review

Open the generated `final_report_*.json` in `E:\reports\` and answer:

1. Does the timeline show the files in the order they were created?
2. Does the extension breakdown match what was planted (`.dat`, `.exe`, `.zip`)?
3. Did the "suspicious pattern" heuristic flag `9f8e7d6c.exe`? Any false
   positives/negatives?

## Deliverable

Write a one-page summary: which files were recovered, which weren't (if any),
and why — tying your answer back to the delete/recovery theory from
[Chapter 3](../../chapters/03-delete-and-recovery-theory.md).
