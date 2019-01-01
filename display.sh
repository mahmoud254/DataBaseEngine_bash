#!/usr/bin/bash
function header {

	tableLine=`grep  ^"$tableName"/ $DB_Path/metaData`
	IFS='/' 
	indexOfField_header=0
	headerString=''
	for field in $tableLine #problem of table name
	do
		IFS=' '
		if [ $indexOfField_header -ne 0 ]
		then
			columnName=`echo $field|cut -d: -f 1`
			if [ $indexOfField_header -eq 1 ]
			then
			headerString+=$columnName
			else
			headerString+=":"$columnName
			fi
		fi
		let indexOfField_header++
	done
	echo $headerString	
}

function displayTable {
 
          header
          cat $DB_Path/$1
}
function printLines {
		indexOfLine=1
		stringOfPrint=''
		IFS=$'\n'
		for word in `cut -d: -f$indexOfField $DB_Path/$1 2> /dev/null` 
			do
				if [[ $word =~ ^[0-9]+$ ]]
				then 
					if [ $word -eq $printValue ]
					then
					stringOfPrint+="$indexOfLine""p;"
					fi
					let indexOfLine++
				else
					if [ $word == $printValue ]
					then
					stringOfPrint+="$indexOfLine""p;"
					fi
					let indexOfLine++
				fi	
			done
			IFS=' '

		if [ stringOfPrint!='' ]
		then	
		sed -n  "$stringOfPrint" $DB_Path/"$1"
		else
		echo "value doesn't exist"
		break
		fi
}


function displayRows {
		echo "Enter column name to set display condition on"
		fieldOfColumn "$1"
		if [ $exitFlag -ne 1 ]
		then
			echo "Enter value to use as base for display"
			read printValue
			header
			printLines  $1 
		fi	
}


function display {
	select choice in "display table" "display rows" "exit"
	do
	case $REPLY in
	1)clear
	isWrongInput=0
	displayTable "$tableName"
	sleep 2
	display
	break
	;;
	2) clear
	isWrongInput=0
	displayRows "$tableName"
	sleep 2
	display
	break
	;;
	3)clear
	isValid=1
	isWrongInput=0
	break
	;;
	*)clear 
	isWrongInput=1
	echo "$REPLY is not the correct choice!"
	display
	break
	esac
	done
}
display 

