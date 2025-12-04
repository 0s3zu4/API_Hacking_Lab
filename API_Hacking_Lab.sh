#!/bin/bash

# API Tools Installer v1.0.4 by 0s3zu4

LOG_FILE="/var/log/api_tools_installer.log"
SKIP_COUNT=0

sudo touch $LOG_FILE
sudo chmod 666 $LOG_FILE

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}
    ___    ____ ___   ___           _        _           
   /   |  / __ )__ \\ /   |  ____ _ (_)____  (_)___  ___ 
  / /| | / __  /_/ // /| | / __ \`/ / / ___| / / __ \\/ _ \\
 / ___ |/ /_/ / __// ___ |/ /_/ / / (__  ) / / /_/ /  __/
/_/  |_/_____/_/  /_/  |_|\\__,_/_/_/____(_)_/ .___/\\___/ 
                                          /_/            
API Tools Installer v1.2.3 by 0s3zu4
${NC}" | tee -a $LOG_FILE

function ask_continue() {
    local tool_name=$1
    echo -ne "${YELLOW}Do you want to continue to the next tool ($tool_name)? [y/N]: ${NC}"
    read -r choice
    if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
        SKIP_COUNT=$((SKIP_COUNT + 1))
        if [[ $SKIP_COUNT -ge 3 ]]; then
            echo -ne "${RED}You have skipped 3 tools. Do you want to terminate the script? [y/N]: ${NC}"
            read -r terminate_choice
            if [[ "$terminate_choice" == "y" || "$terminate_choice" == "Y" ]]; then
                echo -e "${RED}Terminating script.${NC}" | tee -a $LOG_FILE
                exit 0
            else
                SKIP_COUNT=0
            fi
        fi
        return 1
    fi
    return 0
}

function handle_externally_managed() {
    if grep -q "externally-managed-environment" <<< "$1"; then
        echo -e "${YELLOW}Detected EXTERNALLY-MANAGED environment issue. Attempting to fix...${NC}" | tee -a $LOG_FILE
        for dir in /usr/lib/python3*/EXTERNALLY-MANAGED; do
            if [[ -e $dir ]]; then
                sudo rm -f "$dir"
                echo -e "${GREEN}Removed $dir${NC}" | tee -a $LOG_FILE
            fi
        done
    fi
}

function install_docker() {
    if command -v docker >/dev/null 2>&1; then
        echo -e "${GREEN}Docker already installed. Skipping.${NC}" | tee -a $LOG_FILE
        return
    fi

    ask_continue "Docker" || return

    echo -e "${GREEN}Installing Docker...${NC}" | tee -a $LOG_FILE
    sudo apt-get update | tee -a $LOG_FILE
    sudo apt-get install -y docker.io docker-compose | tee -a $LOG_FILE
}

function install_postman() {
    local desktop_file="/usr/share/applications/postman.desktop"
    local icon_path="/opt/Postman/app/resources/app/assets/icon.png"

    if [[ -d "/opt/Postman" ]]; then
        echo -e "${GREEN}Postman directory detected. Checking for desktop icon...${NC}" | tee -a $LOG_FILE
        if [[ ! -f "$desktop_file" ]]; then
            echo -e "${YELLOW}Desktop icon missing. Recreating...${NC}" | tee -a $LOG_FILE
            cat << EOF | sudo tee $desktop_file > /dev/null
[Desktop Entry]
Version=1.0
Type=Application
Name=Postman
Exec=/usr/bin/postman
Icon=$icon_path
Terminal=false
Categories=Development;API;
EOF
            echo -e "${GREEN}Desktop icon created.${NC}" | tee -a $LOG_FILE
        else
            echo -e "${GREEN}Desktop icon already exists. Skipping.${NC}" | tee -a $LOG_FILE
        fi
        return
    fi

    ask_continue "Postman" || return

    echo -e "${GREEN}Installing Postman...${NC}" | tee -a $LOG_FILE
    sudo mkdir -p /opt/Postman
    curl -L https://dl.pstmn.io/download/latest/linux64 -o postman.tar.gz
    sudo tar -xzf postman.tar.gz -C /opt/Postman --strip-components=1
    sudo ln -sf /opt/Postman/Postman /usr/bin/postman
    rm -f postman.tar.gz
    cat << EOF | sudo tee $desktop_file > /dev/null
[Desktop Entry]
Version=1.0
Type=Application
Name=Postman
Exec=/usr/bin/postman
Icon=$icon_path
Terminal=false
Categories=Development;API;
EOF
    echo -e "${GREEN}Postman installed and desktop icon created.${NC}" | tee -a $LOG_FILE
}

