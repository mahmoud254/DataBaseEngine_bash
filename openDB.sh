#!/usr/bin/bash
isWrongInput=0
function openDB { 
    clear
    if [ -d $HOME/dataBase/"$nameDB" ] && [ $isValid -eq 1 ]
    then 
    select choice in  "creat table" "open table" "Delete table" "exit"
        do
        case $REPLY in
        1)clear
        isWrongInput=0
        . ./createTable.sh 
        openDB
        break
        ;;
        2)clear
        isWrongInput=0
        . ./openTable.sh
        openDB
        break
        ;;
        3)
        clear
        isWrongInput=0
        . ./deleteTables.sh
        openDB
        break
        ;;
        4)clear 
        isWrongInput=0
        break
        ;;
        *)
        clear
        isWrongInput=1
        echo "$REPLY is not the correct choice!"
        openDB
        break
        ;;
        esac
        done
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
        echo "Existing Databases are:"
        ls $HOME/dataBase
        isWrongInput=0
        TakeDBName
        checkNaming "$nameDB" 
        openDB
		break
		;;
		2)
        clear
        isWrongInput=0
        break
		;;
		*)
        clear
         echo "$REPLY is not the correct choice!"
         isWrongInput=1
         openDB
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
openDB