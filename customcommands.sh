#!/bin/sh
COMMANDS_FOLDER="$HOME/.commands"


# carrega o perfil customizado
source $HOME/.commands/custom_profile

# carrega os memes de audios
source $COMMANDS_FOLDER/meme/audios.sh

# carrega o update_commands
source $HOME/.commands/aux_scripts/update_commands.sh

# alias customizados
alias rmdd="rm -rf ~/Library/Developer/Xcode/DerivedData"
alias commands="sublime $HOME/.commands $HOME/.commands/customcommands.sh"
alias usb="sudo killall -STOP -c usbd"


#comandos uteis

function pushpod_usage {
    echo $'Usage: pushpod [OPTIONS] \n'
    echo "   Options:"
    echo "  	-b, --branch            Set the branch (version) number"
    echo "  	-n, --name              The Pod name"
    echo "  	-p, --path              Root of project"
    echo "  	-u, --update-pod        Updates the pod (in Pod/Example)"
    echo "  	-aw, --allow-warnings   Set the flag --allow-warnings in pod repo push"
    echo "  	-s, --sources           Set the flag --sources in pod repo push"
    echo "  	-v, --verbose           Set the flag --verbose in pod repo push"
    echo "  	-h, --help              Command help"
}

function pushpod(){

	local POD_NAME=
	local POD_PATH=
	local BRANCH=
	local ARGS_POD_PUSH=	
	local UPDATE_POD=0	


	while [ "$1" != "" ]; do
    	case $1 in
    	    -b | --branch )         	shift
    	                            	BRANCH=$1
    	                            	;;
    	    -n | --name )    			shift
										POD_NAME=$1
    	                            	;;
    	    -p | --path )    			shift
										POD_PATH=$1
    	                            	;;
    	    -u | --update-pod )    		UPDATE_POD=1
    	                            	;;
    	    -aw | --allow-warnings )	ARGS_POD_PUSH="$ARGS_POD_PUSH --allow-warnings"
    	                            	;;
    	    -s | --sources )    		shift
										ARGS_POD_PUSH="$ARGS_POD_PUSH --sources='$1'"
    	                            	;;
    	    -v | --verbose )    		ARGS_POD_PUSH="$ARGS_POD_PUSH --verbose"
    	                            	;;
    	    -h | --help )           	pushpod_usage
    	                            	return;
    	                            	;;
    	    * )                     	pushpod_usage
    	                            	return;
    	esac
    	shift
	done


	if [ "$POD_NAME" == '' ]
	then
		echo "Name not defined!"
		pushpod_usage
		return 0;
	fi;

	if [ "$POD_PATH" == '' ]
	then
		echo "Path not defined!"
		pushpod_usage
		return 0;
	fi;

	if [ "$BRANCH" == '' ]
	then
		echo "Branch not defined!"
		pushpod_usage
		return 0;
	fi;


	# terceiro parametro é a branch que será criada
	if [ "$BRANCH" != '' ]
	then

		# altera a branch no podspec
		local SEARCH="s.version  "
		local REPLACE="s.version          = '$BRANCH'"
		sed -i "" "s|${SEARCH}.*|${REPLACE}|g" "$POD_PATH/$POD_NAME.podspec"


		# faz atuaplização do pod (pod update)
		if [ "$UPDATE_POD" == '1' ]
		then
			echo $'\nAtualizando pods... \n';
			cd "$POD_PATH/Example"
			pod update
		fi;

		# envia para o repositorio (git/bitbucket)
		echo $'\n\nEnviando para o repositorio...\n'
		cd "$POD_PATH/"
		if [ `git rev-parse --verify --quiet ${BRANCH}` ]
		then   
			git checkout "$BRANCH"
			# echo "branch exists"
		else
			git checkout -b "$BRANCH"
			# echo "branch not exists"
		fi

		git add .
		git commit -m "Bugs Fixed" 
		git push origin $BRANCH

		# enviando para o cococapods local
		if [ "$5" != '' ]
		then
			ARGS_POD_PUSH="$5  "
		fi;
		if [ "$6" != '' ]
		then
			ARGS_POD_PUSH="$ARGS_POD_PUSH $6"
		fi;
		if [ "$7" != '' ]
		then
			ARGS_POD_PUSH="$ARGS_POD_PUSH $7"
		fi;

		echo $'\n\nEnviando o repo para o Specs...\n'
		echo "Flags utilizadas: "
		echo "$ARGS_POD_PUSH"
		pod repo push specs "$POD_PATH/$POD_NAME.podspec" $ARGS_POD_PUSH

	fi;
}



function chazan() {
	while [ 2 != 1 ]; do
		shasum $1
	done
}


function mon() {
	if [[ $1 = '-l' ]]; then
		if [[ $2 != '' ]]; then
			while :; do ls -la "$2"; done
		else
			while :; do ls -la; done
		fi
	elif [[ $1 != '' ]]; then
		while true; do $@; done
	else
		while :; do ls -la -1q | wc -l; done
	fi
}


