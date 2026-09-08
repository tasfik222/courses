# 5. রিকভার ফাইল ট্রায়াজ ও ভেরিফিকেশন

## উদ্দেশ্য
winfr দিয়ে যা কিছু "রিকভার" হয়েছে, তার মধ্যে থেকে প্রকৃত ও গুরুত্বপূর্ণ ফাইল
বাছাই করা — কারণ extensive স্ক্যান অনেক সময় ভাঙা/আংশিক/অপ্রাসঙ্গিক ফাইলও নিয়ে
আসে।

## ৫.১ হ্যাশ ভেরিফিকেশন

```powershell
Get-ChildItem E:\recovered\ -Recurse -File |
    Get-FileHash -Algorithm SHA256 |
    Export-Csv E:\reports\recovered_hashes.csv -NoTypeInformation
```

যদি আপনার কাছে আগের (কালেকশন-পর্বের) হ্যাশ ইনভেন্টরি থাকে (চ্যাপ্টার ২ থেকে),
তাহলে দুটো CSV তুলনা করে দেখতে পারেন কোন ফাইলগুলো হুবহু মিলছে:

```powershell
$original = Import-Csv E:\reports\temp_inventory.csv
$recovered = Import-Csv E:\reports\recovered_hashes.csv

Compare-Object $original.Hash $recovered.Hash -IncludeEqual |
    Where-Object { $_.SideIndicator -eq "==" }
```

## ৫.২ এক্সটেনশন বনাম প্রকৃত ম্যাজিক বাইট (ফাইল সিগনেচার)

রিকভার হওয়া ফাইলের এক্সটেনশন ভুল/মিসলিডিং হতে পারে। ফাইলের আসল টাইপ চেক করতে
"ম্যাজিক বাইট" (file header) দেখুন:

```powershell
function Get-FileMagic {
    param([string]$Path)
    $bytes = Get-Content -Path $Path -Encoding Byte -TotalCount 4 -ErrorAction SilentlyContinue
    ($bytes | ForEach-Object { $_.ToString("X2") }) -join " "
}

Get-FileMagic "E:\recovered\example.tmp"
```

সাধারণ ম্যাজিক বাইট রেফারেন্স:

| হেক্স হেডার | ফাইল টাইপ |
|-------------|-----------|
| `4D 5A` (MZ) | Windows PE (exe/dll) |
| `50 4B 03 04` | ZIP (docx/xlsx/apk-ও এই ফরম্যাট ব্যবহার করে) |
| `25 50 44 46` | PDF |
| `1F 8B` | GZIP |

## ৫.৩ PE ফাইল (exe/dll/sys) স্ট্যাটিক চেক

**sigcheck** দিয়ে ডিজিটাল সিগনেচার যাচাই:

```powershell
sigcheck.exe -h -e E:\recovered\suspicious.exe
```

- `-e` → শুধু এক্সিকিউটেবল স্ক্যান করে
- `-h` → হ্যাশও দেখায়

**PEStudio** বা অন্য স্ট্যাটিক অ্যানালাইসিস টুল দিয়ে দেখতে পারেন:
- Imports/Exports
- সন্দেহজনক স্ট্রিং
- সেকশন এনট্রপি (packed/obfuscated কিনা বোঝার ইঙ্গিত)

> এই কোর্সে আমরা কোনো ম্যালওয়্যার তৈরি বা রিভার্স-ইঞ্জিনিয়ারিং এক্সপ্লয়েটেশন
> শেখাই না — শুধু স্ট্যাটিক ট্রায়াজ/আইডেন্টিফিকেশন পর্যন্ত সীমাবদ্ধ থাকি।
> সন্দেহজনক ফাইল পেলে প্রতিষ্ঠানের সিকিউরিটি টিম/একটি স্যান্ডবক্স সার্ভিসে
> (যেমন VirusTotal, নিজস্ব sandbox) জমা দিন — ম্যানুয়ালি রান করবেন না।

## ৫.৪ অজানা এক্সটেনশন ফাইল হ্যান্ডলিং

`.tmp`, `.dat`, বা কোনো এক্সটেনশন-বিহীন ফাইলের ক্ষেত্রে:

1. প্রথমে ম্যাজিক বাইট চেক করুন (৫.২)
2. যদি টেক্সট-ভিত্তিক মনে হয়, `Get-Content -TotalCount 50` দিয়ে প্রথম কিছু লাইন দেখুন
3. এখনও অস্পষ্ট হলে, ফাইলটিকে "unidentified" ক্যাটাগরিতে রেখে রিপোর্টে নোট করুন
   — অনুমান করে এক্সটেনশন পাল্টাবেন না

## ৫.৫ প্র্যাকটিস

`scripts/triage-recovered.ps1` চালিয়ে দেখুন এটি স্বয়ংক্রিয়ভাবে:
- হ্যাশ জেনারেট করে
- ম্যাজিক বাইট চেক করে extension mismatch খুঁজে বের করে
- একটি সামারি CSV তৈরি করে

## পরবর্তী ধাপ

[chapters/06-anticheat-malware-perspective.md](06-anticheat-malware-perspective.md)
