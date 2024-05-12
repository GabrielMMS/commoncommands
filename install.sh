#!/bin/sh

COMMANDS_FOLDER="$HOME/.commands"
CC_GIT="git@github.com:GabrielMMS/commoncommands.git"

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

chmod +x $COMMANDS_FOLDER/customcommands.sh
chmod +x $COMMANDS_FOLDER/custom_profile

cp $COMMANDS_FOLDER/.inputrc $HOME

if [[ ! -f $HOME/.bash_profile ]]; then
	touch $HOME/.bash_profile
fi

if ! grep -q "source $HOME/.commands/customcommands.sh" $HOME/.bash_profile; then
 echo -e "\nsource $HOME/.commands/customcommands.sh" >> $HOME/.bash_profile
fi

source $HOME/.bash_profile