function makeicns_usage {
    echo $'Usage: makeicns [ICON_NAME] [PNG_PATH]\n'
    echo $'Ex: makeicns icon /path/to/icon.png \n'
}
function makeicns() {
	local ICON_NAME=$1
	local PNG_IMG=$2

	if [ "$ICON_NAME" == '' ]
	then
		echo "Icon Name is not defined!!"
		makeicns_usage
		return 0;
	fi;
	if [ "$PNG_IMG" == '' ]
	then
		echo "PNG Image Path is not defined!!"
		makeicns_usage
		return 0;
	fi;

	# create icon.iconset folder
	mkdir $ICON_NAME.iconset
	# resize all the images
	sips -z 16 16     	$PNG_IMG --out $ICON_NAME.iconset/icon_16x16.png
	sips -z 32 32     	$PNG_IMG --out $ICON_NAME.iconset/icon_16x16@2x.png
	sips -z 32 32     	$PNG_IMG --out $ICON_NAME.iconset/icon_32x32.png
	sips -z 64 64     	$PNG_IMG --out $ICON_NAME.iconset/icon_32x32@2x.png
	sips -z 40 40     	$PNG_IMG --out $ICON_NAME.iconset/icon_40x40@2x.png
	sips -z 60 60     	$PNG_IMG --out $ICON_NAME.iconset/icon_60x60@3x.png
	sips -z 58 58     	$PNG_IMG --out $ICON_NAME.iconset/icon_58x58@2x.png
	sips -z 87 87     	$PNG_IMG --out $ICON_NAME.iconset/icon_87x87@3x.png
	sips -z 80 80     	$PNG_IMG --out $ICON_NAME.iconset/icon_80x80@2x.png
	sips -z 120 120     $PNG_IMG --out $ICON_NAME.iconset/icon_120x120@3x.png
	sips -z 120 120     $PNG_IMG --out $ICON_NAME.iconset/icon_120x120@2x.png
	sips -z 180 180     $PNG_IMG --out $ICON_NAME.iconset/icon_180x180@3x.png
	sips -z 128 128   	$PNG_IMG --out $ICON_NAME.iconset/icon_128x128.png
	sips -z 256 256   	$PNG_IMG --out $ICON_NAME.iconset/icon_128x128@2x.png
	sips -z 256 256   	$PNG_IMG --out $ICON_NAME.iconset/icon_256x256.png
	sips -z 512 512   	$PNG_IMG --out $ICON_NAME.iconset/icon_256x256@2x.png
	sips -z 512 512   	$PNG_IMG --out $ICON_NAME.iconset/icon_512x512.png
	sips -z 1024 1024   $PNG_IMG --out $ICON_NAME.iconset/icon_512x512@2x.png
	sips -z 1024 1024   $PNG_IMG --out $ICON_NAME.iconset/icon_1024x1024.png
	# create the .icns
	iconutil -c icns $ICON_NAME.iconset
	# remove the temp folder
	# rm -R $ICON_NAME.iconset
}




function set-proxy_usage {
    echo $'Set On/Off the Web Proxy and Secure Proxy.\n'
    echo $'Usage: set-proxy [OPTIONS] [STATUS (on/off)]\n'
    echo $'Ex: set-proxy -wifi on \n'
    echo "   Options:"
    echo "  	-wifi                  Set proxy on Wi-Fi interface"
    echo "  	-eth, -ethernet        Set proxy on Ethernet interface"
    echo "  	-h, --help             Command help"
}

function set-proxy {
	local INTERFACE=

	case $1 in
	    -wifi )		       		INTERFACE="Wi-Fi"
	                       		;;
	    -eth | -ethernet ) 		INTERFACE="Ethernet"
	                       		;;
	    -h | --help )      		set-proxy_usage
	                       		return;
	                       		;;
	    * )                		set-proxy_usage
	                       		return;
	esac

	if [[ "$2" == '' ]] && [[ "$2" != 'on' || "$2" != 'off' ]];	
	then
		echo "Status is not defined!!"
		set-proxy_usage
		return;
	fi;

	networksetup -setsecurewebproxystate "${INTERFACE}" $2
	networksetup -setwebproxystate "${INTERFACE}" $2
}


function set-volume {
	if [[ $1 == "" ]]; then
		echo "Usage: set-volume [VALUE]"
		echo "ex:    set-volume 15"
		return;
	fi
	
	osascript -e "set volume output volume $1"
}

function conn_status() {
	local STATUS=`$COMMANDS_FOLDER/aux_scripts/internet_connection.py`
	while [[ $STATUS == false ]]; do
		STATUS=`$COMMANDS_FOLDER/aux_scripts/internet_connection.py`
	done

	say 'computador online'
}

function enable_ssh() {
	sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist
}

function list_ports() {
	sudo lsof -iTCP -sTCP:LISTEN -n -P
}

function timestamp() {
	echo $(date +%s)
}

function flush_dns_cache() {
	sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder
}

