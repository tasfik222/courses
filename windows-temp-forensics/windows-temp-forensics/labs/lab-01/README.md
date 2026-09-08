# Lab 01 — Basic Delete & Recovery

**Prerequisites:** Clean VM snapshot, PowerShell running as Administrator,
Windows File Recovery installed.

## Steps

1. Create test files:
   ```powershell
   1..5 | ForEach-Object {
       "Test content $_" | Out-File "$env:TEMP\test_$_.tmp"
   }
   ```
2. Record hashes:
   ```powershell
   Get-ChildItem "$env:TEMP\test_*.tmp" | Get-FileHash |
       Export-Csv .\lab01-original-hashes.csv -NoTypeInformation
   ```
3. Delete permanently:
   ```powershell
   Get-ChildItem "$env:TEMP\test_*.tmp" | Remove-Item -Force
   ```
4. Recover:
   ```powershell
   winfr C: E: /extensive /n "\Users\$env:USERNAME\AppData\Local\Temp\test_*.tmp" /y
   ```
5. Verify:
   ```powershell
   Get-ChildItem "E:\Recovery_*\**\test_*.tmp" -Recurse | Get-FileHash |
       Export-Csv .\lab01-recovered-hashes.csv -NoTypeInformation
   ```
6. Compare `lab01-original-hashes.csv` and `lab01-recovered-hashes.csv` —
   all `Hash` values should match.

## Success criteria

All 5 files recovered with identical SHA-256 hashes to the originals.
