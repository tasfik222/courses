# Windows Executables (.exe) — A Beginner-to-Intermediate Course

> A practical guide to understanding what the most important `.exe` files in Windows actually do — why they exist, whether they're safe, and where to find them.

---

## ⚠️ একটা গুরুত্বপূর্ণ কারেকশন (Important Correction)

একটা ফ্রেশ Windows ইন্সটলে **৫০ হাজারের ওপরে .exe ফাইল থাকে না**। একটা টিপিক্যাল Windows 10/11 সিস্টেমে সাধারণত **কয়েকশ থেকে ১-২ হাজারের মধ্যে** `.exe` ফাইল থাকে (`C:\Windows\System32`, `C:\Windows`, ইনস্টল করা প্রোগ্রামসহ সব মিলিয়ে)। এত বড় সংখ্যা আসতে পারে যদি:
- আপনি অনেকগুলো থার্ড-পার্টি সফটওয়্যার, গেম, ড্রাইভার ইনস্টল করে রাখেন
- `WinSxS` ফোল্ডারের ভেতরের সব কপি/ভ্যারিয়েন্ট গোনা হয় (একই ফাইলের অনেক ভার্সন থাকে সেখানে)

তাই প্রতিটা exe এর জন্য আলাদা এন্ট্রি লেখা বাস্তবসম্মত না এবং কোর্স হিসেবে অকার্যকরও হবে। এর বদলে, এই কোর্সে **সবচেয়ে গুরুত্বপূর্ণ ও কমনলি-সিন exe ফাইলগুলো** ক্যাটাগরি অনুযায়ী সাজানো হয়েছে, যাতে যে কেউ শিখতে পারে একটা exe দেখলে সেটা কী কাজ করে বোঝা যায়।

---

