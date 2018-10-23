#!/bin/bash
# This control tools
# was made by Malhadi Jr
# to prevent user for
# un-controlled share
# by limiting server
# 9 October 2017

# Added on 2-August-2k18
# Assign the arguments for each
# parameter to global variable
while getopts ":i:rap" o; do
    case "${o}" in
        i)
            accessid=${OPTARG}
            ;;
        r)
            is_register="y"
            ;;
        a)
            is_install_apple="y"
            ;;
        p)
            is_install_paypal="y"
            ;;
    esac
done


RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m' 
PURPLE='\033[0;35m'
NC='\033[0m'
PYPL_PATH="ZWxvbm11c2sudHh0Cg=="
AAPL_PATH="c3RldmVqb2JzLnR4dAo="



if [[ `whoami` != "root" ]]; then
	echo "You must be root to run this."
	echo "Try: sudo $0"
	exit
fi

test_connect_api(){
	is_api_up=`curl "malhadijr.com" -L -s -D - -m 15 -o /dev/null`
	is_script_up=`curl "malhadijr.com" -L -s -D - -m 15 -o /dev/null`
	if [[ $is_api_up == '' ]]; then
		echo "[WARNING] Could not connect to API Server."
		exit
	fi
	if [[ $is_script_up == '' ]]; then
		echo "[WARNING] Could not connect to Script Server."
		exit
	fi
}
test_connect_api

setup_dev() {
	if [[ `which yum` == "" ]]; then
		###################### Install for Debian based #####################
		apt-get install -m -y curl wget nano tree screen zip unzip git bc python build-essential chrpath libssl-dev libxft-dev libfreetype6 libfreetype6-dev libfontconfig1 libfontconfig1-dev
		if [ `uname -m` == 'x86_64' ]; then
			# DEB 64bit
			if [[ `which jq` == "" ]]; then
				wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64; chmod +x jq-linux64; mv jq-linux64 /bin/jq; jq --help
			fi
			if [[ `which phantomjs` == "" ]]; then
				export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"; wget "https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2"; tar xvjf $PHANTOM_JS.tar.bz2; mv $PHANTOM_JS /usr/local/share; ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin; phantomjs --version; 
			fi
			if [[ `which casperjs` == "" ]]; then
				git clone git://github.com/casperjs/casperjs.git; cd casperjs; ln -sf `pwd`/bin/casperjs /usr/local/bin/casperjs; cd ../
			fi
		else
			# DEB 32bit
			if [[ `which jq` == "" ]]; then
				wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux32; chmod +x jq-linux32; mv jq-linux32 /bin/jq; jq --help
			fi			
			if [[ `which phantomjs` == "" ]]; then
				export PHANTOM_JS="phantomjs-2.1.1-linux-i686"; wget "https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2"; tar xvjf $PHANTOM_JS.tar.bz2; mv $PHANTOM_JS /usr/local/share; ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin; phantomjs --version; 
			fi
			if [[ `which casperjs` == "" ]]; then
				git clone git://github.com/casperjs/casperjs.git; cd casperjs; ln -sf `pwd`/bin/casperjs /usr/local/bin/casperjs; cd ../
			fi
		fi
	else
		###################### Install for RedHat based #####################
		yum install -y curl wget nano tree screen zip unzip git python freetype fontconfig bzip2 bc
		if [ `uname -m` == 'x86_64' ]; then
			# RPM 64bit
			if [[ `which jq` == "" ]]; then
				wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64; chmod +x jq-linux64; mv jq-linux64 /bin/jq; jq --help
			fi
			if [[ `which phantomjs` == "" ]]; then
				export PHANTOM_JS="phantomjs-2.1.1-linux-x86_64"; wget "https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2"; tar xvjf $PHANTOM_JS.tar.bz2; mv $PHANTOM_JS /usr/local/share; ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin; phantomjs --version; 
			fi
			if [[ `which casperjs` == "" ]]; then
				git clone git://github.com/casperjs/casperjs.git; cd casperjs; ln -sf `pwd`/bin/casperjs /usr/local/bin/casperjs; cd ../
			fi
		else
			# RPM 32bit
			if [[ `which jq` == "" ]]; then
				wget https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux32; chmod +x jq-linux32; mv jq-linux32 /bin/jq; jq --help
			fi
			if [[ `which phantomjs` == "" ]]; then
				export PHANTOM_JS="phantomjs-2.1.1-linux-i686"; wget "https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2"; tar xvjf $PHANTOM_JS.tar.bz2; mv $PHANTOM_JS /usr/local/share; ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin; phantomjs --version; 
			fi
			if [[ `which casperjs` == "" ]]; then
				git clone git://github.com/casperjs/casperjs.git; cd casperjs; ln -sf `pwd`/bin/casperjs /usr/local/bin/casperjs; cd ../
			fi
		fi
	fi

	# External independent package
	if [[ `which speedtest-cli` == "" ]]; then
		wget -O speedtest-cli https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py; chmod +x speedtest-cli; mv speedtest-cli /bin/; speedtest-cli
	fi
	echo `date` >> .malhadi-setup.hst
}

