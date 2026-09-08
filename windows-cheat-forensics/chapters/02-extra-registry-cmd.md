[← README](../README.md)

# Chapter 2 — আরও রেজিস্ট্রি লোকেশন ও CMD/PowerShell (Extra, Part 2)

এটাও সম্পূর্ণ বিল্ট-ইন Windows টুলস দিয়েই করা যায়।

## ২.১ আরও রেজিস্ট্রি লোকেশন

### BAM/DAM (Background Activity Moderator) — কোন প্রোগ্রাম কখন রান হয়েছে, খুবই নির্ভরযোগ্য

```
HKLM\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\<SID>
```

Prefetch-এর মতোই, কিন্তু এখানে সঠিক তারিখ/সময়সহ পুরো পাথ থাকে, এবং প্রোগ্রাম
ডিলিট হয়ে গেলেও এন্ট্রি থেকে যায়। অ্যান্টি-চিট ফরেনসিকের জন্য অত্যন্ত শক্তিশালী।

### Shellbags (কোন ফোল্ডার ব্রাউজ করা হয়েছিল তার হিস্ট্রি)

```
HKCU\Software\Microsoft\Windows\Shell\BagMRU
HKCU\Software\Microsoft\Windows\Shell\Bags
```

ফোল্ডার ডিলিট হয়ে গেলেও কেউ সেখানে গিয়েছিল তার প্রমাণ এখানে থেকে যায়।

### Windows Firewall exceptions (চিট প্রসেসকে ইন্টারনেট এক্সেস দেওয়া হয়েছিল কিনা)

```
HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules
```

### ইনস্টলড প্রোগ্রাম লিস্ট (রেজিস্ট্রি ভার্সন, GUI-র চেয়ে দ্রুত)

```
HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall
HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall
```

## ২.২ আরও CMD/PowerShell কমান্ড

**Startup ফোল্ডার চেক (সরাসরি ফোল্ডার, রেজিস্ট্রি নয়):**
```
explorer shell:startup
explorer shell:common startup
```

**Hosts ফাইল চেক (চিট টুল কখনো অ্যান্টি-চিট সার্ভার ব্লক করার জন্য এটা এডিট করে):**
```
notepad C:\Windows\System32\drivers\etc\hosts
```
কোনো অ্যান্টি-চিট/গেম সার্ভার ডোমেইন ব্লক করা আছে কিনা দেখুন (যেমন
`0.0.0.0 vanguard.riotgames.com` ধরনের লাইন সন্দেহজনক)।

**ড্রাইভার লিস্ট (kernel-level চিট ড্রাইভার ধরার জন্য):**
```
driverquery /v /fo LIST
```
অচেনা/আনসাইনড ড্রাইভার নাম খুঁজুন, বিশেষ করে সম্প্রতি ইনস্টল হওয়া গুলো।

**পুরো ইনস্টলড প্রোগ্রাম লিস্ট (GUI ছাড়া):**
```
wmic product get name,installdate
```

**Recycle Bin চেক (CMD দিয়ে):**
```
dir C:\$Recycle.Bin /a /s
```

**PowerShell কমান্ড হিস্ট্রি:**
```
type %appdata%\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt
```
খুবই গুরুত্বপূর্ণ — ইউজার PowerShell-এ যা টাইপ করেছে তার সব সেভ থাকে, যতক্ষণ না
ম্যানুয়ালি ক্লিয়ার করা হয়।

**WMI persistence চেক (চিট/ম্যালওয়্যারের অ্যাডভান্সড টেকনিক):**
```
wmic /namespace:\\root\subscription PATH __EventFilter get Name
wmic /namespace:\\root\subscription PATH CommandLineEventConsumer get Name,CommandLineTemplate
```
সাধারণ ইউজারের PC-তে এটা খালি থাকার কথা — এখানে কিছু পাওয়া গেলে সেটা গভীরভাবে
সন্দেহজনক।

**প্রসেসে ম্যাপ করা ওপেন নেটওয়ার্ক পোর্ট:**
```
netstat -ano | findstr LISTENING
```

**ARP cache:**
```
arp -a
```

**টাইমস্ট্যাম্প ম্যানিপুলেশন ধরার জন্য ক্লক/টাইমজোন চেক:**
```
w32tm /query /status
```

## ২.৩ আরও ম্যানুয়াল চেক

### Amcache ফাইল (প্রোগ্রাম রান হিস্ট্রি, ফরেনসিকালি স্ট্রং)

```
C:\Windows\AppCompat\Programs\Amcache.hve
```

সরাসরি Notepad-এ পড়া যায় না (বাইনারি ফাইল), কিন্তু ফাইলটির অস্তিত্ব/মডিফিকেশন
তারিখ থেকেই বোঝা যায় কিছু ইনস্টল বা রান হয়েছে। পূর্ণ বিশ্লেষণের জন্য একটি পার্সার
লাগবে (দেখুন Chapter 3)।

### Windows optional features

Control Panel → Programs → Turn Windows features on or off

Windows Sandbox বা WSL-এর মতো কোনো অস্বাভাবিক ফিচার চালু আছে কিনা দেখুন — এগুলো
ব্যবহার করে চিট আইসোলেশনে রান করে ডিটেকশন এড়ানো যায়।

### Group Policy স্ক্রিপ্ট (লগইন/লগআউটে কি অটো-রান কোনো স্ক্রিপ্ট আছে?)

```
gpedit.msc
```
Computer Configuration → Windows Settings → Scripts (Startup/Shutdown)

### RDP/Remote access লগ

```
eventvwr.msc → Applications and Services Logs → Microsoft → Windows →
TerminalServices-RemoteConnectionManager → Operational
```

## ২.৪ ⚡ Updated Quick Priority List (Combined)

- [ ] Registry Run keys + BAM/DAM
- [ ] Defender Exclusions (Path + Process)
- [ ] `fsutil usn readjournal` — ডিলিট হওয়া ফাইল হিস্ট্রি
- [ ] `dir C:\Windows\Prefetch` — রান হিস্ট্রি
- [ ] Amcache.hve অস্তিত্ব/তারিখ চেক
- [ ] `schtasks /query` + WMI event subscription চেক
- [ ] `tasklist /v` + `driverquery /v`
- [ ] PowerShell হিস্ট্রি ফাইল
- [ ] Hosts ফাইল চেক
- [ ] গেম প্রসেসের DLL চেক
- [ ] ব্রাউজার হিস্ট্রি/ডাউনলোড
- [ ] AppData/Temp/Recycle Bin ম্যানুয়াল স্ক্যান

> এতক্ষণে এটা প্রায় একটি প্রফেশনাল-লেভেল ম্যানুয়াল ফরেনসিক চেকলিস্ট — এরপর আর
> খুব বেশি কিছু লাগার কথা না, শুধু নিয়মিত প্র্যাকটিস দরকার।

---
[← Chapter 1](01-core-manual-checks.md) · [পরবর্তী: Chapter 3 — Jump Lists ও EZ Tools →](03-jumplists-and-ez-tools.md)
