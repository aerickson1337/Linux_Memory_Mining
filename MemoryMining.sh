#!/bin/bash

#==================================================
#Mine primary memory segments for data
#By: Joshua Faust
#==================================================


#Check if root
if [ $(whoami) != "root" ]
        then
        echo 'You are not root, you may not be able to fully utilize this program. Continue? (y|n)'; read continue
        if [ $continue == "y" ] || [ $continue == "Y" ]
                then
                echo 'Continuing'
        else
                echo "Closing the Program."
                exit 0
        fi
fi

echo '============================================'
echo '           Primary Memory Miner             '
echo '============================================'
echo '' 
echo ''
echo '-------------------------------------------'
echo '    All data gathered will be stored in    '
echo '     mining_out_data Directory unless      '
echo '     specified otherwise by the user       '
echo '-------------------------------------------'
#Create a directory to store output data in
mkdir mining_output_data 
cd mining_output_data

#Obtain Processes Data for the user:
ps -aux | awk '{print $1,$2,$11}' > all_processes.txt
ps -u $USER > user_processes.txt
echo ''

#Have the user select which PID they would like to mine:
echo -n "Would you like to see current running Processes PID's?(y or n) "; read PID
clear
if [ $PID == "y" ] || [ $PID == "Y" ]
	then
	echo '-----------------------'
	echo '     All Processes:    '
	echo '-----------------------'
	cat all_processes.txt
	echo '------------------------------'
	echo '     User Level Processes:    '
	echo '------------------------------'
	cat user_processes.txt
	echo ''
	echo '----------------------------------------'
	echo ''
	echo -n 'Write down the PID! Are you ready to continue? (y|n) '; read answer
	clear
	loop=y
	while [ $loop == "y" ]
	do
	tput cup 2 10; echo 'GDB Memory Mining Menu'
	tput cup 3 10; echo '----------------------'
	tput cup 5 8; echo "M - Mine the Stack or Heap"
	tput cup 6 8; echo "F - Edit memory Flags"
 	tput cup 7 8; echo "A - Append data to memory address"
  	tput cup 10 8; echo "Q - Quit"
 	read choice || continue
  	case $choice in
    		[Mm]) /home/josh/Linux_Memory_Mining/subScripts/gdb_mine.sh ;;
    		[Ff]) /home/josh/Linux_Memory_Mining/subScripts/FlagChanger ;;
    		[Aa]) echo 'BASH sccript will be called here' ;;
    		[Qq]) exit ;;
    		*) tput cup 12 6; echo "wrong code"; read choice ;;
 		esac
	echo -n 'Would you like to continue? (y|n) '; read loop
	clear
	done
	else
	 loop=y
        while [ $loop == "y" ]
        do
        tput cup 2 10; echo 'GDB Memory Mining Menu'
        tput cup 3 10; echo '----------------------'
        tput cup 5 8; echo "M - Mine the Stack or Heap"
        tput cup 6 8; echo "F - Edit memory Flags"
        tput cup 7 8; echo "A - Append data to memory address"
        tput cup 10 8; echo "Q - Quit"
        read choice || continue
        case $choice in
                [Mm]) /home/josh/Linux_Memory_Mining/subScripts/gdb_mine.sh ;;
                [Ff]) /home/josh/Linux_Memory_Mining/subScripts/FlagChanger ;;
                [Aa]) echo 'BASH sccript will be called here' ;;
                [Qq]) exit ;;
                *) tput cup 12 6; echo "wrong code"; read choice ;;
                esac
        echo -n 'Would you like to continue? (y|n) '; read loop
        clear
	done

fi
exit 0

