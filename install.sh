#!/bin/sh

CC_GIT="https://github.com/GabrielMMS/commoncommands.git"
COMMANDS_FOLDER="$HOME/.commands"
git clone $CC_GIT $COMMANDS_FOLDER
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
