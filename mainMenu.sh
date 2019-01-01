#!/usr/bin/bash 
PS3="Select Choice please: "
. ./mainFunctions.sh
if [ ! -d $HOME/dataBase ]
then
mkdir $HOME/dataBase 
fi
function main {
sleep .5    
clear
select choice in  "creat DB" "open DB" "Delete DB" "man page" "exit"
	do
	case $REPLY in
	1) clear
    sleep .5
    . ./createDB.sh  
    main
	break
	;;
    2)clear
    sleep.5
    . ./openDB.sh 
    main
    break
    ;;
    3)clear
    sleep .5
    . ./deleteDB.sh
       main 
       break
    ;;
     4)clear
        man ./manPage.sh
        main 
        break
       ;;
	5) break
	;;
    *) clear
    echo "$REPLY is not the correct choice!"
    sleep .5
    main
    ;;
	esac
    done
}
#clear
main
