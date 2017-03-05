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

# Grab the heap memory address for the PID
heapAddress=`cat /proc/$PID/maps | grep heap | awk '{print $1}'` #Grab the HEAP address in memory
heapAddressRemove=${heapAddress/-/" 0x"} #reove the -, add 0x to denote a hex address for GDB
heapAddressFinal= echo "$heapAddressRemove" | awk '$0="0x"$0' #adds a 0x to the from of the mem address to denote a hex address
# Grab the stack memory address for the PID
stackAddress=`cat /proc/$PID/maps | grep stack | awk '{print $1}'` #Grab the STASCK address in memory
stackAddressRemove=${stackAddress/-/" 0x"} #remove the - in the memory address for GDB
stackAddressFinal= echo "$stackAddressRemove" | awk '$0="0x"$0' # adds a 0x to the front of the memory address to denote a hex addess
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
	echo Heap Address: $heapAddressFinal
	echo Stack Address: $stackAddressFinal
	echo '--------------------------------------------------------------------------------'
	echo
	echo -n 'Would you like to dump the stack or the heap? '; read dump
	if [ $dump == "heap" ] || [ $dump == "Heap" ]
		then
		gdb --pid $PID -ex 'dump memory HeapDump.hex $heapAddressFinal' # to add another command -ex command
		echo 'Data dumped to HeapDump.hex'
	elif [ $dump == "stack" ] || [ $dump == "Stack" ]
		then
		gdb --pid $PID -ex 'dump memory StackDump.hex $stackAddressFinal' 
		echo 'Data dumped to StackDump.hex'
	fi
else
	echo
	echo 'closing program....'
	exit 1
fi
rm -rf PID.txt #remove the temp file created to hold the PID



