#!/usr/bin/bash
#delete database
isWrongInput=0
function deleteDatabase {

    if [ -d $HOME/dataBase/"$nameDB" ] && [ $isValid -eq 1 ]
    then
	rm -r $DB_Path	
	echo "database deleted"
	else
		if [ $isWrongInput -eq 0 ]
		then
	    	echo "there is no dataBase called "$nameDB" "
		fi	
		select choice in "choose another name" "exit"
		do
		case $REPLY in
		1)
		clear
		isWrongInput=0
		echo "Existing Databases are:"
    	ls $HOME/dataBase
        TakeDBName
		checkNaming "$nameDB" 
        deleteDatabase
		break
		;;
		2)clear
		isWrongInput=0
		break
		;;
		*)
		sleep 1
		clear
		echo "$REPLY is not the correct choice!"
		isWrongInput=1
		deleteDatabase
		break
		;;
		esac
		done
        fi
}
echo "Existing Databases are:"
ls $HOME/dataBase
TakeDBName
checkNaming "$nameDB" 
deleteDatabase


