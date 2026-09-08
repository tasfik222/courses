[← README](../README.md)

# Chapter 7 — Appendix: `Check-UnsignedDLLs.ps1` স্ক্রিপ্ট গাইড

একটি চলমান প্রসেসে লোড হওয়া আনসাইনড বা invalid-signature DLL শনাক্ত করার
PowerShell স্ক্রিপ্ট। ফুল স্ক্রিপ্ট ফাইলটি পাওয়া যাবে
[`scripts/Check-UnsignedDLLs.ps1`](../scripts/Check-UnsignedDLLs.ps1)-এ।

## প্যারামিটার

| প্যারামিটার | বর্ণনা |
|---|---|
| `-ProcessName` | প্রসেসের নাম (.exe ছাড়া), যেমন `"notepad"` |
| `-Continuous` | সেট করলে প্রতি কয়েক সেকেন্ড পরপর নতুন লোড হওয়া মডিউলের জন্য মনিটর করতে থাকবে |
| `-IntervalSeconds` | `-Continuous` ব্যবহার করলে পোলিং ইন্টারভাল (ডিফল্ট: 5 সেকেন্ড) |

## ব্যবহারের উদাহরণ

```powershell
.\Check-UnsignedDLLs.ps1 -ProcessName "myapp"
```

গেম প্রসেসের বিরুদ্ধে চালাতে (উদাহরণ):

```powershell
.\Check-UnsignedDLLs.ps1 -ProcessName "valorant" -Continuous -IntervalSeconds 3
```

## এটা কী করে

স্ক্রিপ্টটি নির্দিষ্ট প্রসেসের সব লোড হওয়া মডিউল (DLL) ধরে, প্রতিটির
Authenticode signature চেক করে (`Get-AuthenticodeSignature`), এবং ফলাফল
কালার-কোড করে দেখায়:

- 🟢 **Valid** — সাইনড ও ভ্যালিড (স্ক্রিপ্টে ডিফল্টভাবে হাইড করা, চাইলে আনকমেন্ট
  করে দেখানো যায়)
- 🔴 **NotSigned** — আনসাইনড DLL — সন্দেহজনক, বিশেষ করে গেম প্রসেসে অচেনা নামের
  ক্ষেত্রে
- 🟡 **SUSPECT (অন্য status)** — সিগনেচার আছে কিন্তু ইনভ্যালিড/এক্সপায়ার্ড/অচেনা
  সাইনার — signer-এর নামসহ দেখায়

## গুরুত্বপূর্ণ নোট

- **Administrator হিসেবে রান করুন** — মডিউল লিস্ট পড়তে Admin অ্যাক্সেস লাগতে
  পারে, নাহলে "could not read modules" ওয়ার্নিং আসবে।
- এই স্ক্রিপ্ট শুধু **evidence তৈরি করে**, কোনো রায় দেয় না — একটি আনসাইনড DLL
  মানেই সেটা চিট নয় (অনেক legitimate ওপেন-সোর্স টুলও আনসাইনড হতে পারে); ফলাফল
  Chapter 6-এর SOP অনুযায়ী বিশ্লেষণ করুন।
- `-Continuous` মোডে চালানোর সময় মনে রাখবেন এটা একটা লাইভ মনিটর — ম্যাচ চলাকালীন
  রান করলে রানটাইমে ইনজেক্ট হওয়া DLL ধরার সম্ভাবনা বেশি।

---
[← Chapter 6](06-screenshot-analyst-sop.md) · [README-এ ফিরে যান →](../README.md)
