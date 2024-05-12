
COMMANDS_FOLDER="$HOME/.commands"

function update_commands_usage {
    echo $'update_commands will download/send the "customcommands.sh" file. If no options are given, the contents of local "customcommands.sh" will be updated.'
    echo $'Usage: pushpod [OPTIONS] \n'
    echo "   Options:"
    echo "  	-d, --download_files     Download the 'customcommands.sh' file"
    echo "  	-s, --send_files         Send the 'customcommands.sh' file to repository"
    echo "  	-h, --help               Command help"
}

function update_commands {

	local CC_GIT="git@github.com:GabrielMMS/commoncommands.git"
	local OPT=

	while [ "$1" != "" ]; do
    	case $1 in
    	    -d | --download_files ) OPT=1
    	                            ;;
    	    -s | --send_files )    	OPT=2
    	                            ;;
    	    -h | --help )           update_commands_usage
    	                            return;
    	                            ;;
    	    * )                     update_commands_usage
    	                            return;
    	esac
    	shift
	done

 
	if [[ $OPT == 2 ]]; then
		if [[ ! -d $COMMANDS_FOLDER ]]; then
			echo "-------- Clonig 'commoncommands.git' in $COMMANDS_FOLDER"
			git clone $CC_GIT $COMMANDS_FOLDER
		fi

		echo "-------- Sending changes"
		echo "Enter the commit message (if it's empty, a dafault message will be created):"
		read -r COMMIT_MESSAGE

		if [[ $COMMIT_MESSAGE == "" ]]; then
			COMMIT_MESSAGE="Changes (`date`)"
		fi		

		PWD_PATH=`pwd`
		cd $COMMANDS_FOLDER

		TIMESTAMP=$(date +%s)
		git checkout -b $TIMESTAMP
		git add .
		git commit -m "$COMMIT_MESSAGE" 
		git push origin $TIMESTAMP

		git checkout main

		cd $PWD_PATH

		#open https://github.com/GabrielMMS/commoncommands/-/merge_requests/new?merge_request%5Bsource_branch%5D=${TIMESTAMP}
		return;
	fi


	if [[ ! -d $COMMANDS_FOLDER ]]; then
		echo "-------- Clonig 'commands.git' in $COMMANDS_FOLDER"
		git clone $CC_GIT $COMMANDS_FOLDER
	elif [[ -d $COMMANDS_FOLDER ]]; then
		echo "The folder '$COMMANDS_FOLDER' already exists and will be replaced, continue? Yes (Enter) / No(n/N)"
		read -r CONFIRM

		if [[ $CONFIRM != "N" && $CONFIRM != "n" ]]; then
			rm -rf $COMMANDS_FOLDER
			sleep 2
			echo "-------- Clonig 'customcommands.git' in $COMMANDS_FOLDER"
			git clone $CC_GIT $COMMANDS_FOLDER
		else
			echo "-------- Aborting."
			return
		fi
	fi

	if [[ ! -f $COMMANDS_FOLDER/customcommands.sh ]]; then
		echo "-------- Something went wrong... Aborting."
		return;
	fi

	echo "-------- Give execution permission to'customcommands.sh'"
	chmod +x $COMMANDS_FOLDER/customcommands.sh

	if [[ ! -f $HOME/.bash_profile ]]; then
		echo "-------- Creating .bash_profile"
		touch $HOME/.bash_profile
	fi

	if ! grep -q "source $HOME/.commands/customcommands.sh" $HOME/.bash_profile; then
		echo "-------- Add 'customcommands.sh' reference in .bash_profile"
	 	echo -e "\nsource $HOME/.commands/customcommands.sh" >> $HOME/.bash_profile
	fi

	echo "-------- Reload files"

	source $HOME/.commands/customcommands.sh
}
