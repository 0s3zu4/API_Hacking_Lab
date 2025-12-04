## API_Hacking_Lab

A powerful, automated installer script to set up API penetration testing tools inspired by **APIsec University API Penetration Testing Course** — with a few personal favorites added.

---

## ⚡ What this script does

✅ Installs all the essential tools required for API security testing:

- **Docker** (via `apt` on Debian/Kali)
- **MITMProxy + mitmproxy2swagger**
- **Postman** (with desktop shortcut)
- **Git**
- **Go**
- **JWT Tool**
- **Kiterunner** (built from source using `git clone` + `make build`)
- **Arjun**
- **SecLists**
- **Hacking-APIs wordlists**
- **Sublime Text**
- **OWASP ZAP**
- **GoSpider**
- **TruffleHog**

All tools are logged to `/var/log/api_tools_installer.log` for troubleshooting.

---

## 📦 How to use

Clone the repository and run the installer:

```bash
git clone https://github.com/0s3zu4/API_Hacking_Lab.git
cd API_Hacking_Lab
chmod +x API_Hacking_Lab.sh
sudo ./API_Hacking_Lab.sh
```

---

## 📝 Features

- **Interactive installation**: prompts before each tool (`y/N`)
- **Skip-aware**: automatically skips tools already installed
- **Wordlist management**: moves SecLists and Hacking-APIs wordlists into `/usr/share/wordlists`
- **Postman desktop integration**: generates a `postman.desktop` launcher if missing
- **Centralized logging**: writes all actions to `/var/log/api_tools_installer.log`
- **EXTERNALLY-MANAGED handling**: attempts to auto-resolve Python `externally-managed-environment` issues for `pip3` installs
- **Kali / Debian-friendly**: designed and tested primarily on Kali / Debian-based systems

---

## 🛠 Requirements

- Kali Linux, Debian, or similar Debian-based distro  
- `sudo` privileges (the script installs system packages and tools)

---

## 🤝 Credits

- Tools list inspired by **APIsec University API Pentesting Course**

Created by: **Os3zu4**

---

## 📌 Upcoming Updates

- Add optional `virtualenv` support for Python-based tools
