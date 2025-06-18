# API_Hacking_Lab

A powerful, automated installer script to set up API penetration testing tools inspired by **APIsec University API Penetration Testing Course** — with a few personal favorites added!

---

## ⚡ What this script does

✅ Installs all the essential tools required for API security testing:

- Docker (official installation method for Debian/Kali)
- MITMProxy + mitmproxy2swagger
- Postman (with desktop shortcut)
- Git
- Go
- JWT Tool
- Kiterunner
- Arjun
- SecLists
- Hacking-APIs wordlists 
- Sublime Text
- OWASP ZAP
- GoSpider  

❗ **Note:**  
Trufflehog is planned for the next update once I finalize a clean install method!

---

## 📦 How to use

1️⃣ Clone the repository:
```bash
git clone https://github.com/0s3zu4/API_Hacking_Lab.git
cd API_Hacking_Lab
chmod +x API_Hacking_Lab.sh
sudo ./API_Hacking_Lab.sh
```

📝 Features
- ✨ Interactive installation — asks if you want to install each tool
- ✨ Skips tools that are already installed
- ✨ Moves SecLists and Hacking-APIs wordlists to the right location
- ✨ Generates a postman.desktop shortcut
- ✨ Keeps a detailed install log
- ✨ Designed for Kali Linux / Debian-based systems

🛠 Requirements
Kali Linux, Debian, or similar

sudo privileges

Internet connection

🤝 Credits
Tools list inspired by APIsec University API Pentesting Course

Created by: Osezua

📌 Upcoming Updates
- 🚀 Add Trufflehog clean installer
- 🚀 Add optional virtualenv support
- 🚀 Improved error handling