function install_git() {
    if command -v git >/dev/null 2>&1; then
        echo -e "${GREEN}Git already installed. Skipping.${NC}" | tee -a $LOG_FILE
        return
    fi

    ask_continue "Git" || return

    sudo apt-get install -y git | tee -a $LOG_FILE
}

function install_mitmproxy2swagger() {
    if command -v mitmproxy2swagger >/dev/null 2>&1; then
        echo -e "${GREEN}mitmproxy2swagger already installed. Skipping.${NC}" | tee -a $LOG_FILE
        return
    fi

    ask_continue "mitmproxy2swagger" || return

    pip3 install mitmproxy2swagger 2>&1 | tee -a $LOG_FILE | { grep "externally-managed-environment" && handle_externally_managed "externally-managed-environment"; }
}

function install_go() {
    if command -v go >/dev/null 2>&1; then
        echo -e "${GREEN}Go already installed. Skipping.${NC}" | tee -a $LOG_FILE
        return
    fi

    ask_continue "Go" || return

    sudo apt-get install -y golang | tee -a $LOG_FILE
}

function install_jwt_tool() {
    if [[ -d "/opt/jwt_tool" ]]; then
        echo -e "${GREEN}JWT Tool already installed. Skipping.${NC}" | tee -a $LOG_FILE
        return
    fi

    ask_continue "JWT Tool" || return

    # Clone into a temp dir then move with sudo to avoid permission issues
    tmpdir=$(mktemp -d)
    if git clone https://github.com/ticarpi/jwt_tool "$tmpdir/jwt_tool" 2>&1 | tee -a $LOG_FILE; then
        sudo mv "$tmpdir/jwt_tool" /opt/jwt_tool
        sudo ln -sf /opt/jwt_tool/jwt_tool.py /usr/bin/jwt_tool
        sudo chmod +x /usr/bin/jwt_tool || true
        rm -rf "$tmpdir"
        echo -e "${GREEN}JWT Tool installed to /opt/jwt_tool.${NC}" | tee -a $LOG_FILE
    else
        echo -e "${RED}Failed to clone JWT Tool. Check network or repository URL.${NC}" | tee -a $LOG_FILE
        rm -rf "$tmpdir"
        return 1
    fi
}

function install_kiterunner() {
    if command -v kr >/dev/null 2>&1; then
        echo -e "${GREEN}Kiterunner already installed. Skipping.${NC}" | tee -a $LOG_FILE
        return
    fi

    ask_continue "Kiterunner" || return

    echo -e "${GREEN}Installing Kiterunner from source...${NC}" | tee -a $LOG_FILE

    if ! command -v git >/dev/null 2>&1; then
        echo -e "${RED}Git is not installed, but is required to clone the Kiterunner repository.${NC}" | tee -a $LOG_FILE
        return 1
    fi

    if ! command -v go >/dev/null 2>&1; then
        echo -e "${RED}Go is not installed, but is required to build Kiterunner. Please install Go and rerun this step.${NC}" | tee -a $LOG_FILE
        return 1
    fi

    if ! command -v make >/dev/null 2>&1; then
        echo -e "${YELLOW}'make' not found. Installing build-essential so we can build Kiterunner...${NC}" | tee -a $LOG_FILE
        sudo apt-get update | tee -a $LOG_FILE
        sudo apt-get install -y build-essential | tee -a $LOG_FILE
    fi

    tmpdir=$(mktemp -d)
    if git clone https://github.com/assetnote/kiterunner.git "$tmpdir/kiterunner" 2>&1 | tee -a $LOG_FILE; then
        cd "$tmpdir/kiterunner" || { echo -e "${RED}Failed to enter Kiterunner source directory.${NC}" | tee -a $LOG_FILE; rm -rf "$tmpdir"; return 1; }

        if make build 2>&1 | tee -a $LOG_FILE; then
            if [[ -f "dist/kr" ]]; then
                sudo mv dist/kr /usr/bin/kr
                sudo chmod +x /usr/bin/kr
                echo -e "${GREEN}Kiterunner built and installed to /usr/bin/kr.${NC}" | tee -a $LOG_FILE
            else
                echo -e "${RED}Kiterunner build completed but 'dist/kr' binary not found.${NC}" | tee -a $LOG_FILE
                rm -rf "$tmpdir"
                return 1
            fi
        else
            echo -e "${RED}Failed to build Kiterunner using make build.${NC}" | tee -a $LOG_FILE
            rm -rf "$tmpdir"
            return 1
        fi
    else
        echo -e "${RED}Failed to clone Kiterunner repository. Check your network connection or GitHub availability.${NC}" | tee -a $LOG_FILE
        rm -rf "$tmpdir"
        return 1
    fi

    cd - >/dev/null 2>&1 || true
    rm -rf "$tmpdir"
}

