[← README](../README.md)

# Chapter 1 — Full Manual PC Cheat-Check Guide (কোনো এক্সট্রা টুল লাগবে না)

শুধুমাত্র Windows-এ বিল্ট-ইন থাকা ফিচার দিয়েই এই পুরো চ্যাপ্টার সম্পন্ন করা যায়।

## ১.১ রেজিস্ট্রি (Win+R → regedit)

### Autostart / Persistence চেক

```
HKCU\Software\Microsoft\Windows\CurrentVersion\Run
HKLM\Software\Microsoft\Windows\CurrentVersion\Run
HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Run
HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce
```

এখানে অচেনা বা র‍্যান্ডম নামের কোনো `.exe` থাকলে সেটা রেড ফ্ল্যাগ — চিট লোডাররা
প্রায়ই এখানে এন্ট্রি যোগ করে যাতে বুট হওয়ার সাথে সাথে নিজে থেকেই চালু হয়।

### সম্প্রতি খোলা ফাইল (MRU)

```
HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RecentDocs
HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\ComDlg32\OpenSavePidlMRU
```

### প্রোগ্রাম রান হওয়ার হিস্ট্রি (UserAssist) — খুবই গুরুত্বপূর্ণ

```
HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\UserAssist
```

এই key টি ROT13-এনকোডেড, কিন্তু একটি ফরেনসিক ডিকোডার টুল দিয়ে দেখা যায় কোন
`.exe` কখন এবং কতবার রান হয়েছে। চিট ফাইল পরে ডিলিট করে ফেললেও এই ট্রেস থেকে যায়।

### Shimcache / AppCompatCache (ডিলিট হওয়ার পরেও টিকে থাকে)

```
HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\AppCompatCache
```

### Windows Defender Exclusions (একটি কমন চিট-হাইডিং ট্রিক)

```
HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Paths
HKLM\SOFTWARE\Microsoft\Windows Defender\Exclusions\Processes
```

কেউ যদি নিজের চিট ফোল্ডার/প্রসেস এখানে যোগ করে Defender থেকে বাঁচার চেষ্টা করে,
সেটা ১০০% সন্দেহজনক।

### USB / ডিভাইস হিস্ট্রি

```
HKLM\SYSTEM\CurrentControlSet\Enum\USBSTOR
```

হার্ডওয়্যার চিট ডিভাইস (Cronus, প্রোগ্রামেবল মাউস ইত্যাদি) কখনো কানেক্ট করা
হয়েছিল কিনা যাচাই করুন।

## ১.২ USN Journal (ডিলিট হওয়া ফাইলের হিস্ট্রি)

ফাইল ডিলিট হয়ে গেলেও ট্রেস থেকে যায়। Admin CMD-তে রান করুন:

```
fsutil usn queryjournal C:
```

Journal এনাবল আছে কিনা চেক করে। পুরো readable journal ডাম্প করতে:

```
fsutil usn readjournal C: csv > journal_dump.csv
```

এই CSV ফাইলটি Excel-এ খুলে "loader", "inject", `.dll` ইত্যাদি নাম সার্চ করলে
কোন ফাইল কখন তৈরি ও ডিলিট হয়েছিল তা স্পষ্ট দেখা যাবে — এমনকি ফাইলটি এখন আর না
থাকলেও।

## ১.৩ CMD কমান্ড (কোনো টুল ছাড়াই)

**রানিং প্রসেস + পাথ:**
```
tasklist /v
wmic process get name,executablepath,processid,parentprocessid
```
Parent প্রসেস চেক করার জন্য সবচেয়ে ভালো — গেম যদি অচেনা লঞ্চার থেকে স্পন হয়ে
থাকে, এখানে সেটা ধরা পড়বে।

**নেটওয়ার্ক কানেকশন (চিট টুল কি বাইরের সার্ভারে কানেক্ট করছে?):**
```
netstat -anob
```
`-b` ফ্ল্যাগ দেখায় কোন প্রসেস কোন কানেকশন খুলেছে।

**শিডিউলড টাস্ক লিস্ট (persistence চেক):**
```
schtasks /query /fo LIST /v
```
চিট লোডাররা প্রায়ই রিস্টার্টের পর নিজেকে আবার চালু করতে একটি scheduled task
তৈরি করে।