if [ -f .malhadi-setup.hst ]; then
    echo "You have setup the package on this machine at `cat .malhadi-setup.hst`"
else
	echo "This is your first run on `date`. " 
	echo "Now installing required package. Please wait..."
	setup_dev
fi

assign_accessid() {
	accessid="$1"
	echo ""
	config='
[
  {
    "accessid": "'$accessid'",
    "path_to_api": "https://malhadijr.com/resource/api.php",
    "path_to_script": "https://malhadijr.com/resource",
    "submitted_on": "'`date`'"
  }
]
'
	echo $config > config.json
	path_to_api=`cat config.json | jq -r '.[] .path_to_api'`
	path_to_script=`cat config.json | jq -r '.[] .path_to_script'`
	check_access_id=`curl -s "$path_to_api?accessid=$accessid&do=get_user_info"`
	if [[ $check_access_id == 'AccessID invalid' ]]; then
		echo "Your access id are invalid."
		rm -f config.json
		exit
	else
		if [[ $check_access_id == "" ]]; then
			echo "Something wrong when requesting to API"
			rm -f config.json
			exit
		else
			echo $check_access_id > access.json
		fi
	fi
	fullname=`cat access.json | jq -r '.owner'`
	server_quota=`cat access.json | jq -r '.quota'`
}

if [ ! -f config.json ]; then
	if [[ $accessid == "" ]]; then
		echo "Creating new Access. Please Fill the input below."
		echo -n "AccessID (your type are invisible): "
		read -s accessid
		assign_accessid "$accessid"
	else
		echo "Creating new Access. With input given."
		assign_accessid "$accessid"
	fi
else
	fullname=`cat access.json | jq -r '.owner'`
	server_quota=`cat access.json | jq -r '.quota'`
	accessid=`cat config.json | jq -r '.[] .accessid'`
	path_to_api=`cat config.json | jq -r '.[] .path_to_api'`
	path_to_script=`cat config.json | jq -r '.[] .path_to_script'`
fi

updater() {
  echo "Checking integrity file to server..."
  file_name="control.sh"
  localSh=`cat $file_name | sha256sum`
  cloudSh=`curl "$path_to_script/$file_name" -s | sha256sum`
  if [[ $localSh != $cloudSh ]]; then
    echo "Updating script... Please wait."
    rm -f $file_name; wget --quiet "$path_to_script/$file_name"; chmod +x "$file_name"
    echo "File successfully updated on `date`."
  else
    echo "Script are up to date. Nothing to do."
  fi
}
# auto-update control.sh from server
updater

ip_strings=`curl -s -L ipapi.co/json`;ip_address=`echo $ip_strings | jq -r '.ip'`;ip_country=`echo $ip_strings | jq -r '.country'`;ip_country_name=`echo $ip_strings | jq -r '.country_name'`;ip_city=`echo $ip_strings | jq -r '.city'`;ip_region=`echo $ip_strings | jq -r '.region'`;ip_timezone=`echo $ip_strings | jq -r '.timezone'`;ip_org=`echo $ip_strings | jq -r '.org'`

