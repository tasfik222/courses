# PC Cheat-Check & Forensic Investigation Field Manual

একটি সম্পূর্ণ, ধাপে-ধাপে সাজানো কোর্স — esports টুর্নামেন্ট অ্যান্টি-চিট অফিশিয়ালদের
জন্য। Windows-এর নিজস্ব বিল্ট-ইন কমান্ড থেকে শুরু করে Eric Zimmerman-এর ফরেনসিক
টুলসেট, kernel-level ড্রাইভার ফরেনসিক্স, PE-sieve মেমরি-স্ক্যান বিশ্লেষণ, এবং
স্ক্রিনশট-ভিত্তিক অ্যানালিস্ট প্রোটোকল পর্যন্ত — সব একসাথে।

> ⚠️ **শুধুমাত্র নিজের মালিকানাধীন সিস্টেম বা ল্যাব VM-এ প্র্যাকটিস করুন।**
> এই ম্যানুয়ালের কোনো চেক-ই চূড়ান্ত রায় দেয় না — প্রতিটি ফলাফল মানুষ
> সিদ্ধান্তগ্রহণকারীকে সহায়তা করার জন্য, যাতে টুর্নামেন্ট অফিশিয়াল নিজে
> চূড়ান্ত সিদ্ধান্ত নিতে পারেন।

## 📖 কোর্সের জন্য কারা

- Esports টুর্নামেন্ট অ্যান্টি-চিট অফিশিয়াল/অ্যাডমিন
- DFIR (Digital Forensics & Incident Response) শিখতে আগ্রহী শিক্ষার্থী
- SOC/Blue Team মেম্বার যারা এন্ডপয়েন্ট আর্টিফ্যাক্ট বুঝতে চান
- যেকোনো মানুষ যিনি Windows-এ প্রোগ্রাম রান/ডিলিট হওয়ার ট্রেস কীভাবে খুঁজে বের
  করতে হয় তা শিখতে চান

## 🗂️ কোর্স স্ট্রাকচার

| # | চ্যাপ্টার | লেভেল | ফাইল |
|---|-----------|-------|------|
| 1 | রেজিস্ট্রি, USN Journal, CMD, Event Viewer, ব্রাউজার হিস্ট্রি | কোনো টুল লাগবে না | [chapters/01-core-manual-checks.md](chapters/01-core-manual-checks.md) |
| 2 | আরও রেজিস্ট্রি লোকেশন ও CMD/PowerShell কমান্ড | কোনো টুল লাগবে না | [chapters/02-extra-registry-cmd.md](chapters/02-extra-registry-cmd.md) |
| 3 | Jump Lists, Clipboard, WER, Shadow Copy, LNK ফাইল + Eric Zimmerman CLI টুলস | ম্যানুয়াল + CLI | [chapters/03-jumplists-and-ez-tools.md](chapters/03-jumplists-and-ez-tools.md) |
| 4 | Kernel ড্রাইভার ফরেনসিক্স, ETW ট্রেসিং, PE-sieve আউটপুট পড়া | অ্যাডভান্সড | [chapters/04-kernel-driver-and-etw.md](chapters/04-kernel-driver-and-etw.md) |
| 5 | অ্যান্টি-চিট লগ, HID ডিভাইস হিস্ট্রি, GPU ওভারলে, স্যান্ডবক্স/VM চেক | মিশ্র ম্যানুয়াল/GUI | [chapters/05-final-additions.md](chapters/05-final-additions.md) |
| 6 | স্ক্রিনশট অ্যানালাইসিস — অ্যানালিস্ট প্রোটোকল ও সিভিয়ারিটি টিয়ার | প্রসেস / SOP | [chapters/06-screenshot-analyst-sop.md](chapters/06-screenshot-analyst-sop.md) |
| 7 | Appendix — `Check-UnsignedDLLs.ps1` স্ক্রিপ্ট গাইড | স্ক্রিপ্ট | [chapters/07-appendix-script-guide.md](chapters/07-appendix-script-guide.md) |

## 🛠️ স্ক্রিপ্টসমূহ (`scripts/`)

- `Check-UnsignedDLLs.ps1` — একটি চলমান প্রসেসে লোড হওয়া unsigned বা
  invalid-signature DLL শনাক্ত করে; `-Continuous` ফ্ল্যাগ দিয়ে রিয়েল-টাইমেও
  মনিটর করা যায়।

## ⚙️ প্রয়োজনীয়তা

- Windows 10/11 (Administrator অ্যাক্সেসসহ, কিছু কমান্ডের জন্য প্রয়োজন)
- PowerShell 5.1+
- ঐচ্ছিক টুলস: [Eric Zimmerman's EZ Tools](https://ericzimmerman.github.io/#!index.md), Sysinternals Suite (Autoruns, sigcheck, strings), PE-sieve

## 📋 কীভাবে ব্যবহার করবেন

1. **Chapter 1 দিয়ে শুরু করুন** — প্রতিটি চ্যাপ্টারের শেষে একটি "Quick Priority
   Checklist" আছে, যা Discord পিন করার মতো করে বানানো।
2. **প্রয়োজন হলেই এগিয়ে যান** — Chapter 2–3 বিল্ট-ইন Windows টুলস ও Eric
   Zimmerman-এর ফ্রি CLI পার্সার দিয়েই বাড়তি গভীরতা দেয়।
3. **Chapter 4 শুধু সত্যিকারের সন্দেহজনক কেসের জন্য** — kernel driver, ETW,
   PE-sieve মেমরি স্ক্যান বাস্তব ফরেনসিক দক্ষতা দাবি করে।
4. **Chapter 6 কে রিপোর্ট টেমপ্লেট হিসেবে ব্যবহার করুন** — এখানে বলা আছে কীভাবে
   ফলাফল বর্ণনা, ক্লাসিফাই, কনফিডেন্স-রেট এবং এসকেলেট করতে হয়, fact ও inference
   আলাদা রেখে।

## 🧭 মূলনীতি

- **কোনো টুলই চূড়ান্ত রায় নয়** — প্রতিটি চেক প্রমাণ তৈরি করে, দোষী সাব্যস্ত করে
  না; চূড়ান্ত সিদ্ধান্ত সবসময় মানুষ অফিশিয়ালের।
- **শুধুমাত্র বৈধ, পাবলিকলি ডকুমেন্টেড টুলস** ব্যবহৃত হয়েছে (Sysinternals, EZ
  Tools, Volatility, Windows-এর নিজস্ব বিল্ট-ইন ইউটিলিটি) — অনানুষ্ঠানিক বা
  চিট-সম্পর্কিত কোনো সোর্স থেকে কিছু নামানোর দরকার নেই।
- **Order of operations গুরুত্বপূর্ণ** — volatile evidence (running process,
  memory, network) সবসময় কম volatile evidence (registry, files, logs)-এর আগে
  সংগ্রহ করুন।
- **সবকিছু ডকুমেন্ট করুন** — প্রতিটি কমান্ডের আউটপুট স্ক্রিনশট বা লগ করুন; কোনো
  রায় চ্যালেঞ্জ করা হলে এটাই আপনার প্রমাণ।

## 📄 লাইসেন্স

শিক্ষামূলক উদ্দেশ্যে ব্যবহারের জন্য মুক্ত — বিস্তারিত [LICENSE](LICENSE) ফাইলে।


Live version: https://tasfik222.github.io/allinone/
