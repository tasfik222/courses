[← README](../README.md)

# Chapter 4 — Advanced: Kernel Driver Forensics, ETW ও PE-sieve আউটপুট পড়া

*টুল-অ্যাসিস্টেড / এক্সপার্ট লেভেল।*

## ৪.১ Investigation Guide — প্রতিটি চেক কীভাবে করবেন

### ১. Kernel / Driver-Level চেক

**সাইনড বনাম আনসাইনড ড্রাইভার চেক** — PowerShell Administrator মোডে খুলে রান করুন:
```
driverquery /v /fo csv | ConvertFrom-Csv | Export-Csv drivers.csv
```

`sigcheck` (Sysinternals) দিয়ে ড্রাইভার পাবলিশার ক্রস-চেক করুন:
```
sigcheck64.exe -u -e C:\Windows\System32\drivers
```
সার্টিফিকেট ইস্যুয়ারকে পরিচিত চিট-প্রোভাইডার বা লিক হওয়া সার্টিফিকেটের লিস্টের
সাথে মিলিয়ে দেখুন (কমিউনিটি-মেইনটেইনড ব্লকলিস্ট পাওয়া যায়)।

**MiniFilter ড্রাইভার চেক:**
```
fltmc filters
fltmc instances
```
স্ট্যান্ডার্ড Windows/AV filter-এর অংশ নয় এমন filter নাম খুঁজুন।

**BYOVD (Bring Your Own Vulnerable Driver) চেক:**
- লোড হওয়া ড্রাইভার লিস্টকে known-vulnerable driver hash ডাটাবেসের সাথে
  তুলনা করুন (যেমন LOLDrivers প্রজেক্ট)।
- ইউজার যা ইনস্টল করেছেন বলে জানাননি এমন পুরনো/অস্বাভাবিক utility বা AV
  ড্রাইভার লোড হয়ে আছে কিনা দেখুন।

### ২. Boot-Level চেক

**Secure Boot / Test Signing স্ট্যাটাস:**
```
bcdedit /enum
Confirm-SecureBootUEFI
```
`testsigning` যদি `Yes` হয়, অথবা Secure Boot বন্ধ থাকে, সেটা রেড ফ্ল্যাগ —
অনেক kernel-mode চিটের আনসাইনড ড্রাইভার লোড করতে এটা দরকার হয়।

**Boot log চেক** — সাময়িকভাবে বুট লগিং এনাবল করুন
(`bcdedit /set {current} bootlog yes`) এবং রিবুটের পর `C:\Windows\ntbtlog.txt`
রিভিউ করুন অপ্রত্যাশিত ড্রাইভার লোডের জন্য।

### ৩. ভার্চুয়ালাইজেশন / আইসোলেশন ইভেশন

**VM/hypervisor ডিটেক্ট:**
```
systeminfo | findstr /i "hyper-v virtual"
wmic computersystem get model,manufacturer
```
`Get-CimInstance Win32_ComputerSystem` ব্যবহার করুন ও VM-টিপিক্যাল vendor নাম
(VMware, VirtualBox, QEMU) খুঁজুন।

**HWID স্পুফার হাইপারভাইজর লেভেলে চলছে কিনা:** "bare metal" দাবি করলেও
hypervisor উপস্থিতি চেক করুন — `systeminfo`-এ "A hypervisor has been detected"
দেখালে বুঝবেন একটি নেস্টেড/হিডেন হাইপারভাইজর লেয়ার সক্রিয়।

### ৪. ফাইল সিগনেচার / হ্যাশ লেভেল

**সন্দেহজনক ফাইল হ্যাশ করুন:**
```
Get-FileHash -Algorithm SHA256 "C:\path\to\file.exe"
```
হ্যাশ VirusTotal-এর পাশাপাশি কমিউনিটি চিট-হ্যাশ ডাটাবেসের সাথেও ক্রস-চেক করুন
(শুধু VT প্রায়ই প্রাইভেট/FUD চিট মিস করে)।

**Entropy / প্যাকিং অ্যানালাইসিস** — Detect It Easy (DIE) বা PEiD দিয়ে সন্দেহজনক
executable-এর entropy চেক করুন। 8.0-এর কাছাকাছি হাই entropy সাধারণত প্যাকিং
নির্দেশ করে।

### ৫. Sysmon Event ID রিভিউ

