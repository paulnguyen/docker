#!/bin/sh

OPT=""
while [ "$OPT" != "X" ]  
do
	clear
	echo ""
	echo "============="
	echo "   M E N U   "
	echo "============="
	echo "> $OPT"
	echo " "
	echo "[1] Login to Docker         "
	echo "[2] Install/Update Connector"
	echo "[3] Configure Appthority    "
	echo "[4] Configure EMM Settings  " 
	echo " "
	echo "[X] Exit Menu               " 
	echo " "
	echo "Selection: "
	read OPT OPT1 OPT3
	case $OPT in
		l|L) echo " "; docker images; echo " "; echo "[Okay]"; read ans ;;
		x|X) clear; OPT="X"; echo "Exiting..." ;; 
	esac
done
