#!/usr/bin/bash 
#create data base
# if [ ! -d $HOME/dataBase ]
# then
# mkdir $HOME/dataBase 
# fi
# DB_Path=$HOME/dataBase
isWrongInput=0
function createDB {
        checkNaming "$nameDB"
	if [ ! -d $HOME/dataBase/"$nameDB" ] && [ $isValid -eq 1 ] 
		then
		mkdir $HOME/dataBase/"$nameDB"
		touch $HOME/dataBase/"$nameDB"/metaData
		echo "DataBase created"
	else
		if [ $isValid -eq 0 ] || [ $isEnter -eq 1 ] 2> /dev/null && [ ! $isWrongInput -eq 1 ]
			then
			echo "DataBase name is not valid!"
		else
			if [ -d $HOME/dataBase/"$nameDB" ] && [ ! $isWrongInput -eq 1 ]
			then
			echo "DataBase name already exists!"
			fi
		fi
		select choice in "choose another name" "exit"
		do
		case $REPLY in
		1)clear
		isWrongInput=0
		TakeDBName
		checkNaming "$nameDB" 
		createDB
		break
		;;
		2) sleep .5      
		clear
		isWrongInput=0
		break
		;;
		*)
		sleep .5       
		clear
		echo "$REPLY is not the correct choice!"
		isWrongInput=1
		createDB 
		break
		;;
		esac
		done
	fi

}
TakeDBName
checkNaming "$nameDB" 
createDB 
