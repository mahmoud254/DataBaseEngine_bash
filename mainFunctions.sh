#!/usr/bin/bash
function TakeDBName {
   echo "please enter database name?!"
   read nameDB
   DB_Path=$HOME/dataBase/"$nameDB"
}
function TakeTableName {
   echo "please enter table name?!"
   read tableName
}
function TakeColumnName {
   echo "please enter column name?!"
   read columnName
}
function checkEmpty
{
    isEmpty=0
    empty=`cat $DB_Path/"$1" 2> /dev/null`
    if [ -z "$empty" ]
    then
    isEmpty=1
    fi

}
function checkNaming
{
        isEnter=0
        isValid=0
        regex='^[a-z|A-Z][0-9|a-z|A-Z|_|\d]*$'
	if [[ "$1" = "" ]]
	then
		isEnter=1
	else		
			if  [[ $1 =~ $regex ]] 
			then
				isValid=1
			else
			isValid=0	
			fi
	fi
}
function checkDataType {
	tableLine=`grep ^"$1"/ $DB_Path/metaData`
	let metaDataFieldIndex=$indexOfField+1
	dataTypeOfColumn=`echo $tableLine|cut -d/ -f$metaDataFieldIndex|cut -d: -f2`
	isUnique=0
	if [ $dataTypeOfColumn == int ] #int
	then
		if [[ $2 =~ ^[0-9]+$ ]] || [ $2 == "" ]
		then
			if [ $indexOfField -eq 1 ] # check for uniqueness
			then
				if [[ $2 =~ ^[0-9]+$ ]] 
				then
				isUnique=`cat $DB_Path/"$1"|cut -d: -f1|grep -w $2|wc -l`
				else
				isUnique=1
				fi
			fi
		dataTypeMatch=1 #match
		else
		dataTypeMatch=0 #string
		fi
	else #string
		if [[ $2 =~ ^[0-9]+$ ]] || [[ $2 =~ .*":".* ]]
		then
		dataTypeMatch=0 #int
		else
			if [ $indexOfField -eq 1 ]
			then
			isUnique=`cat $DB_Path/"$1"|cut -d: -f1|grep -w "$2"|wc -l`
			fi
		dataTypeMatch=1 #match
		fi
	fi

}
function fieldOfColumn {
	exitFlag=0
		if [ $isWrongInput -eq 0 ]
		then
			read columnName
			checkNaming $columnName
			columnExist=`grep  ^"$1"/ $DB_Path/metaData 2> /dev/null|grep -w "$columnName" 2> /dev/null|wc -l` 
        fi
		if [ $isValid -eq 1 ] && [ $isEnter -eq 0 ] && [ ! $columnExist -eq 0 ] 
        then 
		tableLine=`grep  ^"$1"/ $DB_Path/metaData`
		IFS='/' 
		indexOfField=0
		for field in $tableLine #problem of table name solved
		do
			IFS=' '	
			if [ $indexOfField -ne 0 ]

			then
				if [ `echo $field|grep -w "$columnName" |wc -l` -ne 0 ]
				then
				break
				fi
			fi
			let indexOfField++	
		done
          
	else
		if [ $isWrongInput -eq 0 ]
		then
		echo "column doesn't exist or wrong input!"
		fi
		select choice in "choose another name" "exit"
		do
		case $REPLY in
		1)clear
		isWrongInput=0 
		fieldOfColumn "$1"
		break
		;;
		2)clear
		exitFlag=1 
		isWrongInput=0
		isValid=1
		break
		;;
		*)clear 
		isWrongInput=1
		echo "$REPLY is not the correct choice!" 
		fieldOfColumn "$1"
		break
		esac
		done
        
	fi
		
		return $indexOfField

}
function getraw {
        typeset -i counter=1
	typeset keys=`cut -d/ -f1 $DB_Path/metaData`
        for key in $keys
        do
                if [ $1 == $key ]
                then
                        rowNum=$counter
                        break
                fi
                ((counter=counter+1))
        done

}