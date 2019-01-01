#!/usr/bin/bash
#create table
function deleteLines {
		read deleteValue
	       
		indexOfLine=1
		numberOfRowsDeleted=0
		stringOfDelete=''
		IFS=$'\n'
                fields=`cut -d: -f$indexOfField $DB_Path/"$1" 2> /dev/null` 
                
                checkNaming $deleteValue
		if [ $isEnter -eq 0 ] && [[ ! -z "$fields" ]] && [[ $fields == *"$deleteValue"* ]]
		then 
		for word in  $fields
			do
				if [[ $word =~ ^[0-9]+$ ]]
				then 
					if [ $word -eq $deleteValue ] 
					then 
					stringOfDelete+="$indexOfLine""d;"
					let numberOfRowsDeleted++
					fi
					let indexOfLine++
				else
					if [ $word == $deleteValue ]
					then
					stringOfDelete+="$indexOfLine""d;"
					let numberOfRowsDeleted++
					fi
					let indexOfLine++
				fi	
			done
			IFS=' '
		if [ stringOfDelete!='' ]
		then	
		sed -i  $stringOfDelete $DB_Path/$1 2>/dev/null
                fi
		else
		echo "value doesn't exist"
		#break
		fi
}
function editLines {
	awk -F: -v updateConditionField=$2 -v updateCondition=$3 -v updateField=$4 -v updateValue=$5 'BEGIN{OFS=FS}{if($updateConditionField==updateCondition){$updateField=updateValue};print $0}' $DB_Path/$1 > /tmp/temp
	rm $DB_Path/"$1"
	mv /tmp/temp $DB_Path/"$1"
}
function checkUpdateValue {
		if [ $isWrongInput -eq 0 ]
		then
			echo "Enter update value"
			read updateValue
			checkDataType $1 $updateValue # takes two variables indexOfField and updateValue
		fi
		if [ $dataTypeMatch -eq 0 ]
		then
			if [ $isWrongInput -eq 0 ]
			then
			echo "wrong entry for data type $dataTypeOfColumn"		
			fi
			select choice in "Enter another value" "exit"
			do
			case $REPLY in
			1)clear
			isWrongInput=0 
			checkUpdateValue $1
			break
			;;
			2)clear
			isValid=1
			isWrongInput=0 
			break
			;;
			*) clear
			isWrongInput=1
			echo "$REPLY is not the correct choice!" 
			checkUpdateValue $1 
			break
			esac
			done
		else
		editLines $1 $updateConditionField $updateCondition $updateField $updateValue	
		fi
}
function updateCell {
		echo "Enter column name to set update condition on"
		fieldOfColumn "$1"
        if [ $exitFlag -ne 1 ]
		then
		updateConditionField=$indexOfField
		echo "Enter update condition"
		read updateCondition
		echo "Enter column name to  update in"
		fieldOfColumn "$1"
        updateField=$indexOfField
		if [ $exitFlag -ne 1 ]
		then
			if [ $updateField -eq 1 ] # prevent edit in pk
			then
				echo "can't update primary key"
				sleep .5
				clear
			else	
				checkUpdateValue "$1" 
			fi
		else
		break
		fi	
		else
		break
		fi
		


             
         
}

function deleteRow {
		echo "Enter column name to set delete condition on"
		fieldOfColumn "$1"
		if [ $exitFlag -ne 1 ]
		then
		echo "Enter value to use as base for delete"
		deleteLines "$1"
		echo "number of deleted rows is $numberOfRowsDeleted"
		sleep .5
		clear
		fi
               
}

function modifyTable {

    select choice in "delete row" "edit cell" "exit"
	do
	case $REPLY in
	1)clear
	isWrongInput=0
	deleteRow "$tableName"
	modifyTable
	break
	;;
	2) clear
	isWrongInput=0
	updateCell "$tableName"
	modifyTable
	break
	;;
	3)clear
	isValid=1
	isWrongInput=0
	break
	;;
	*)   
	clear
	isWrongInput=1
	echo "$REPLY is not the correct choice!" 
	modifyTable 
	break
	esac
	done
}
modifyTable 
