# Windows Temp Forensics & File Recovery: A Practical Course

একটি হ্যান্ডস-অন, ল্যাব-বেজড কোর্স যা শেখায় কীভাবে Windows-এর `%TEMP%` ফোল্ডার থেকে
ডেটা কালেক্ট, ডিলিটেড ফাইল রিকভার, এবং সেই ফাইলগুলো ট্রায়াজ/ভেরিফাই করতে হয় —
ফরেনসিক ইনভেস্টিগেশন, ইনসিডেন্ট রেসপন্স এবং অ্যান্টি-চিট/ম্যালওয়্যার অ্যানালাইসিসের
দৃষ্টিকোণ থেকে।

> ⚠️ **শুধুমাত্র নিজের মালিকানাধীন সিস্টেম বা ল্যাব VM-এ প্র্যাকটিস করুন।**
> অন্যের সিস্টেম/ডেটাতে অনুমতি ছাড়া কোনো টুল বা স্ক্রিপ্ট চালাবেন না।

## 📖 কোর্সের জন্য কাদের

- DFIR (Digital Forensics & Incident Response) শিখতে আগ্রহী শিক্ষার্থী
- SOC/Blue Team মেম্বার যারা এন্ডপয়েন্ট আর্টিফ্যাক্ট বুঝতে চান
- সিস্টেম অ্যাডমিন যারা ডিলিট হওয়া ফাইল রিকভার করতে চান

## 🗂️ কোর্স স্ট্রাকচার

| # | চ্যাপ্টার | ফাইল |
|---|-----------|------|
| 0 | ল্যাব সেটআপ | [lab-setup.md](lab-setup.md) |
| 1 | Temp Folder পরিচিতি | [chapters/01-temp-basics.md](chapters/01-temp-basics.md) |
| 2 | লাইভ ডেটা কালেকশন | [chapters/02-live-collection.md](chapters/02-live-collection.md) |
| 3 | ডিলিট ও রিকভারি থিওরি | [chapters/03-delete-and-recovery-theory.md](chapters/03-delete-and-recovery-theory.md) |
| 4 | winfr দিয়ে রিকভারি | [chapters/04-winfr-temp-recovery.md](chapters/04-winfr-temp-recovery.md) |
| 5 | ট্রায়াজ ও ভেরিফিকেশন | [chapters/05-triage-and-verification.md](chapters/05-triage-and-verification.md) |
| 6 | অ্যান্টি-চিট/ম্যালওয়্যার দৃষ্টিকোণ | [chapters/06-anticheat-malware-perspective.md](chapters/06-anticheat-malware-perspective.md) |
| 7 | অটোমেশন ও রিপোর্টিং | [chapters/07-automation-and-reporting.md](chapters/07-automation-and-reporting.md) |
| 8 | ল্যাব এক্সারসাইজ | [chapters/08-labs-and-challenges.md](chapters/08-labs-and-challenges.md) |
| 9 | বোনাস আর্টিফ্যাক্ট | [chapters/09-bonus-artifacts.md](chapters/09-bonus-artifacts.md) |

## 🛠️ স্ক্রিপ্টসমূহ (`scripts/`)

- `collect-temp.ps1` — লাইভ Temp ফোল্ডার ইনভেন্টরি + হ্যাশ + কপি
- `recover-temp-batch.ps1` — winfr দিয়ে মাল্টি-এক্সটেনশন ব্যাচ রিকভারি
- `triage-recovered.ps1` — রিকভার করা ফাইলের হ্যাশ/ম্যাজিক-বাইট ভেরিফিকেশন
- `full-temp-workflow.ps1` — উপরের সব ধাপ একসাথে চালিয়ে একটি রিপোর্ট তৈরি করে

## 🧪 ল্যাব (`labs/`)

তিনটি ধাপে-ধাপে ল্যাব এক্সারসাইজ, বিস্তারিত [chapters/08-labs-and-challenges.md](chapters/08-labs-and-challenges.md)-এ।

## ⚙️ প্রয়োজনীয়তা

- Windows 10/11 (ভার্চুয়াল মেশিনে সুপারিশকৃত)
- PowerShell 5.1+
- [Windows File Recovery](https://apps.microsoft.com/detail/9N26S50LN705) (Microsoft Store)
- (ঐচ্ছিক) Sysinternals Suite, sigcheck, PEStudio

## 📄 লাইসেন্স

শিক্ষামূলক উদ্দেশ্যে ব্যবহারের জন্য মুক্ত (MIT)। নিজের প্রয়োজনমতো `LICENSE` ফাইল যোগ করুন।

## 🚀 GitHub-এ পাবলিশ করবেন কীভাবে

```bash
cd windows-temp-forensics
git init
git add .
git commit -m "Initial commit: Windows Temp Forensics course"
git branch -M main
git remote add origin https://github.com/<your-username>/windows-temp-forensics.git
git push -u origin main
```