if [[ $ip_address =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
	echo "Valid IPv4 address: $ip_address"
else
	echo "IPv6 shown: $ip_address | Using IPv4 regexp instead."
	ip_address=`ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | head -1`
fi

detect_os() {
	if [[ `which yum` == "" ]]; then
		os="Ubuntu"
	else
		os="Centos"
	fi
	echo $os
}

get_ram_size() {
	sz=`grep MemTotal /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=2; {}/1024^2" | bc`
	echo "$sz GB"
}

get_cpu_name() {
	model=`grep "model name" /proc/cpuinfo | tail -1 | awk -F[:] '{print $2}' | xargs`
	echo "$model"
}

get_cpu_core() {
	core=`grep -c processor /proc/cpuinfo`
	echo "$core"
}

get_download_speed() {
	downloadSpeed=`speedtest-cli | grep "Download: " | awk -F[:] '{print $2}' | xargs`
	echo $downloadSpeed
}

get_upload_speed() {
	uploadSpeed=`speedtest-cli | grep "Upload: " | awk -F[:] '{print $2}' | xargs`
	echo $uploadSpeed
}

get_server_hash() {
	hashed=`uname -a | sha256sum | awk -F [-] '{print $1}' | xargs`
	echo $hashed
}

server_info='
[
  {
    "sid": "'`get_server_hash`'",
    "registered": "'`date`'",
    "linux": "'`uname -a`'",
    "os": "'`detect_os`'",
    "memory": "'`get_ram_size`'",
    "cpu_name": "'`get_cpu_name`'",
    "cpu_core": "'`get_cpu_core`'",
    "ip_address": "'$ip_address'",
    "ip_country": "'$ip_country'",
    "ip_country_name": "'$ip_country_name'",
    "ip_city": "'$ip_city'",
    "ip_region": "'$ip_region'",
    "ip_timezone": "'$ip_timezone'",
    "ip_org": "'$ip_org'"
  }
]
'

append_server() {
	curl -s "$path_to_api?accessid=$accessid&do=append_server" --data "sid=`get_server_hash`&registered=`date`&linux=`uname -a`&os=`detect_os`&memory=`get_ram_size`&cpu_name=`get_cpu_name`&cpu_core=`get_cpu_core`&ip_address=$ip_address&ip_country=$ip_country&ip_country_name=$ip_country_name&ip_city=$ip_city&ip_region=$ip_region&ip_timezone=$ip_timezone&ip_org=$ip_org"
}

get_server_list() {
	resp=`curl -s "$path_to_api?accessid=$accessid&do=get_server"`
	if [[ $resp == "There is no server" ]]; then
		echo "There is no server"
	else
		echo $resp | jq
	fi
}
	
delete_server_this() {
	curl -s "$path_to_api?accessid=$accessid&do=delete_server" --data "sid=`get_server_hash`"
}

delete_server_sid() {
	resp_server=`curl -s "$path_to_api?accessid=$accessid&do=get_server"`
	if [[ $resp_server == "There is no server" ]]; then
		echo "There is no server"
	else
		echo $resp_server | jq
		echo -n "Paste the sid server you want to remove: "
		read sid
		curl -s "$path_to_api?accessid=$accessid&do=delete_server_sid" --data "sid=$sid"
	fi
}

check_server() {
	curl -s "$path_to_api?accessid=$accessid&do=check_server" --data "sid=`get_server_hash`"
}

install_paypal_valid() {
	isRegistered=`check_server`
	if [[ $isRegistered == 'This server are not registered' ]]; then
		echo "Register this server first"
	else
		isEligible=`curl -s "$path_to_api?accessid=$accessid&do=get_user_info" | jq -r '.paypalvalid'`
		if [[ $isEligible == "no" || $isEligible == "" ]]; then
			echo "You are not eligible to install paypal valid"
		else
			if [[ -d "paypalvalid" ]]; then
				echo "Folder exist. Updating instead."

				pypl=`echo $PYPL_PATH | base64 --decode`; paypalvalid_path="$path_to_script/paypalvalid/$pypl"; 
				echo "Downloading latest paypal script from server"
				wget "$paypalvalid_path" -q -O "paypalvalid/paypal.sh"
				wget "$path_to_script/paypalvalid/cookies.txt" -q -O "paypalvalid/cookies.txt"
				wget "$path_to_script/paypalvalid/netlog.js" -q -O "paypalvalid/netlog.js"

				echo "Setting permission to script"
				chmod +x "paypalvalid/paypal.sh"
				chmod +x "paypalvalid/netlog.js"
				echo "PayPal Valid installed on paypalvalid/"
				tree "paypalvalid/"
			else
				echo "Creating folder paypalvalid/"
				mkdir "paypalvalid"
				mkdir "paypalvalid/compressed/"
				mkdir "paypalvalid/haschecked/"

				pypl=`echo $PYPL_PATH | base64 --decode`; paypalvalid_path="$path_to_script/paypalvalid/$pypl"; 
				echo "Downloading latest paypal script from server"
				wget "$paypalvalid_path" -q -O "paypalvalid/paypal.sh"
				wget "$path_to_script/paypalvalid/cookies.txt" -q -O "paypalvalid/cookies.txt"
				wget "$path_to_script/paypalvalid/netlog.js" -q -O "paypalvalid/netlog.js"

				echo "Setting permission to script"
				chmod +x "paypalvalid/paypal.sh"
				chmod +x "paypalvalid/netlog.js"
				echo "PayPal Valid installed on paypalvalid/"
				tree "paypalvalid/"
			fi
		fi
	fi
}

install_apple_valid() {
	isRegistered=`check_server`
	if [[ $isRegistered == 'This server are not registered' ]]; then
		echo "Register this server first"
	else
		isEligible=`curl -s "$path_to_api?accessid=$accessid&do=get_user_info" | jq -r '.applevalid'`
		if [[ $isEligible == "no" || $isEligible == "" ]]; then
			echo "You are not eligible to install apple valid"
		else
			if [[ -d "applevalid" ]]; then
				echo "Folder exist. Updating instead."

				aapl=`echo $AAPL_PATH | base64 --decode`; applevalid_path="$path_to_script/applevalid/$aapl"; 
				echo "Downloading latest apple script from server"				
				wget "$applevalid_path" -q -O "applevalid/apple.sh"
				wget "$path_to_script/applevalid/cookies.txt" -q -O "applevalid/cookies.txt"
				wget "$path_to_script/applevalid/netlog.js" -q -O "applevalid/netlog.js"

				echo "Setting permission to script"
				chmod +x "applevalid/apple.sh"
				chmod +x "applevalid/netlog.js"
				tree "applevalid/"
			else
				echo "Creating folder applevalid/"
				mkdir "applevalid"
				mkdir "applevalid/compressed/"
				mkdir "applevalid/haschecked/"

				aapl=`echo $AAPL_PATH | base64 --decode`; applevalid_path="$path_to_script/applevalid/$aapl"; 
				echo "Downloading latest apple script from server"				
				wget "$applevalid_path" -q -O "applevalid/apple.sh"
				wget "$path_to_script/applevalid/cookies.txt" -q -O "applevalid/cookies.txt"
				wget "$path_to_script/applevalid/netlog.js" -q -O "applevalid/netlog.js"

				echo "Setting permission to script"
				chmod +x "applevalid/apple.sh"
				chmod +x "applevalid/netlog.js"
				echo "Apple Valid installed on applevalid/"
				tree "applevalid/"
			fi
		fi
	fi
}


# Logic between INTERPRETER mode or INTERACTIVE mode

# INTERPRETER mode
if [[ $is_register == "y" || $is_install_apple == "y" || $is_install_paypal == "y" ]]; then
	if [[ $is_register == "y" ]]; then
		append_server
		echo ""
	fi
	if [[ $is_install_apple == "y" ]]; then
		install_apple_valid
		echo ""
	fi
	if [[ $is_install_paypal == "y" ]]; then
		install_paypal_valid
		echo ""
	fi
	exit
fi





cat <<EOF


           ##########################   #
           ########################    ##
           ####                       ###
           ####                      ####
           #######################   ####
           #######################   ####
                              ####   ####
                              ####   ####
           ##########     ########   ####
           ############     ######   ####
           #####                     ####
           #####                     ####
           ##################    ########
           ####################    ######

              - https://malhadijr.com -
           [+] malhadijr@slackerc0de.us [+]
        
---------------------------------------------------------
          Slackerc0de Family | By Malhadi Jr
    This tools are registered to $fullname
---------------------------------------------------------

Menu list:
1   Verify this server to API
2   Register this server to API
3   Delete this server from API
4   Delete another server from API
5   Show this server specification
6   Show all registered server
7   Show account info (sensitive)
8   Remove access
9   Install Paypal Valid
10  Install Apple Valid
11  Update control tools
12  Exit from control

---------------------------------------------------------
EOF

all_done=0
while (( !all_done )); do
	printf "${PURPLE}Enter your choice number${CYAN}: ${NC}"
	read n
	case $n in
	    1) check_server;;
	    2) append_server;;
	    3) delete_server_this;;
		4) delete_server_sid;;
		5) echo $server_info | jq;;
		6) get_server_list;;
		7) cat access.json | jq;;
		8) rm -f access.json config.json; echo "Access removed";all_done=1;;
		9) install_paypal_valid;;
		10) install_apple_valid;;
		11) updater;all_done=1;;
	    12) echo "Exiting now.";all_done=1;;
	    *) echo "invalid option";;
	esac
	echo ""
done