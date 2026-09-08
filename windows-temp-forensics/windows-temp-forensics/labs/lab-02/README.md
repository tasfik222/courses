# Lab 02 — Executable Artifact Recovery & PE Check

**Prerequisites:** Lab 01 completed, `sigcheck.exe` available (Sysinternals).

## Steps

1. Copy a benign, signed system binary into Temp under a random-looking name
   (this simulates a dropped executable for practice purposes only — it is
   just a copy of a normal Windows tool):
   ```powershell
   Copy-Item C:\Windows\System32\notepad.exe "$env:TEMP\a1b2c3d4.exe"
   ```
2. Record its hash and delete it:
   ```powershell
   Get-FileHash "$env:TEMP\a1b2c3d4.exe" | Export-Csv .\lab02-original-hash.csv -NoTypeInformation
   Remove-Item "$env:TEMP\a1b2c3d4.exe" -Force
   ```
3. Recover it:
   ```powershell
   winfr C: E: /extensive /n "\Users\$env:USERNAME\AppData\Local\Temp\a1b2c3d4.exe" /y
   ```
4. Check the digital signature:
   ```powershell
   sigcheck.exe -h -e "E:\Recovery_*\**\a1b2c3d4.exe"
   ```
5. Confirm it's a real PE file via magic bytes:
   ```powershell
   $bytes = [System.IO.File]::ReadAllBytes("E:\Recovery_*\**\a1b2c3d4.exe")
   ($bytes[0..1] | ForEach-Object { $_.ToString("X2") }) -join "" # expect "4D5A"
   ```

## Discussion

Even though the file was renamed to look random, both the digital signature
and the PE header correctly identify it as `notepad.exe` — illustrating why
extension/filename alone should never be trusted during triage.
