[← README](../README.md)

# Chapter 3 — Jump Lists, Clipboard, WER, Shadow Copy + Eric Zimmerman CLI Tools

*ম্যানুয়াল চেক + EZ Tools CLI।*

## ৩.১ Jump Lists (ম্যানুয়াল, কোনো টুল ছাড়াই)

```
%AppData%\Microsoft\Windows\Recent\AutomaticDestinations
%AppData%\Microsoft\Windows\Recent\CustomDestinations
```

এখানে `.automaticDestinations-ms` ফাইল থাকে, যা সম্প্রতি খোলা ফাইল/অ্যাপের রেকর্ড
রাখে। সরাসরি Notepad-এ পড়া যায় না (বাইনারি), কিন্তু ফাইলের modification date
থেকেই কখন activity হয়েছিল তা বোঝা যায়।

## ৩.২ Clipboard History

```
Win + V
```

Clipboard history চালু থাকলে সম্প্রতি কপি করা জিনিস দেখা যায় — চিট লাইসেন্স কি,
ডাউনলোড লিংক, Discord invite ইত্যাদি কপি-পেস্ট করা থাকলে এখানে ধরা পড়তে পারে।

## ৩.৩ Browser Extensions চেক

```
chrome://extensions   (Chrome)
edge://extensions     (Edge)
```

অচেনা extension চেক করুন — কিছু চিট-সম্পর্কিত টুল browser extension হিসেবেও
ডিস্ট্রিবিউট করা হয় (স্ক্রিন-ক্যাপচার বাইপাস, ম্যাক্রো টুল ইত্যাদি)।

## ৩.৪ Windows Error Reporting (WER) ফাইল

```
C:\ProgramData\Microsoft\Windows\WER\ReportArchive
C:\ProgramData\Microsoft\Windows\WER\ReportQueue
```

প্রোগ্রাম ক্র্যাশ করলে এখানে বিস্তারিত ক্র্যাশ রিপোর্ট জমা হয়, যেখানে ক্র্যাশ
হওয়া `.exe`-র পুরো পাথ ও মডিউল লিস্ট থাকে — চিট টুল ক্র্যাশ করলে এখানে ট্রেস
পাওয়া যেতে পারে।

## ৩.৫ Volume Shadow Copy (ডিলিট হওয়া ফাইল রিকভারি চেক)

```
vssadmin list shadows
```

System restore point/shadow copy থাকলে পুরনো ডিলিট হওয়া ফাইল রিকভার করা যায়
(অ্যাডভান্সড, Admin অ্যাক্সেস লাগে)।

## ৩.৬ LNK (Shortcut) ফাইল ম্যানুয়াল চেক

```
%AppData%\Microsoft\Windows\Recent
```

সম্প্রতি খোলা ফাইলের শর্টকাট (.lnk) এখানে থাকে। Right-click → Properties →
"Target" দেখলে অরিজিনাল ফাইলটা কোথায় ছিল বোঝা যায় — ফাইল ডিলিট হয়ে গেলেও এই
শর্টকাট থেকে যায়, যা অরিজিনাল পাথ/নাম জানতে কাজে লাগে।

## ৩.৭ Discord/Chat App লোকাল ক্যাশ

```
%AppData%\discord\Cache
%AppData%\discord\Local Storage\leveldb
```

চ্যাট অ্যাপের লোকাল ক্যাশে স্ক্রিনশট ছাড়াই পুরনো মেসেজ/ছবি জমা থাকে — আগের কোনো
কথোপকথনে চিট কেনা বা আলোচনা হয়ে থাকলে এখানে ধরা পড়তে পারে।

## ৩.৮ ইনস্টল করা ফন্ট/ড্রাইভার টাইমস্ট্যাম্প অ্যানোমালি

```
C:\Windows\Fonts
C:\Windows\System32\drivers
```

চিট ড্রাইভার প্রায়ই একটি সাধারণ ড্রাইভার/ফন্ট ফাইলের নামে (misleading নাম দিয়ে)
লুকানো থাকে — ফাইল লিস্ট "Date modified" দিয়ে সর্ট করলে সম্প্রতি/অস্বাভাবিক
ফাইলটা সহজে চোখে পড়ে।

> এই তিন পার্ট (Chapter 1, 2, 3) একসাথে করলে প্রায় সব ম্যানুয়াল Windows-বেজড
> ফরেনসিক চেক কাভার হয়ে যায় — Registry, Journal, Prefetch, BAM/DAM, Event Logs,
> CMD/PowerShell, ব্রাউজার, চ্যাট ক্যাশ, শর্টকাট, WER ক্র্যাশ লগ — সবকিছু।
>
> **সত্যি কথা বলতে:** এর পরের লেভেল হলো মেমরি ডাম্প অ্যানালাইসিস (RAM-এ সরাসরি
> ইনজেক্ট করা কোড দেখা) বা ডিস্ক ইমেজিং — এগুলোর জন্য সত্যিকারের ফরেনসিক টুল
> লাগবে (WinDbg, Volatility, FTK Imager ইত্যাদি); বিল্ট-ইন Windows কমান্ড দিয়ে
> এসব করা যায় না। এই পর্যায়ে এটা আর "কুইক PC চেক" থাকে না, একটা পূর্ণাঙ্গ
> ডিজিটাল ফরেনসিক ইনভেস্টিগেশন হয়ে যায়।

## ৩.৯ Eric Zimmerman's Tools (EZ Tools) — CLI কমান্ড

Eric Zimmerman-এর ফরেনসিক টুলসেট একটি সম্পূর্ণ বৈধ, ইন্ডাস্ট্রি-স্ট্যান্ডার্ড
ডিজিটাল ফরেনসিক্স টুলসেট — যা আইন প্রয়োগকারী সংস্থা ও করপোরেট ইনভেস্টিগেটররা
ব্যবহার করেন। এই টুলগুলো আগে ম্যানুয়ালি পড়া রেজিস্ট্রি/জার্নাল ডেটাকে
readable ফরম্যাটে (CSV/JSON) পার্স করে দেয়।

