[← README](../README.md)

# Chapter 5 — Last Additions (Part 4)

*মিশ্র ম্যানুয়াল/GUI।*

## ৫.১ অ্যান্টি-চিট সফটওয়্যারের নিজস্ব লগ (গেম-স্পেসিফিক)

অনেক গেমের নিজস্ব অ্যান্টি-চিট সিস্টেম (EasyAntiCheat, BattlEye, Vanguard)
লোকাল লগ রাখে:

```
C:\Program Files\EasyAntiCheat\
C:\ProgramData\EasyAntiCheat\
C:\Program Files (x86)\Steam\logs\
```

গেমের অফিসিয়াল অ্যান্টি-চিট লগে প্রায়ই নিজের flag/kick হওয়ার কারণ রেকর্ড থাকে,
যা সরাসরি চেক করা যায়।

## ৫.২ Bluetooth/HID ডিভাইস পেয়ারিং হিস্ট্রি (Cronus-এর মতো হার্ডওয়্যার চিট ডিভাইস)

```
HKLM\SYSTEM\CurrentControlSet\Enum\HID
HKLM\SYSTEM\CurrentControlSet\Enum\BTHENUM
```

কোনো অচেনা HID ডিভাইস (যেমন Cronus Zen, XIM) কখনো কানেক্ট হয়েছিল কিনা চেক করুন।

## ৫.৩ GPU Overlay Tools চেক (ওভারলে-বেজড চিট)

Task Manager → Details → RTSS.exe, MSI Afterburner, বা অচেনা কোনো overlay
প্রসেস আছে কিনা দেখুন।

ESP/wallhack স্ক্রিন ওভারলে দিয়ে রেন্ডার করা চিট প্রায়ই একটি বৈধ ওভারলে টুলের
নামের (যেমন RTSS) আড়ালে নিজেকে লুকায়।

## ৫.৪ Windows Sandbox / Virtual Machine চেক

Control Panel → Programs → Turn Windows features on or off

কেউ Windows Sandbox/VM-এর ভেতরে চিট রান করে মূল সিস্টেমে ট্রেস না রাখার চেষ্টা
করছে কিনা যাচাই করতে ব্যবহৃত হয়।

## ৫.৫ Autoruns (Sysinternals — টেকনিক্যালি একটি টুল, কিন্তু পোর্টেবল, ইনস্টল লাগে না)

এটা টেকনিক্যালি "no tool" লিস্টের বাইরে, কিন্তু উল্লেখ করার মতো: `Autoruns.exe`
(Microsoft-এর নিজস্ব Sysinternals Suite) রান করলে Registry + Startup +
Scheduled Tasks + Drivers + Services — **সবকিছু এক জায়গায়** দেখায়, যা এতক্ষণ
আলাদা আলাদা করে ম্যানুয়ালি করা সবকিছুকে একসাথে করে দেয়। এটা পিওর "no tool"
লিস্টের বাইরে পড়ে, কিন্তু বাদ দিলে এই ম্যানুয়াল অসম্পূর্ণ থেকে যেত।

---
[← Chapter 4](04-kernel-driver-and-etw.md) · [পরবর্তী: Chapter 6 — Screenshot Analyst SOP →](06-screenshot-analyst-sop.md)
