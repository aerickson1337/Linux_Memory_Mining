#!/bin/bash
echo -n "What is the PID you want? "; read PID
stackAddress=`cat /proc/$PID/maps | grep stack | awk '{print $1}'` #Grab the $
stackAddressRemove=${stackAddress/-/" 0x"} #remove the - in the memory addres$
stackAddressFinal= echo "$stackAddressRemove" | awk '$0="0x"$0'
echo $stackAddressFinal

