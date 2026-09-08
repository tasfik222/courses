# 2. Temp Folder থেকে লাইভ ডেটা কালেকশন

## উদ্দেশ্য
রিডার যেন নিজে একটি কালেক্টর স্ক্রিপ্ট লিখতে/চালাতে পারে যা এখনো-বিদ্যমান
টেম্প ফাইলগুলোর একটি ইনভেন্টরি ও হ্যাশসহ কপি তৈরি করে।

## ২.১ PowerShell দিয়ে `%TEMP%` এক্সপ্লোর করা

```powershell
$env:TEMP
Get-ChildItem -Path $env:TEMP -Recurse -File -ErrorAction SilentlyContinue
```

আউটপুট বড় হতে পারে; ফিল্টার করে দেখা ভালো:

```powershell
Get-ChildItem -Path $env:TEMP -Recurse -File -ErrorAction SilentlyContinue |
    Sort-Object Length -Descending |
    Select-Object -First 20 FullName, Length, LastWriteTime
```

## ২.২ কপি + ইনভেন্টরি স্ক্রিপ্টের লজিক

মূল স্ক্রিপ্ট (`scripts/collect-temp.ps1`) তিনটি ধাপে কাজ করে:

1. **কপি লজিক** — উৎস থেকে একটি আলাদা আউটপুট ফোল্ডারে ফাইল কপি করে (মূল ফাইলে
   টাচ না করে), ফোল্ডার স্ট্রাকচার প্রিজার্ভ করে।
2. **হ্যাশ জেনারেশন** — প্রতিটি ফাইলের SHA-256 হ্যাশ বের করে, যাতে পরে অখণ্ডতা
   (integrity) যাচাই করা যায়।
3. **CSV ইনভেন্টরি** — ফাইলনাম, পাথ, সাইজ, টাইমস্ট্যাম্প, হ্যাশ — সব একটি CSV-তে
   এক্সপোর্ট করে, যা রিপোর্টিং/ট্রায়াজের জন্য ব্যবহার করা যায়।

দেখুন: [`scripts/collect-temp.ps1`](../scripts/collect-temp.ps1)

## ২.৩ ফাইল সিলেকশন স্ট্র্যাটেজি

সব ফাইল কালেক্ট করা অপ্রয়োজনীয় ও সময়সাপেক্ষ হতে পারে। তাই ফিল্টার করুন:

### এক্সটেনশন ফিল্টার
```powershell
$targetExt = @(".exe",".dll",".tmp",".dat",".zip",".rar")
Get-ChildItem $env:TEMP -Recurse -File |
    Where-Object { $targetExt -contains $_.Extension }
```

### সাইজ ফিল্টার
```powershell
Get-ChildItem $env:TEMP -Recurse -File |
    Where-Object { $_.Length -gt 1KB -and $_.Length -lt 500MB }
```

### টাইম-উইন্ডো ফিল্টার (সাম্প্রতিক কার্যকলাপ)
```powershell
$cutoff = (Get-Date).AddHours(-24)   # অথবা AddDays(-7)
Get-ChildItem $env:TEMP -Recurse -File |
    Where-Object { $_.LastWriteTime -gt $cutoff }
```

## ২.৪ প্র্যাকটিস

1. উপরের ফিল্টারগুলো নিজের ল্যাব VM-এ চালিয়ে দেখুন কতগুলো ফাইল ম্যাচ করে।
2. `scripts/collect-temp.ps1` চালিয়ে একটি ইনভেন্টরি CSV তৈরি করুন।
3. CSV এক্সেল/PowerShell-এ খুলে সবচেয়ে বড় ৫টি ফাইল খুঁজে বের করুন।

## পরবর্তী ধাপ

[chapters/03-delete-and-recovery-theory.md](03-delete-and-recovery-theory.md)
