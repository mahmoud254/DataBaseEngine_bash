#!/usr/bin/bash 

function deleteTable {
	if [  -f $DB_Path/"$tableName" ] && [ $isValid -eq 1 ]
	then
        rm $DB_Path/"$tableName"
        getraw "$tableName" #call getway function to get number of row u want delete it
        row_num=$rowNum 
        if [ $row_num ]
        then
        sed -i $row_num'd' $DB_Path/metaData #sed want no of row u want delete 
        fi
        echo "table deleted successfuly"
	else
        if [ $isWrongInput -eq 0 ]
	then
        echo "there is no table called "$tableName""
	fi
        select choice in "choose another name" "exit"
	do
	case $REPLY in
	1)clear 
        echo "Existing tables are:"
        ls $DB_Path|grep -v "metaData"
        isWrongInput=0
        TakeTableName
        checkNaming "$tableName"
        deleteTable 
	break
	;;
	2)clear 
        isWrongInput=0
        isValid=1
        break
	;;
        *) clear
        echo "$REPLY is not the correct choice!"
        isWrongInput=1
        deleteTable
        break
        ;;
	esac
	done
	fi
}
echo "Existing tables are:"
 ls $DB_Path|grep -v "metaData"
TakeTableName
checkNaming "$tableName"
deleteTable 


