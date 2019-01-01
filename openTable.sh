#!/usr/bin/bash
function openTable {
 
    if [  -f $DB_Path/$tableName ] && [ $isEnter -eq 0 ] 
    then
	sleep 1 
	clear
    select choice in  "Insert" "Modify" "Display" "exit"
	do
	case $REPLY in
	1)clear
	isWrongInput=0
	. ./insert.sh
    openTable
	break
	;;
    2)
	isWrongInput=0
	checkEmpty $tableName
	if [ $isEmpty -eq 0 ]
	then
	clear
	. ./modifyTable.sh
    else 
      echo "$tableName is empty!"
    fi
    openTable
    
    break
    ;;
    3)
	clear
	checkEmpty $tableName
	if [ $isEmpty -eq 0 ]
	then
	. ./display.sh
	else 
	echo "$tableName is empty!"
	fi
	isWrongInput=0
    openTable
    break
    ;;
	4)
	clear
	isValid=1
	isWrongInput=0
	break 
	;;
    *)
	clear
	isWrongInput=1
	echo "$REPLY is not the correct choice!"
    openTable
    break    
    ;;
	esac
    done
    else
		if [ $isWrongInput -eq 0 ]
		then
        echo  "there is no table called $tableName!" 
		fi
		select choice in "choose another name" "exit"
		do
		case $REPLY in
		1)clear
		isWrongInput=0
		echo "Existing tables are:"
 		ls $DB_Path|grep -v "metaData"
		TakeTableName
		checkNaming $tableName
		openTable
		break
		;;
		2)clear
		isValid=1
		isWrongInput=0
		break
		;;
		*)
		clear
		isWrongInput=1
		echo "$REPLY is not the correct choice!"
		openTable
		break
		;;
		esac
		done
	fi
}
echo "Existing tables are:"
 ls $DB_Path|grep -v "metaData"
TakeTableName
checkNaming $tableName
openTable
sleep .5