Sysmon ইনস্টল করে ভালো একটি ruleset (যেমন SwiftOnSecurity-এর sysmon-config)
কনফিগার করে **Applications and Services Logs → Microsoft → Windows → Sysmon →
Operational**-এ এই Event ID গুলো দেখুন:

| Event ID | অর্থ / কী খুঁজবেন |
|---|---|
| 1 — Process Create | কমান্ড-লাইন আর্গুমেন্টে সন্দেহজনক ফ্ল্যাগ বা অস্বাভাবিক parent-child সম্পর্ক |
| 7 — Image Loaded | গেম প্রসেসে অপ্রত্যাশিত DLL লোড হচ্ছে কিনা |
| 8 — CreateRemoteThread | DLL ইনজেকশনের ক্লাসিক লক্ষণ |
| 10 — ProcessAccess | কোন প্রসেস গেম প্রসেসে হ্যান্ডেল খুলেছে — external চিট মেমরি read/write করলে এখানে দেখা যাবে |
| 11 — FileCreate | রিপোর্ট করা গেমপ্লে সময়ের আশেপাশে নতুন ফাইল তৈরি হয়েছে কিনা |
| 13 — RegistryEvent | পরিচিত চিট persistence লোকেশনে (Run keys, services ইত্যাদি) রেজিস্ট্রি write |

### ৬. কমিউনিকেশন ট্রেস

**Discord ক্যাশ চেক:**
```
%AppData%\discord\Cache
%AppData%\discord\Local Storage\leveldb
```
leveldb viewer দিয়ে পার্স করলে ক্যাশড মেসেজ/ছবি রিকভার করা যেতে পারে, যা
চিট-সেলার কথোপকথন বা কেনার কনফার্মেশন প্রকাশ করতে পারে। (প্রাইভেসি ইস্যুর কারণে
শুধুমাত্র যথাযথ অনুমতি/সম্মতি নিয়েই এটা করুন।)

### ৭. Power / Sleep আর্টিফ্যাক্ট

**Hibernation ফাইল** — `C:\hiberfil.sys`-এ থাকে (হিডেন সিস্টেম ফাইল)। শাটডাউনের
আগের মেমরি অবশিষ্টাংশ থাকতে পারে — analyze করতে মেমরি-ফরেনসিক টুল (যেমন
Volatility-এর imagecopy/hibernation plugin) লাগবে।

**Pagefile অ্যানালাইসিস** — `C:\pagefile.sys`-এ থাকে। `strings.exe`
(Sysinternals) বা hex viewer দিয়ে চিট প্রসেসের নাম/স্ট্রিং খুঁজুন:
```
strings64.exe -accepteula C:\pagefile.sys | findstr /i "cheatname"
```

### ৮. Alternate Data Streams (ADS)

```
Get-Item -Path "C:\path\to\file.exe" -Stream *
```
`:$DATA` ছাড়া অন্য কোনো stream থাকলে সেটা আরও তদন্তের যোগ্য।

### ৯. Environment Variables / PATH

```
Get-ChildItem Env:
```
PATH-এ যোগ করা অস্বাভাবিক এন্ট্রি বা অপ্রত্যাশিত ফোল্ডারে পয়েন্ট করা কাস্টম
ভ্যারিয়েবল খুঁজুন (লোডার স্ক্রিপ্টের জন্য কমন)।

### প্র্যাকটিক্যাল নোট

- **অপারেশনের ক্রম গুরুত্বপূর্ণ:** volatile evidence (রানিং প্রসেস, মেমরি,
  নেটওয়ার্ক কানেকশন) সবসময় কম volatile evidence (registry, files, logs)-এর
  *আগে* সংগ্রহ করা উচিত, যাতে ডেটা হারিয়ে না যায়।
- **সবকিছু ডকুমেন্ট করুন:** প্রতিটি কমান্ডের আউটপুট স্ক্রিনশট/লগ করুন।
- **Chain of custody:** ফলাফল কোনো ban বা ডিসপিউটে গড়ালে কে কখন কোন চেক
  চালিয়েছে তার স্পষ্ট রেকর্ড রাখুন।
- Volatility, Sysmon, Process Hacker, FTK Imager, Hayabusa, sigcheck, ও
  strings.exe — সব বৈধ, পাবলিকলি available ফরেনসিক/সিসঅ্যাডমিন টুল।

## ৪.২ Kernel-Level Driver Forensics & ETW Tracing

