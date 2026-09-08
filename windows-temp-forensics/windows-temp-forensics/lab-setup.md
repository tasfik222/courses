# 0. ল্যাব সেটআপ

## উদ্দেশ্য
রিডার যেন নিরাপদে, আইসোলেটেড পরিবেশে প্র্যাকটিস করতে পারে — নিজের মূল (host) সিস্টেম
ঝুঁকিতে না ফেলে।

## ১. ভার্চুয়াল মেশিন তৈরি

- **হাইপারভাইজার:** VirtualBox অথবা VMware Workstation/Player
- **OS:** Windows 10 বা Windows 11 (evaluation ISO ব্যবহার করা যায়)
- **RAM:** ন্যূনতম 4 GB (সুপারিশ 8 GB)
- **CPU:** 2+ core

### দুটি ভার্চুয়াল ডিস্ক যোগ করুন

| ড্রাইভ | উদ্দেশ্য | সাইজ |
|--------|----------|------|
| `C:` | সিস্টেম / যেখানে Temp ফাইল থাকবে | 60 GB+ |
| `E:` | রিকভারি আউটপুট (winfr-এর নিয়ম অনুযায়ী উৎস ও গন্তব্য ভিন্ন ড্রাইভ হতে হবে) | 20 GB+ |

## ২. প্রয়োজনীয় টুলস ইনস্টল

```powershell
# Windows File Recovery (Microsoft Store থেকে, অথবা):
winget install --id 9N26S50LN705 -e

# Sysinternals Suite (Process Hacker বিকল্প হিসেবে Process Explorer)
winget install Microsoft.Sysinternals.ProcessExplorer

# sigcheck (Sysinternals স্যুটে অন্তর্ভুক্ত)
```

ঐচ্ছিক টুলস:
- [PEStudio](https://www.winitor.com/) — স্ট্যাটিক PE অ্যানালাইসিস
- [Volatility 3](https://github.com/volatilityfoundation/volatility3) — মেমরি ফরেনসিক্স (অ্যাডভান্সড)

## ৩. স্ন্যাপশট নেওয়ার নিয়ম

প্রতিটি ল্যাব এক্সারসাইজ শুরুর **আগে** একটি ক্লিন স্ন্যাপশট নিন:

- VirtualBox: `Machine > Take Snapshot` (নাম দিন `clean-baseline`)
- VMware: `VM > Snapshot > Take Snapshot`

এতে ভুল হলে সহজেই বেসলাইনে ফিরে যেতে পারবেন।

## ৪. নেটওয়ার্ক আইসোলেশন (সুপারিশকৃত)

ল্যাবে যেকোনো টেস্ট ফাইল/স্ক্রিপ্ট চালানোর সময় VM-এর নেটওয়ার্ক অ্যাডাপ্টার
**Host-only** বা **Internal Network** মোডে রাখুন, যাতে বাইরের সাথে অনিচ্ছাকৃত
কোনো যোগাযোগ না হয়।

## ৫. ফোল্ডার কনভেনশন

কোর্সজুড়ে আমরা ধরে নেব:

```
C:\Users\<user>\AppData\Local\Temp   → উৎস (analysis target)
E:\recovered\                        → winfr আউটপুট
E:\reports\                          → CSV/JSON রিপোর্ট
```

সেটআপ শেষ হলে [chapters/01-temp-basics.md](chapters/01-temp-basics.md) থেকে শুরু করুন।