**সার্ভিস লিস্ট:**
```
sc query type= service state= all
```

**নির্দিষ্ট প্রসেসের লোড হওয়া DLL:**
```
tasklist /m /fi "imagename eq <game.exe>"
```
গেম প্রসেসের সাথে অচেনা বা র‍্যান্ডম নামের DLL থাকলে সেটা সন্দেহজনক।

**সম্প্রতি মডিফাই/ক্রিয়েট হওয়া ফাইল (শেষ কয়েকদিন):**
```
forfiles /P C:\Users\<username>\AppData\Local /S /D -3 /C "cmd /c echo @path @fdate @ftime"
```

**Prefetch ফাইল চেক (GUI ছাড়াই প্রোগ্রাম রান হিস্ট্রি):**
```
dir C:\Windows\Prefetch
```
প্রোগ্রাম রান হলে Windows অপটিমাইজেশনের জন্য একটি `.pf` ফাইল তৈরি করে।
প্রোগ্রামটি ডিলিট হয়ে গেলেও তার নাম Prefetch-এ থেকে যায় — এটা খুবই নির্ভরযোগ্য
প্রমাণ যে প্রোগ্রামটি অন্তত একবার রান হয়েছিল।

**Alternate Data Streams চেক (একটি ফাইলের ভেতরে আরেকটা ফাইল লুকানো কিনা):**
```
dir /r
```

## ১.৪ ম্যানুয়াল ফোল্ডার চেক

```
C:\Windows\Temp
C:\Users\<user>\AppData\Local\Temp
C:\Users\<user>\AppData\Roaming
C:\Windows\Prefetch
C:\Windows\System32\Tasks
C:\ProgramData
```

র‍্যান্ডম নামের ফোল্ডার (যেমন `7ZS08F988D8`-স্টাইল), অথবা গেম-সম্পর্কহীন
`.exe`/`.dll` এখানে আছে কিনা দেখুন।

**হিডেন ফাইল দেখতে:** File Explorer → View → Show → Hidden items ON করুন, এবং
Folder Options-এ "Hide protected operating system files" OFF করুন — নাহলে অনেক
ফাইল লুকানো থেকে যাবে।

## ১.৫ Event Viewer ম্যানুয়াল চেক (Sysmon ছাড়াই)

```
eventvwr.msc
```

Event ID 4688, 7045, 1116, 4104, 106 ইত্যাদি দিয়ে ফিল্টার করে GUI থেকেই চেক করা
যায় — আলাদা কোনো টুল লাগে না।

## ১.৬ ব্রাউজার হিস্ট্রি (ম্যানুয়াল)

```
chrome://history
edge://history
brave://history
```

"undetected cheat", "bypass anticheat" ইত্যাদি সার্চ সরাসরি এখানে দেখা যাবে।
ডাউনলোড হিস্ট্রিও চেক করুন: `chrome://downloads`

## ১.৭ Quick Priority Checklist (Discord পিন করার মতো)

- [ ] Registry Run keys চেক
- [ ] Defender Exclusions চেক (Path + Process)
- [ ] `fsutil usn readjournal` — ডিলিট হওয়া ফাইল হিস্ট্রি
- [ ] `dir C:\Windows\Prefetch` — রান হিস্ট্রি
- [ ] `schtasks /query` — scheduled task চেক
- [ ] `tasklist /v` — রানিং প্রসেস + পাথ
- [ ] গেম প্রসেসের লোডেড DLL চেক
- [ ] ম্যানুয়াল ব্রাউজার হিস্ট্রি/ডাউনলোড চেক
- [ ] ম্যানুয়াল AppData/Temp ফোল্ডার স্ক্যান

> এই লিস্টটা অনুসরণ করলেই মোটামুটি একটা সম্পূর্ণ ম্যানুয়াল ফরেনসিক চেক হয়ে
> যায় — কোনো টুল ডাউনলোড করার দরকার নেই, সবকিছু Windows-এর নিজস্ব বিল্ট-ইন
> ফিচার দিয়েই চলে।

---
[পরবর্তী: Chapter 2 — Extra Registry & CMD →](02-extra-registry-cmd.md)