**ডাউনলোড (অফিসিয়াল):**
সব টুল একসাথে: `https://ericzimmerman.github.io/#!index.md`
অথবা আলাদা টুল GitHub থেকে: `https://github.com/EricZimmerman`

> ⚠️ শুধুমাত্র এই অফিসিয়াল সোর্স থেকেই ডাউনলোড করুন।

### 1. AmcacheParser (Amcache.hve পার্স করতে)
```
AmcacheParser.exe -f "C:\Windows\AppCompat\Programs\Amcache.hve" --csv "C:\Output"
```
প্রোগ্রাম এক্সিকিউশন হিস্ট্রি বের করে (আগে যা raw বাইনারি হিসেবে পড়া যেত না)।
আউটপুট CSV-তে ফাইল পাথ, এক্সিকিউশন টাইমস্ট্যাম্প ও SHA1 hash থাকে।

### 2. AppCompatCacheParser (Shimcache পার্স করতে)
```
AppCompatCacheParser.exe -f "C:\Windows\System32\config\SYSTEM" --csv "C:\Output"
```

### 3. RECmd (পুরো রেজিস্ট্রি পার্স করার সবচেয়ে শক্তিশালী অপশন)
```
RECmd.exe --bn "BatchExamples\Kroll_Batch.reb" -d "C:\Users\<user>\NTUSER.DAT" --csv "C:\Output"
```
`BatchExamples` ফোল্ডারে প্রি-বিল্ট ব্যাচ ফাইল থাকে যা Run keys, persistence
লোকেশন ইত্যাদি একসাথে স্ক্যান করে।

একটি নির্দিষ্ট key চেক করতে:
```
RECmd.exe -f "C:\Users\<user>\NTUSER.DAT" --kn "Software\Microsoft\Windows\CurrentVersion\Run" --csv "C:\Output"
```

### 4. MFTECmd ($MFT ও USN Journal পার্স করতে)
```
MFTECmd.exe -f "C:\$MFT" --csv "C:\Output"
MFTECmd.exe -f "C:\$Extend\$J" --csv "C:\Output" --json "C:\Output"
```
আগের `fsutil usn readjournal`-এর চেয়ে অনেক বেশি বিস্তারিত।

### 5. JLECmd (Jump List পার্সিং — CLI ভার্সন)
```
JLECmd.exe -d "C:\Users\<user>\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations" --csv "C:\Output"
```

### 6. LECmd (LNK/Shortcut ফাইল পার্সিং)
```
LECmd.exe -d "C:\Users\<user>\AppData\Roaming\Microsoft\Windows\Recent" --csv "C:\Output"
```

### 7. PECmd (Prefetch পার্সিং)
```
PECmd.exe -d "C:\Windows\Prefetch" --csv "C:\Output"
```
প্রোগ্রাম কতবার ও কখন রান হয়েছে তার একটি readable টাইমলাইন তৈরি করে।

### 8. SBECmd (Shellbags পার্সিং)
```
SBECmd.exe -d "C:\Users\<user>\NTUSER.DAT" --csv "C:\Output"
```

### 9. SrumECmd (SRUM ডাটাবেস পার্সিং)
```
SrumECmd.exe -f "C:\Windows\System32\sru\SRUDB.dat" --csv "C:\Output"
```
আনইনস্টল হয়ে যাওয়া প্রোগ্রামের নেটওয়ার্ক/CPU ব্যবহারের হিস্ট্রিও বের করে।

### 10. EvtxECmd (Event Log পার্সিং)
```
EvtxECmd.exe -f "C:\Windows\System32\winevt\Logs\Security.evtx" --csv "C:\Output"
```

### প্র্যাকটিক্যাল ওয়ার্কফ্লো

সব আউটপুট থেকে একটি টাইমলাইন বানাতে **Timeline Explorer** (EZ Tools-এর সাথেই
বান্ডল) ব্যবহার করুন — সব CSV একসাথে খুলে তারিখ/সময় দিয়ে সর্ট করলে পুরো PC-র
অ্যাক্টিভিটির একটাই টাইমলাইন তৈরি হয়ে যায়।

**⚠️ গুরুত্বপূর্ণ নোট**

- সব কমান্ডের জন্য **Administrator প্রিভিলেজ** লাগবে, কারণ `$MFT`, `SYSTEM` hive,
  ও `SRUDB.dat` সাধারণ ইউজার অ্যাক্সেস দিয়ে খোলা যায় না — সিস্টেম চলার সময় এগুলো
  লক করা থাকে।
- `C:\Windows\System32\config\SYSTEM` ও `NTUSER.DAT` সিস্টেম চলা অবস্থায় সরাসরি
  খোলা যায় না — হয় Volume Shadow Copy থেকে কপি করুন, অথবা `reg save` দিয়ে
  এক্সপোর্ট করুন:

```
reg save HKLM\SYSTEM C:\Output\SYSTEM_copy
reg save HKCU C:\Output\NTUSER_copy
```

এরপর সেই কপি করা ফাইলটা পার্স করুন।

> এই CLI কমান্ডগুলো দিয়ে আগের সব ম্যানুয়াল রেজিস্ট্রি/জার্নাল/prefetch চেক এখন
> **অটোমেটেড, readable CSV রিপোর্ট** হিসেবে তৈরি করা যায়।

---
[← Chapter 2](02-extra-registry-cmd.md) · [পরবর্তী: Chapter 4 — Kernel Driver & ETW →](04-kernel-driver-and-etw.md)