## Table of Contents
1. [How to Learn Any Unknown .exe Yourself](#1-how-to-learn-any-unknown-exe-yourself)
2. [Core System Processes](#2-core-system-processes)
3. [Built-in Windows Tools & Utilities](#3-built-in-windows-tools--utilities)
4. [Command-Line & Networking Tools](#4-command-line--networking-tools)
5. [Control Panel / Management Consoles](#5-control-panel--management-consoles)
6. [Background/Service Helper Processes](#6-backgroundservice-helper-processes)
7. [Red Flags — When an .exe Might Be Malware](#7-red-flags--when-an-exe-might-be-malware)
8. [Quick Reference Table](#8-quick-reference-table)

---

## 1. How to Learn Any Unknown .exe Yourself

এই কোর্স সব exe কাভার করবে না — তাই একটা নিজে-শেখার মেথড থাকা দরকার:

1. **Task Manager → Details tab** এ রাইট-ক্লিক করে "Open file location" দেখুন — কোথা থেকে চলছে সেটা গুরুত্বপূর্ণ ক্লু।
2. **Properties → Digital Signatures tab** চেক করুন — Microsoft-signed কিনা।
3. `C:\Windows\System32` এর ভেতরের exe সাধারণত সিস্টেম ফাইল; `C:\Users\...\AppData` এর ভেতরে থাকা exe প্রায়ই থার্ড-পার্টি অ্যাপ বা কখনো ম্যালওয়্যার।
4. অনলাইনে ফাইলের নাম সার্চ করে অফিসিয়াল ডকুমেন্টেশন (Microsoft Learn) মিলিয়ে দেখুন।
5. সন্দেহ হলে VirusTotal-এ hash আপলোড করে চেক করা যায়।

---

## 2. Core System Processes

এগুলো Windows চালু হওয়ার সাথে সাথে অটোমেটিক্যালি রান হয় — বন্ধ করা বা ছাড়া উচিত না।

| Exe | কাজ |
|---|---|
| `explorer.exe` | Desktop, Taskbar, File Explorer — পুরো গ্রাফিক্যাল শেল এটাই চালায় |
| `svchost.exe` | Service Host — অনেক Windows সার্ভিস একসাথে এই প্রসেসের মধ্যে গ্রুপ হয়ে চলে (DLL হিসেবে) |
| `csrss.exe` | Client/Server Runtime — উইন্ডো ম্যানেজমেন্ট ও কনসোল সাপোর্টের জন্য ক্রিটিক্যাল |
| `wininit.exe` | সিস্টেম স্টার্টআপে অন্যান্য কোর প্রসেস ইনিশিয়ালাইজ করে |
| `winlogon.exe` | লগইন স্ক্রিন, ইউজার সেশন হ্যান্ডেল করে |
| `services.exe` | Service Control Manager — সব Windows সার্ভিস স্টার্ট/স্টপ ম্যানেজ করে |
| `lsass.exe` | Local Security Authority — লগইন পাসওয়ার্ড, সিকিউরিটি পলিসি চেক করে |
| `smss.exe` | Session Manager — নতুন ইউজার সেশন তৈরি করে |
| `dwm.exe` | Desktop Window Manager — উইন্ডোর ট্রান্সপারেন্সি, অ্যানিমেশন রেন্ডার করে |
| `taskhostw.exe` | DLL-based ব্যাকগ্রাউন্ড টাস্ক হোস্ট করে |
| `fontdrvhost.exe` | ফন্ট রেন্ডারিং সাপোর্ট |
| `sihost.exe` | Shell Infrastructure Host — Start menu, Action Center চালাতে সাহায্য করে |
| `RuntimeBroker.exe` | Universal Windows Platform (UWP) অ্যাপের পারমিশন ম্যানেজ করে |
| `dllhost.exe` | COM/ActiveX অবজেক্টের জন্য আলাদা প্রসেস হোস্ট করে |
| `conhost.exe` | Command Prompt/PowerShell এর জন্য কনসোল উইন্ডো হ্যান্ডেল করে |
| `spoolsv.exe` | Print Spooler — প্রিন্ট জব ম্যানেজ করে |
| `ctfmon.exe` | ইনপুট মেথড, টেক্সট সার্ভিস (কিবোর্ড লেআউট, হ্যান্ডরাইটিং) ম্যানেজ করে |

---

## 3. Built-in Windows Tools & Utilities

এগুলো আপনি নিজে হাতে চালাতে পারেন — সবই সেফ, Microsoft-এর নিজস্ব টুল।

| Exe | কাজ |
|---|---|
| `notepad.exe` | সিম্পল টেক্সট এডিটর |
| `wordpad.exe` | বেসিক রিচ-টেক্সট এডিটর |
| `calc.exe` | ক্যালকুলেটর |
| `mspaint.exe` | Paint — বেসিক ইমেজ এডিটিং |
| `snippingtool.exe` | স্ক্রিনশট নেওয়ার টুল |
| `taskmgr.exe` | Task Manager — রানিং প্রসেস, রিসোর্স ইউসেজ দেখা ও বন্ধ করা |
| `regedit.exe` | Registry Editor — সিস্টেম সেটিংস ডাটাবেস এডিট করা (সতর্কতার সাথে ব্যবহার্য) |
| `msconfig.exe` | System Configuration — স্টার্টআপ প্রোগ্রাম, বুট অপশন ম্যানেজ করা |
| `msinfo32.exe` | System Information — হার্ডওয়্যার/সফটওয়্যার ডিটেইল দেখা |
| `dxdiag.exe` | DirectX Diagnostic Tool — গ্রাফিক্স/সাউন্ড হার্ডওয়্যার টেস্ট |
| `resmon.exe` | Resource Monitor — CPU, Memory, Disk, Network বিস্তারিতভাবে দেখা |
| `perfmon.exe` | Performance Monitor — অ্যাডভান্সড পারফরম্যান্স ট্র্যাকিং |
| `cleanmgr.exe` | Disk Cleanup — অপ্রয়োজনীয় ফাইল ডিলিট করা |
| `charmap.exe` | Character Map — স্পেশাল ক্যারেক্টার/সিম্বল খোঁজা |
| `magnify.exe` | Magnifier — স্ক্রিন জুম করার অ্যাক্সেসিবিলিটি টুল |
| `narrator.exe` | Narrator — স্ক্রিন রিডার (দৃষ্টি প্রতিবন্ধী ইউজারদের জন্য) |
| `osk.exe` | On-Screen Keyboard |
| `winver.exe` | Windows-এর ভার্সন/বিল্ড নাম্বার দেখানো |
| `snippingtool.exe` | Screen capture utility |
| `eventvwr.exe` | Event Viewer — সিস্টেম লগ, এরর, ওয়ার্নিং দেখা |

---

## 4. Command-Line & Networking Tools

এগুলো Command Prompt বা PowerShell থেকে চালাতে হয়।

| Exe | কাজ |
|---|---|
| `cmd.exe` | Command Prompt — ক্লাসিক কমান্ড-লাইন ইন্টারপ্রেটার |
| `powershell.exe` | PowerShell — অ্যাডভান্সড স্ক্রিপ্টিং শেল |
| `pwsh.exe` | PowerShell 7+ (নতুন ক্রস-প্ল্যাটফর্ম ভার্সন) |
| `ping.exe` | নেটওয়ার্ক কানেক্টিভিটি টেস্ট করা |
| `ipconfig.exe` | IP অ্যাড্রেস, নেটওয়ার্ক কনফিগারেশন দেখা |
| `tracert.exe` | নেটওয়ার্ক পাথ/হপ ট্রেস করা |
| `nslookup.exe` | DNS রেজোলিউশন চেক করা |
| `netstat.exe` | অ্যাক্টিভ নেটওয়ার্ক কানেকশন লিস্ট করা |
| `tasklist.exe` | রানিং প্রসেসের লিস্ট (কমান্ড-লাইন ভার্সন অফ Task Manager) |
| `taskkill.exe` | নির্দিষ্ট প্রসেস জোর করে বন্ধ করা |
| `sfc.exe` | System File Checker — করাপ্ট সিস্টেম ফাইল রিপেয়ার করা |
| `chkdsk.exe` | ডিস্ক এরর চেক ও ফিক্স করা |

---

## 5. Control Panel / Management Consoles

| Exe | কাজ |
|---|---|
| `control.exe` | Control Panel ওপেন করে |
| `mmc.exe` | Microsoft Management Console — Device Manager, Disk Management ইত্যাদির ফ্রেমওয়ার্ক |
| `services.msc` (mmc দিয়ে চলে) | সব Windows সার্ভিস ম্যানেজ করা |
| `compmgmt.msc` | Computer Management — একসাথে অনেক অ্যাডমিন টুল |
| `devmgmt.msc` | Device Manager — হার্ডওয়্যার, ড্রাইভার ম্যানেজ করা |
| `diskmgmt.msc` | Disk Management — পার্টিশন, ড্রাইভ ম্যানেজ করা |

---

## 6. Background/Service Helper Processes

| Exe | কাজ |
|---|---|
| `SearchIndexer.exe` | ফাইল সার্চের জন্য ইনডেক্স তৈরি করে (Windows Search) |
| `SearchHost.exe` | Windows Search UI-এর ব্যাকএন্ড |
| `WmiPrvSE.exe` | Windows Management Instrumentation — সিস্টেম মনিটরিং/ম্যানেজমেন্ট স্ক্রিপ্টদের ডেটা দেয় |
| `MsMpEng.exe` | Windows Defender-এর মূল অ্যান্টিভাইরাস স্ক্যান ইঞ্জিন |
| `SecurityHealthService.exe` | Windows Security অ্যাপের স্ট্যাটাস মনিটর করে |
| `OneDrive.exe` | OneDrive ক্লাউড সিঙ্ক ক্লায়েন্ট |
| `SearchProtocolHost.exe` | সার্চ ইনডেক্সিং-এর সহায়ক প্রসেস |
| `WUDFHost.exe` | User-mode ড্রাইভার ফ্রেমওয়ার্ক হোস্ট |
| `backgroundTaskHost.exe` | UWP অ্যাপদের ব্যাকগ্রাউন্ড টাস্ক রান করায় |

---

## 7. Red Flags — When an .exe Might Be Malware

একটা exe সন্দেহজনক হতে পারে যদি:
- একই নাম (যেমন `svchost.exe`) কিন্তু `System32` এর বাইরে অন্য কোনো ফোল্ডার থেকে রান হচ্ছে
- Digital signature নেই বা "Unknown Publisher"
- হঠাৎ উচ্চ CPU/নেটওয়ার্ক ব্যবহার করছে অথচ আপনি চিনেন না
- র‍্যান্ডম নাম (যেমন `a8f3k2.exe`) বা স্পেলিং ভুল (`scvhost.exe`, `explorer1.exe`)
- Startup-এ নিজে থেকে যুক্ত হয়েছে (Task Manager → Startup apps চেক করুন)

সন্দেহ হলে Windows Defender দিয়ে ফুল স্ক্যান করুন, অথবা VirusTotal-এ ফাইল/hash আপলোড করে চেক করুন।

---

## 8. Quick Reference Table

| Category | Example Files |
|---|---|
| Core System | explorer.exe, svchost.exe, lsass.exe, dwm.exe |
| User Tools | notepad.exe, calc.exe, taskmgr.exe |
| Admin Tools | regedit.exe, msconfig.exe, eventvwr.exe |
| Command-Line | cmd.exe, powershell.exe, ping.exe |
| Background Services | MsMpEng.exe, SearchIndexer.exe, OneDrive.exe |

---

## Contributing

এই কোর্সে নতুন exe এন্ট্রি যোগ করতে চাইলে একটা Pull Request পাঠান — ফরম্যাট মেনে (নাম | কাজ) টেবিলে যোগ করুন এবং সোর্স/রেফারেন্স উল্লেখ করুন।

## License

Free to use, share, and modify for educational purposes.
