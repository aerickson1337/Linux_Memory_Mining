#!/bin/bash

#==================================================
#Mine primary memory segments for data
#By: Joshua Faust
#==================================================

echo '============================================'
echo '           Primary Memory Miner             '
echo '============================================'
echo 
echo '-------------------------------------------'
echo ' Creating directory to store process dump  '
echo '-------------------------------------------'
echo '    All data gathered will be stored in    '
echo '     mining_out_data Directory unless      '
echo '     specified otherwise by the user       '
echo '-------------------------------------------'
mkdir mining_output_data 
cd mining_output_data
ps -aux | awk '{print $1,$2,$11}' > all_processes.txt #Obtain all processes from all users
ps -u $USER > user_processes.txt #Obtain user level processes
echo 
echo -n "Would you like to see current running Processes PID's?(y or n) "; read PID
clear # clear the screen
echo '------------------------------------------'
echo '       Current Running Processes:         '
echo '------------------------------------------'
echo
if [ $PID == "y" ] || [ $PID == "Y" ]
	then
	echo '-----------------------'
	echo 'Showing All Processes: '
	echo '-----------------------'
	cat all_processes.txt
	echo '------------------------------'
	echo 'Showing User Level Processes: '
	echo '------------------------------'
	cat user_processes.txt
	echo '----------------------------------------'
	echo
	#Call the mining script:
	/home/josh/Linux_Memory_Mining/subScripts/gdb_mine.sh
	else
	echo '-----------------------------'
	echo 'Starting Mining Processes    '
	echo '-----------------------------'
	echo
	#Call the mining script:
	/home/josh/Linux_Memory_Mining/subScripts/gdb_mine.sh

fi
exit 0

