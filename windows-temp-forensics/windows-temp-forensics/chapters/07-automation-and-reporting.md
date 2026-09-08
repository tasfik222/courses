# 7. অটোমেশন ও রিপোর্টিং

## উদ্দেশ্য
আগের সব ধাপ (কালেকশন → রিকভারি → ট্রায়াজ) একত্র করে একটি সম্পূর্ণ,
রিপোর্টেবল ওয়ার্কফ্লোতে পরিণত করা।

## ৭.১ মূল স্ক্রিপ্ট: `full-temp-workflow.ps1`

এই স্ক্রিপ্টটি নিচের ধাপগুলো ক্রমানুসারে চালায়:

1. **লাইভ কালেকশন** — `collect-temp.ps1`-এর লজিক ব্যবহার করে বর্তমান টেম্প
   ফাইলগুলোর ইনভেন্টরি তৈরি করে।
2. **winfr ব্যাচ রিকভারি** — `recover-temp-batch.ps1` কল করে ডিলিটেড ফাইল
   রিকভার করে।
3. **হ্যাশ জেনারেশন** — কালেক্ট করা এবং রিকভার করা — উভয় সেটের ফাইলের হ্যাশ
   বের করে।
4. **CSV/JSON রিপোর্ট** — সব ফলাফল একত্র করে একটি টাইমস্ট্যাম্পড রিপোর্ট
   তৈরি করে।

দেখুন: [`scripts/full-temp-workflow.ps1`](../scripts/full-temp-workflow.ps1)

## ৭.২ রিপোর্ট ফরম্যাট

চূড়ান্ত রিপোর্টে (JSON + CSV উভয় ফরম্যাটে) থাকবে:

### ক) টাইমলাইন
প্রতিটি ফাইলের `CreationTime` / `LastWriteTime` অনুযায়ী ক্রমানুসারে সাজানো
তালিকা — কখন কী তৈরি/পরিবর্তিত হয়েছিল তার একটি চিত্র দেয়।

### খ) টপ এক্সটেনশন
```powershell
$inventory | Group-Object Extension | Sort-Object Count -Descending |
    Select-Object Name, Count -First 10
```

### গ) টপ সাইজ ফাইল
```powershell
$inventory | Sort-Object Length -Descending | Select-Object -First 10 FullName, Length
```

### ঘ) সন্দেহজনক প্যাথ/নাম প্যাটার্ন
সাধারণ হিউরিস্টিক (শুধু ফ্ল্যাগ করার জন্য, ম্যানুয়াল রিভিউ আবশ্যক):

```powershell
$suspiciousPattern = '^[a-f0-9]{8,}\.(exe|dll)$'   # GUID/হেক্স-স্টাইল নাম
$inventory | Where-Object { $_.Name -match $suspiciousPattern }
```

## ৭.৩ আউটপুট স্ট্রাকচার

```
E:\reports\
  temp_inventory_20260908_1400.csv
  recovered_hashes_20260908_1400.csv
  triage_summary_20260908_1400.csv
  final_report_20260908_1400.json
```

## ৭.৪ প্র্যাকটিস

`scripts/full-temp-workflow.ps1` চালিয়ে সম্পূর্ণ ওয়ার্কফ্লো দেখুন। রিপোর্ট
ফোল্ডারে গিয়ে JSON রিপোর্টটি খুলে পড়ুন — এটি এমনভাবে ডিজাইন করা যাতে
একটি ইনসিডেন্ট রেসপন্স টিমকে সরাসরি শেয়ার করা যায়।

## পরবর্তী ধাপ

[chapters/08-labs-and-challenges.md](08-labs-and-challenges.md) — এখন সবকিছু হাতে-কলমে
প্র্যাকটিস করুন।