function install_arjun() {
    if command -v arjun >/dev/null 2>&1; then
        echo -e "${GREEN}Arjun already installed. Skipping.${NC}" | tee -a $LOG_FILE
        return
    fi

    ask_continue "Arjun" || return

    pip3 install arjun 2>&1 | tee -a $LOG_FILE | { grep "externally-managed-environment" && handle_externally_managed "externally-managed-environment"; }
}

function install_trufflehog() {
    if command -v trufflehog >/dev/null 2>&1; then
        echo -e "${GREEN}TruffleHog already installed. Skipping.${NC}" | tee -a $LOG_FILE
        return
    fi

    ask_continue "TruffleHog" || return

    pip3 install truffleHog 2>&1 | tee -a $LOG_FILE | { grep "externally-managed-environment" && handle_externally_managed "externally-managed-environment"; }
}

function move_wordlists() {
    if [[ -d "/opt/SecLists-master" ]]; then
        sudo mv /opt/SecLists-master /usr/share/wordlists/SecLists
        echo -e "${GREEN}Moved SecLists to /usr/share/wordlists.${NC}" | tee -a $LOG_FILE
    fi
    if [[ -d "/opt/Hacking-APIs-main" ]]; then
        sudo mv /opt/Hacking-APIs-main /usr/share/wordlists/Hacking-APIs
        echo -e "${GREEN}Moved Hacking-APIs to /usr/share/wordlists.${NC}" | tee -a $LOG_FILE
    fi
}

function install_gospider() {
    if command -v gospider >/dev/null 2>&1; then
        echo -e "${GREEN}GoSpider already installed. Skipping.${NC}" | tee -a $LOG_FILE
        return
    fi

    ask_continue "GoSpider" || return

    echo -e "${GREEN}Installing GoSpider using apt...${NC}" | tee -a $LOG_FILE
    sudo apt update | tee -a $LOG_FILE
    sudo apt install -y gospider | tee -a $LOG_FILE

    if command -v gospider >/dev/null 2>&1; then
        echo -e "${GREEN}GoSpider installation successful.${NC}" | tee -a $LOG_FILE
    else
        echo -e "${RED}GoSpider installation failed.${NC}" | tee -a $LOG_FILE
    fi
}

function install_sublime() {
    if command -v subl >/dev/null 2>&1; then
        echo -e "${GREEN}Sublime Text already installed. Skipping.${NC}" | tee -a $LOG_FILE
        return
    fi

    ask_continue "Sublime Text" || return

    wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
    echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
    sudo apt-get update
    sudo apt-get install -y sublime-text | tee -a $LOG_FILE
}

function install_owasp_zap() {
    if command -v zaproxy >/dev/null 2>&1; then
        echo -e "${GREEN}OWASP ZAP already installed. Skipping.${NC}" | tee -a $LOG_FILE
        return
    fi

    ask_continue "OWASP ZAP" || return

    sudo apt install -y zaproxy | tee -a $LOG_FILE
}

# ---- Run All Installers ----
install_docker
install_postman
install_git
install_mitmproxy2swagger
install_go
install_jwt_tool
install_kiterunner
install_arjun
move_wordlists
install_trufflehog
install_gospider
install_sublime
install_owasp_zap

echo -e "${GREEN}Installation completed. Installed tools summary:${NC}" | tee -a $LOG_FILE
echo -e "- Docker\n- Postman\n- Git\n- mitmproxy2swagger\n- Go\n- JWT Tool\n- Kiterunner\n- Arjun\n- SecLists\n- Hacking-APIs\n- TruffleHog\n- Gospider\n- Sublime Text\n- OWASP ZAP" | tee -a $LOG_FILE

