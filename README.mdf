# Courses

Windows ফরেনসিক্স, DFIR, এবং esports অ্যান্টি-চিট ইনভেস্টিগেশন নিয়ে হ্যান্ডস-অন,
বাংলা ভাষায় লেখা কোর্সের একটি কালেকশন।

> ⚠️ **শুধুমাত্র নিজের মালিকানাধীন সিস্টেম বা ল্যাব VM-এ প্র্যাকটিস করুন।**
> এখানে দেওয়া কোনো চেক বা টুলই চূড়ান্ত রায় দেয় না — প্রতিটি ফলাফল মানুষ
> সিদ্ধান্তগ্রহণকারীকে সহায়তা করার জন্য।

## 📚 কোর্স লিস্ট

| কোর্স | বিষয় | লিংক |
|---|---|---|
| **PC Cheat-Check & Forensic Investigation Field Manual** | Esports অ্যান্টি-চিট অফিশিয়ালদের জন্য — বিল্ট-ইন Windows চেক থেকে শুরু করে Eric Zimmerman টুলস, kernel-level ড্রাইভার ফরেনসিক্স, PE-sieve মেমরি স্ক্যান, ও স্ক্রিনশট অ্যানালাইসিস SOP পর্যন্ত | [`windows-cheat-forensics/`](windows-cheat-forensics) |
| **Windows Temp Forensics & File Recovery** | `%TEMP%` ফোল্ডার থেকে ডেটা কালেকশন, ডিলিটেড ফাইল রিকভারি, ও ট্রায়াজ/ভেরিফিকেশন — ফরেনসিক ইনভেস্টিগেশন, ইনসিডেন্ট রেসপন্স, ও অ্যান্টি-চিট/ম্যালওয়্যার দৃষ্টিকোণ থেকে | [`windows-temp-forensics/`](windows-temp-forensics) |

## 🗂️ রিপোজিটরি স্ট্রাকচার

```
courses/
├── windows-cheat-forensics/     PC চিট-চেক ও ফরেনসিক ম্যানুয়াল
│   ├── README.md
│   ├── chapters/                8টি চ্যাপ্টার (Registry → EZ Tools → Kernel/ETW → SOP → Reference Tools)
│   └── scripts/                 Check-UnsignedDLLs.ps1
│
└── windows-temp-forensics/      Temp ফোল্ডার ফরেনসিক্স ও রিকভারি
    ├── README.md
    ├── lab-setup.md
    ├── chapters/                9টি চ্যাপ্টার
    ├── labs/                    ৩টি হ্যান্ডস-অন ল্যাব এক্সারসাইজ
    └── scripts/                 কালেকশন/রিকভারি/ট্রায়াজ PowerShell স্ক্রিপ্ট
```

প্রতিটি কোর্সের নিজস্ব `README.md`-তে বিস্তারিত চ্যাপ্টার লিস্ট, রিকোয়ারমেন্ট, ও
ব্যবহারের নির্দেশনা আছে।

## 👤 কাদের জন্য

- Esports টুর্নামেন্ট অ্যান্টি-চিট অফিশিয়াল/অ্যাডমিন
- DFIR (Digital Forensics & Incident Response) শিখতে আগ্রহী শিক্ষার্থী
- SOC/Blue Team মেম্বার যারা এন্ডপয়েন্ট আর্টিফ্যাক্ট বুঝতে চান
- সিস্টেম অ্যাডমিন যারা ডিলিট হওয়া ফাইল রিকভার করতে চান বা প্রোগ্রাম রান হিস্ট্রি
  খুঁজে বের করতে চান

## 🧭 সাধারণ মূলনীতি (দুই কোর্সেই প্রযোজ্য)

- **শুধুমাত্র বৈধ, পাবলিকলি ডকুমেন্টেড টুলস** ব্যবহৃত হয়েছে (Sysinternals, EZ
  Tools, Volatility, NirSoft, Windows-এর নিজস্ব বিল্ট-ইন ইউটিলিটি)।
- **কোনো টুলই চূড়ান্ত রায় নয়** — প্রতিটি চেক প্রমাণ তৈরি করে; চূড়ান্ত সিদ্ধান্ত
  সবসময় মানুষের।
- **Order of operations গুরুত্বপূর্ণ** — volatile evidence (running process,
  memory, network) সবসময় কম volatile evidence (registry, files, logs)-এর
  আগে সংগ্রহ করুন।
- **সবকিছু ডকুমেন্ট করুন** — প্রতিটি কমান্ডের আউটপুট স্ক্রিনশট/লগ করুন।

## ⚙️ সাধারণ প্রয়োজনীয়তা

- Windows 10/11 (Administrator অ্যাক্সেসসহ, কিছু কমান্ডের জন্য প্রয়োজন)
- PowerShell 5.1+
- ঐচ্ছিক টুলস: [Eric Zimmerman's EZ Tools](https://ericzimmerman.github.io/#!index.md), [Sysinternals Suite](https://learn.microsoft.com/en-us/sysinternals/), [NirSoft Utilities](https://www.nirsoft.net/)

## 📄 লাইসেন্স

শিক্ষামূলক উদ্দেশ্যে ব্যবহারের জন্য মুক্ত (MIT) — প্রতিটি সাব-ফোল্ডারের নিজস্ব
`LICENSE` ফাইল দেখুন।

## ✍️ Author

**Tasfik Abdullah**
