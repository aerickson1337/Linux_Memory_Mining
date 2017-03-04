#!/bin/bash
#========================================
#GDB processes: Gaining data
#By: Joshua Faust
#========================================


echo '------------------------------'
echo 'Process ID Data Required:     '
echo '------------------------------'
echo -n "What is the PID you are inquiring about: "; read PID
awk '{print $1,$6}' /proc/$PID/maps > "${PID}_maps"
clear #Clear data on screen
echo '---------------------------'
echo 'Starting Mining Processes  '
echo '---------------------------'
#
# Ask user if you would like to view the memory map segments of the processes they chose.
#
echo -n "Would you like to see PID $PID memory map? (y or n) "; read pidAnswer
if [ $pidAnswer == "y" ] || [ $pidAnswer == "Y" ] 
	then
	echo
	cat "${PID}_maps"
	else
	echo 'continuing to GDB session...'
	echo
fi
#
# Start of the GDB session:
#
echo -n "Are you ready to start a GDB session on $PID? (y or n) "; read mineAnswer
if [ $mineAnswer == "y" ] || [ $mineAnswer == "Y" ]
	then
	echo '--------------------------------------------------------------------------------'
	echo '                       Getting Register Information                             '
	echo ''
	echo 'To dump: dump [memory,binary,tekhex, verilog] FileLocation Memory Segment Range '
	echo 'To quit: quit'
	echo '--------------------------------------------------------------------------------'
	echo
	echo 
	gdb --pid $PID -ex 'info registers' # to add another command -ex command
	else
	echo
	echo 'closing program....'
fi
rm -rf PID.txt #remove the temp file created to hold the PID