Vanguard/BattlEye-এর মতো kernel-level অ্যান্টি-চিট বাইপাস করতে অ্যাডভান্সড চিট
নিজেকে একটি **kernel driver** হিসেবে লোড করে, যা PE-sieve বা Task Manager-এর
মতো সাধারণ user-level স্ক্যানে ধরা পড়ে না।

**Driver Signature Enforcement চেক:**
```
driverquery /v /fo LIST
```
আউটপুটে প্রতিটি ড্রাইভারের "Link Date" ও পাথ দেখাবে। পাথ যদি
`C:\Windows\System32\drivers\`-এর বাইরে হয়, সম্প্রতি ইনস্টল হয়ে থাকে, বা অচেনা
নাম হয় — সেটা লক্ষ্য করুন।

**আনসাইনড ড্রাইভার খুঁজতে:**
```
sigverif
```
বিল্ট-ইন GUI টুল, সব সাইনড/আনসাইনড ড্রাইভারের লিস্ট বানায়
(`sigverif.txt` লগ ফাইল হিসেবেও সেভ হয়)।

**Test Signing Mode চেক:**
```
bcdedit /enum | findstr "testsigning"
```
`testsigning` = **Yes** মানে কাস্টম ড্রাইভার লোড করার মোড চালু আছে — সাধারণ
ইউজার কখনো এটা নিজে চালু করেন না; শুধু ডেভেলপার বা কাস্টম-ড্রাইভার ব্যবহারকারীরা
করেন (অনেক kernel চিটও নিজেই এটা চালু করে)।

**ETW (Event Tracing for Windows) — কনসেপ্ট**

ETW হলো Windows-এর লো-লেভেল লগিং ফ্রেমওয়ার্ক, যা kernel/driver-level ইভেন্ট
পর্যন্ত ক্যাপচার করতে পারে।

সহজ চেক (বিল্ট-ইন, GUI):
```
perfmon /rel
```
Reliability Monitor খোলে, যা সিস্টেম ক্র্যাশ, ড্রাইভার ফেইলিওর ও হার্ডওয়্যার
ইভেন্টের টাইমলাইন দেখায়।

অ্যাডভান্সড ETW সেশন ক্যাপচার:
```
logman query providers | findstr -i "kernel"
```
এই লেভেলে সত্যিকারের ট্রেস ক্যাপচার করতে `logman start` দিয়ে সেশন শুরু করে
Windows Performance Analyzer (WPA) বা WinDbg দিয়ে অ্যানালাইজ করতে হয় — এই
পর্যায়ে এটা আর "কুইক চেক" থাকে না।

**সহজ বিকল্প: Autoruns-এর Driver ট্যাব**

Autoruns (Sysinternals, পোর্টেবল, ইনস্টল লাগে না) একটি "Drivers" ট্যাবে সব
লোড হওয়া kernel driver, পাবলিশার/সিগনেচার স্ট্যাটাস (কালার-কোডেড — আনসাইনড
হাইলাইট করা), ফাইল পাথ, ও সরাসরি VirusTotal-এ চেক করার অপশন দেখায়।

> ব্যবহারিকভাবে এটাই সবচেয়ে প্র্যাকটিক্যাল অ্যাপ্রোচ — raw ETW/WinDbg শেখার
> চেয়ে অনেক সহজ।

## ৪.৩ PE-sieve আউটপুট কীভাবে পড়বেন

```
pe-sieve64.exe /pid <game_process_PID>
```

স্ক্যান শেষে দুটো জিনিস পাওয়া যায়: (১) কনসোল আউটপুট (সারাংশ) এবং (২) একটি ফোল্ডার
(প্রসেসের নাম + PID দিয়ে) যেখানে সন্দেহজনক/ডাম্প করা মডিউল সেভ থাকে।

**কনসোল আউটপুটের মূল অংশ:**
```
[*] PID: 1234, using EXE: game.exe
[*] Scanning...
Total scanned:        45
Skipped:               0
---
Hooked:                0
Replaced:              0
Hdrs Modified:         0
IAT Hooked:             0
Implanted:              1
Implanted PE:            1
Implanted shc:           0
Unreachable files:      0
Other:                   0
---
Total suspicious:       1
```

**প্রতিটি ফিল্ডের অর্থ:**

| ফিল্ড | অর্থ | কেন সন্দেহজনক |
|---|---|---|
| Total scanned | প্রসেসে কতগুলো মডিউল স্ক্যান হয়েছে | শুধু প্রসঙ্গ, নিজে থেকে সন্দেহজনক না |
| Hooked | কোনো ফাংশনের শুরু বদলে অন্য জায়গায় jump করানো হয়েছে | চিট প্রায়ই গেম ফাংশন হুক করে ডেটা পড়তে/বদলাতে (aimbot, ESP) |
| Replaced | একটা পুরো মডিউল অন্য কোড দিয়ে বদলানো | বৈধ DLL-এর জায়গায় ম্যালিশাস DLL |
| Hdrs Modified | PE header ম্যানুয়ালি পরিবর্তন (ডিটেকশন এড়াতে) | চিট নিজেকে "অদৃশ্য" করতে header নষ্ট করে |
| IAT Hooked | Import Address Table হুক করা (কোন ফাংশন কল হবে তা রিডাইরেক্ট) | খুবই কমন injection/hooking টেকনিক |
| Implanted | ডিস্কের কোনো ফাইলের সাথে ম্যাপ না হওয়া মেমরি রিজিয়ন | Manual-mapped DLL injection-এর ক্লাসিক সিগনেচার — **সবচেয়ে গুরুত্বপূর্ণ ফাইন্ডিং** |
| Implanted PE | Implanted রিজিয়নটা পূর্ণ PE (executable) ফরম্যাটে | ডিস্কে না থাকা একটা সম্পূর্ণ executable/DLL রান হচ্ছে |
| Implanted shc | Shellcode (raw মেশিন কোড, PE ফরম্যাট না) ইমপ্ল্যান্ট করা | আরও স্টেলথি injection টেকনিক |
| Unreachable files | মডিউলের সাথে যুক্ত ডিস্ক ফাইল অ্যাক্সেস করা যাচ্ছে না (ডিলিট হয়ে গেছে) | রানটাইমে ফাইল ডিলিট করে ট্রেস মুছে ফেলার প্যাটার্ন |

> সবচেয়ে গুরুত্বপূর্ণ লাইন: `Total suspicious: 1` — মান **0** স্বাভাবিক, কোনো
> চিট পাওয়া যায়নি। **1 বা তার বেশি** মানে সেই প্রসেসে ইনজেক্টেড/হুকড/মডিফাইড
> কিছু পাওয়া গেছে — এটাই মূল ইন্ডিকেটর।

**সিদ্ধান্ত নেওয়ার সহজ নিয়ম:**

| ফলাফল | অর্থ |
|---|---|
| `Total suspicious: 0` | ক্লিন — এই মুহূর্তে কোনো ইনজেকশন পাওয়া যায়নি |
| `Implanted PE: 1+` | সবচেয়ে শক্তিশালী প্রমাণ — RAM-এ সরাসরি একটি অচেনা executable চলছে, চিট হওয়ার সম্ভাবনা বেশি |
| `Hooked`/`IAT Hooked` বেশি | ফাংশন হুকিং হয়েছে — গেম লজিকে হস্তক্ষেপ (ওভারলে/ESP/aimbot-টাইপ হতে পারে) |
| `Unreachable files` | রানটাইমে ব্যবহৃত ও পরে ডিলিট করা ফাইল — এভিডেন্স ক্লিনআপের প্যাটার্ন |

**⚠️ সীমাবদ্ধতা মনে রাখুন**

- PE-sieve শুধু স্ক্যানের সেই মুহূর্তে চলা প্রসেসেই কাজ করে — চিট স্ক্যানের আগেই
  বন্ধ/আনলোড হয়ে গেলে কিছুই পাওয়া যাবে না।
- কিছু বৈধ অ্যান্টি-চিট/ওভারলে সফটওয়্যারও (Discord overlay, RTSS, streaming
  software) hooking ব্যবহার করে — তাই `Total suspicious: 1` মানেই সরাসরি
  "চিট" ধরে নেওয়া ঠিক না; ডাম্প করা ফাইলটা বিশ্লেষণ করে নিশ্চিত করতে হবে।
- গেম প্রসেস চলা অবস্থায় (ম্যাচ চলাকালীন) স্ক্যান করলেই এটা সবচেয়ে কার্যকর —
  গেম বন্ধ হয়ে যাওয়ার পর স্ক্যান করলে কিছুই পাওয়া যাবে না।

---
[← Chapter 3](03-jumplists-and-ez-tools.md) · [পরবর্তী: Chapter 5 — Final Additions →](05-final-additions.md)
