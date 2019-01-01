#!/usr/bin/bash
#create table
# nameDB="mahmoud" #exported from open
 #exported from open

function chooseDataType {
	select choice in "int" "str"
	do
	case $REPLY in
	1)clear 
	isWrongInput=0
	echo -n ":int" >> $DB_Path/metaData
	break
	;;
	2)clear 
	isWrongInput=0
	echo -n ":str" >> $DB_Path/metaData
	break	
	;;
	*)clear
	isWrongInput=1
	echo "$REPLY is not the correct choice!" 
	chooseDataType
	break
	esac
	done
}
function addColumn {
	
	columnExist=`grep  ^"$tableName"/ $DB_Path/metaData|grep -w "$columnName"|wc -l` # we should check only in the first field
	if [ $columnExist -eq 0 ] && [ $isValid -eq 1 ]
	then
		echo -n "/$columnName" >> $DB_Path/metaData
		chooseDataType
		let columnNum+=1	
	else
	if [ $isWrongInput -eq 0 ]
	then
		if [ $isValid -eq 1 ]
		then
			echo "column already exists!"
		else
			echo "invalid column name!"
		fi
	fi		
	select choice in "choose another name" "exit"
	do
	case $REPLY in
	1)clear 
	isWrongInput=0
	TakeColumnName
	checkNaming $columnName
	addColumn 
	break
	;;
	2)clear
	isWrongInput=0
	isValid=1
	break
	;;
	*)
	clear
	isWrongInput=1
	echo "$REPLY is not the correct choice!" 
	addColumn
	break
	esac
	done
	fi
}
function fillTable {
	if [ $columnNum -eq 1 ]
	then
	echo "Enter primary key column name"
	read columnName
	checkNaming $columnName
	addColumn
	fi
	if [ $columnNum -ne 1 ]
	then	
	while true
	do
	echo "1) add column" 
	echo "2) exit"
	read
	case $REPLY in
	1)clear 
	isWrongInput=0
	TakeColumnName
	checkNaming $columnName
	addColumn 
	fillTable
	break
	;;
	2)
    clear
	ed -s $DB_Path/metaData <<< w
	isWrongInput=0
	isValid=1
	break
	;;
	*)
	clear
	isWrongInput=1
	echo "$REPLY is not the correct choice!" 
	fillTable
	break
	esac
	done

	else
	rm $DB_Path/"$tableName"
	getraw "$tableName" #call getway function to get number of row u want delete it
	row_num=$rowNum 
	if [ $row_num ]
	then
	sed -i $row_num'd' $DB_Path/metaData #sed want no of row u want delete 
	fi
	echo "table can't be created without primary key"
	sleep 1
	break
	fi
}
function createTable {
	if [ ! -f $DB_Path/"$tableName" ] && [ $isValid -eq 1 ]
	then
	touch $DB_Path/"$tableName"
	echo -n "$tableName" >> $DB_Path/metaData
	columnNum=1	
	fillTable
	ed -s $DB_Path/metaData <<< w
	echo "table created"
	else
	if [ $isWrongInput -eq 0 ]
	then
		if [ $isValid -eq 1 ]
		then
			echo "table already exists!"
		else
			echo "invalid table name!"
		fi	
	fi	
	select choice in "choose another name" "exit"
	do
	case $REPLY in
	1)clear
	isWrongInput=0
	TakeTableName
	checkNaming "$tableName"
	createTable 
	break
	;;
	2)clear
	isWrongInput=0
	isValid=1
	break
	;;
	*)clear
	echo "$REPLY is not the correct choice!"
	isWrongInput=1
	createTable
	break
	esac
	done
	fi
}

TakeTableName
checkNaming "$tableName"
createTable 


