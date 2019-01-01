#!/usr/bin/bash 
function checkInsertedValue {
	if [  $isWrongInput -eq 0 ]
	then
		echo "please enter value for column $columnName"
		read value
		checkDataType $1 $value # takes two variables indexOfField and value
	fi	
	if [ $dataTypeMatch -eq 0 ] || [ $isUnique -ne 0 ]
	then
		if [  $isWrongInput -eq 0 ]
		then
			if [ $isUnique -ne 0 ]
			then
				echo "repeated or null value for primary key!"
			else	
				echo "wrong entry for data type $dataTypeOfColumn"	
			fi
		fi	
		select choice in "Enter another value" "exit"
		do
		case $REPLY in
		1)clear 
		isWrongInput=0
        checkInsertedValue $1
		break
		;;
		2)clear
		isValid=1
		isWrongInput=0
		toBeInserted=0
		break
		;;
		*)clear 
		isWrongInput=1
        echo "$REPLY is not the correct choice!" 
		checkInsertedValue $1
		break
		esac
		done
	else
		if [ $indexOfField -eq 1 ]
		then
			insertString+=$value #remember the problem of writting before checking(may be better append in string then write it one time)
		else
			insertString+=":$value" 
		fi
	fi
}
function insert {

	tableLine=`grep  ^"$tableName"/ $DB_Path/metaData`
	IFS='/' 
	indexOfField=0
	insertString=''
	toBeInserted=1
	for field in $tableLine #problem of table name
	do
		IFS=' '
		if [ $indexOfField -ne 0 ]
		then
			columnName=`echo $field|cut -d: -f 1`
			dataTypeOfColumn=`echo $field|cut -d: -f 2`
			checkInsertedValue "$tableName"
			if [ $toBeInserted -eq 0 ]
			then
			break
			fi
		fi
		let indexOfField++
	done
	if [ $toBeInserted -eq 1 ]
		then
		echo $insertString >> $DB_Path/"$tableName"
	fi
}
insert


