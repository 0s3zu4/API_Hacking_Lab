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
- SecLists (moved to `/usr/share/wordlists` if found in `/opt`)
- Hacking-APIs wordlists (moved to `/usr/share/wordlists` if found in `/opt`)
- Sublime Text
- OWASP ZAP
- GoSpider (`apt install gospider`)  

❗ **Note:**  
Trufflehog is planned for the next update once I finalize a clean install method!

---

## 📦 How to use

1️⃣ Clone the repository:
```bash
git clone https://github.com/yourusername/api-tools-installer.git
cd api-tools-installer
