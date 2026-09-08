[← README](../README.md)

# Chapter 8 — Reference Tools (বৈধ ফরেনসিক ও সিসঅ্যাডমিন টুলস)

এই ম্যানুয়ালের আগের চ্যাপ্টারগুলোতে যেসব টুলের কথা বলা হয়েছে, তাদের অফিসিয়াল
ডাউনলোড/সোর্স লিংক এখানে এক জায়গায় দেওয়া হলো — সুবিধার জন্য। সবগুলোই পাবলিকলি
ডকুমেন্টেড, বৈধ, ইন্ডাস্ট্রি-স্ট্যান্ডার্ড টুল।

> ⚠️ সবসময় **শুধুমাত্র নিচের অফিসিয়াল লিংক** থেকেই ডাউনলোড করুন। কোনো Discord
> সার্ভার, র‍্যান্ডম ফাইল-শেয়ারিং সাইট, বা "cracked"/"modded" ভার্সন থেকে এই
> টুলগুলোর কোনো এক্সিকিউটেবল নামাবেন না — ফরেনসিক টুলের নামে চালিয়ে দেওয়া
> ম্যালওয়্যার/লোডার এই ধরনের চ্যানেলে সাধারণ ব্যাপার।

## মেমরি / প্রসেস স্ক্যানিং

| টুল | কাজ | সোর্স |
|---|---|---|
| **PE-sieve** | রানিং প্রসেস স্ক্যান করে ইনজেক্টেড/রিপ্লেসড PE, শেলকোড, হুক শনাক্ত করে (দেখুন Chapter 4.3) | https://github.com/hasherezade/pe-sieve |
| **Process Hacker** | অ্যাডভান্সড টাস্ক ম্যানেজার — প্রসেস, হ্যান্ডেল, মেমরি রিজিয়ন দেখা যায় | https://processhacker.sourceforge.io/ |
| **Volatility 3** | মেমরি ডাম্প (RAM) ফরেনসিক অ্যানালাইসিস ফ্রেমওয়ার্ক | https://github.com/volatilityfoundation/volatility3 |

## Sysinternals Suite (Microsoft, অফিসিয়াল)

| টুল | কাজ | সোর্স |
|---|---|---|
| **Autoruns** | Registry + Startup + Scheduled Tasks + Drivers + Services — সবকিছু এক জায়গায় (দেখুন Chapter 5.5) | https://download.sysinternals.com/files/Autoruns.zip |
| **Process Explorer** | কোন প্রসেস কোন ফাইল/রেজিস্ট্রি key/DLL ওপেন রেখেছে তা বিস্তারিত দেখায় | https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer |
| **Process Monitor (Procmon)** | রিয়েল-টাইমে ফাইল সিস্টেম, রেজিস্ট্রি, প্রসেস/থ্রেড অ্যাক্টিভিটি মনিটর করে | https://learn.microsoft.com/en-us/sysinternals/downloads/procmon |
| **Sysmon** | Windows event log-এ গভীর সিস্টেম অ্যাক্টিভিটি লগ করে (দেখুন Chapter 4.1 §5) | https://learn.microsoft.com/en-us/sysinternals/downloads/sysmon |
| **Sigcheck** | ফাইল/ড্রাইভারের ডিজিটাল সিগনেচার ভেরিফাই করে (দেখুন Chapter 4.1) | https://learn.microsoft.com/en-us/sysinternals/downloads/sigcheck |

## Registry ও ফাইল আর্টিফ্যাক্ট ভিউয়ার (NirSoft)

| টুল | কাজ | সোর্স |
|---|---|---|
| **PrefetchView** | Windows Prefetch (.pf) ফাইলের কন্টেন্ট GUI-তে দেখায় | https://www.nirsoft.net/utils/win_prefetch_view.html |
| **ShellBagsView** | Shellbags থেকে ব্রাউজ করা ফোল্ডারের হিস্ট্রি দেখায় | https://www.nirsoft.net/utils/shell_bags_view.html |
| **BrowsingHistoryView** | Chrome/Firefox/Edge-এর ডাউনলোড হিস্ট্রি দেখায়, হ্যাশসহ CSV এক্সপোর্ট করে | https://www.nirsoft.net/utils/web_browser_downloads_view.html |
| **RecentFilesView** | সম্প্রতি খোলা ফাইলের হিস্ট্রি দেখায় | https://www.nirsoft.net/utils/recent_files_view.html |
| **LastActivityView** | সিস্টেমের সাম্প্রতিক সব অ্যাক্টিভিটির টাইমলাইন দেখায় | https://www.nirsoft.net/utils/computer_activity_view.html |
| **JumpListExplorer** | Windows Jump List ভিউ ও রিমুভ করার টুল | https://github.com/smourier/JumpListExplorer |

## Kernel Debugging / অ্যাডভান্সড

| টুল | কাজ | সোর্স |
|---|---|---|
| **WinDbg** | Windows kernel/user-mode ডিবাগার — ETW ট্রেস ও ক্র্যাশ ডাম্প অ্যানালাইসিসে ব্যবহৃত (দেখুন Chapter 4.2) | https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/ |
| **Windows ADK** | WinDbg-সহ Windows অ্যাসেসমেন্ট ও ডিপ্লয়মেন্ট টুলকিট | https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install |

## Eric Zimmerman's Tools (EZ Tools)

সব EZ Tools একসাথে — Chapter 3.9-এ বিস্তারিত ব্যবহার দেওয়া আছে।

```
https://ericzimmerman.github.io/#!index.md
```

---
[← Chapter 7](07-appendix-script-guide.md) · [README-এ ফিরে যান →](../README.md)
