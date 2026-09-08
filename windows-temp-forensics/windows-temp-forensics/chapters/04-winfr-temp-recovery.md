# 4. Windows File Recovery (winfr) দিয়ে Temp রিকভারি

## উদ্দেশ্য
Microsoft-এর অফিসিয়াল `winfr` টুল দিয়ে টেম্প ফোল্ডার থেকে ডিলিটেড ফাইল
রিকভার করা শিখা।

## ৪.১ ইনস্টলেশন

Microsoft Store থেকে **"Windows File Recovery"** ইনস্টল করুন, অথবা:

```powershell
winget install --id 9N26S50LN705 -e
```

## ৪.২ কমান্ড স্ট্রাকচার

```
winfr <source-drive>: <dest-drive>: /<mode> /n <path-filter>
```

- **source-drive:** যেখান থেকে রিকভার করবেন (যেমন `C:`)
- **dest-drive:** আউটপুট কোথায় সেভ হবে — **অবশ্যই source থেকে ভিন্ন ড্রাইভ**
  হতে হবে (যেমন `E:`)
- **mode:**
  - `/regular` — NTFS-এর জন্য দ্রুত, সাম্প্রতিক ডিলিটের জন্য উপযুক্ত
  - `/extensive` — সাইনেচার-বেজড স্ক্যান, ধীর কিন্তু বেশি ধরনের ফাইল খুঁজে পায়
    (টেম্প রিকভারির জন্য সাধারণত এটি ব্যবহার করা হয়)
- **/n:** পাথ ফিল্টার (wildcard সহ)

## ৪.৩ Temp-স্পেসিফিক উদাহরণ

```powershell
winfr C: E: /extensive /n "\Users\tasfi\AppData\Local\Temp\*.exe"
winfr C: E: /extensive /n "\Users\tasfi\AppData\Local\Temp\*.dll"
winfr C: E: /extensive /n "\Users\tasfi\AppData\Local\Temp\*.tmp"
```

> নোট: `<user>`-এর জায়গায় আপনার নিজের ইউজারনেম বসান। পাথ backslash (`\`) দিয়ে
> শুরু হয় (drive letter ছাড়া)।

## ৪.৪ মাল্টিপল এক্সটেনশনের জন্য ব্যাচ স্ক্রিপ্ট

একের পর এক ম্যানুয়ালি কমান্ড চালানোর বদলে একটি লুপ ব্যবহার করুন:

```powershell
$user = $env:USERNAME
$extensions = @("exe","dll","tmp","dat","dmp","zip")
$tempPath = "\Users\$user\AppData\Local\Temp"

foreach ($ext in $extensions) {
    Write-Host "Recovering *.$ext ..." -ForegroundColor Cyan
    winfr C: E: /extensive /n "$tempPath\*.$ext"
}
```

সম্পূর্ণ, ত্রুটি-হ্যান্ডলিং সহ স্ক্রিপ্ট: [`scripts/recover-temp-batch.ps1`](../scripts/recover-temp-batch.ps1)

## ৪.৫ গুরুত্বপূর্ণ সীমাবদ্ধতা

- winfr **প্রশাসক (Administrator)** পারমিশনে চালাতে হয়।
- প্রথমবার চালালে EULA গ্রহণ করতে হয় (`/y` ফ্ল্যাগ দিয়ে স্বয়ংক্রিয় করা যায়)।
- আউটপুট একটি টাইমস্ট্যাম্পড সাব-ফোল্ডারে যায় (`E:\Recovery_20260101_120000\`)
  — মূল ফোল্ডার স্ট্রাকচার প্রিজার্ভ হয় না, তাই ফাইলনাম/এক্সটেনশন দিয়ে চেনা লাগে।
- `/extensive` মোড সময়সাপেক্ষ হতে পারে বড় ডিস্কে।

## ৪.৬ প্র্যাকটিস

1. ল্যাব VM-এ কয়েকটি টেস্ট ফাইল টেম্পে তৈরি করুন, ডিলিট করুন।
2. উপরের ব্যাচ স্ক্রিপ্ট চালিয়ে রিকভার করুন।
3. `E:\Recovery_*` ফোল্ডারে গিয়ে দেখুন ক'টি ফাইল ফিরে পেলেন।

## পরবর্তী ধাপ

[chapters/05-triage-and-verification.md](05-triage-and-verification.md) — রিকভার করা ফাইল
আসলেই দরকারি কিনা তা যাচাই করা শিখুন।
