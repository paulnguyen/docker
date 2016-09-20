#!/bin/sh

# Container

ACCOUNT=""
CONTAINER="helloworld"
VERSION="latest"

# Shell Variables

OPT=""
DEBUG="TRUE"
AUTH="FALSE"
XMENU="N"

## Set Echo Command Flavor

PROMPT=""
OS=`uname -a | cut -f1 -d" "`
if [ "$OS" = "Darwin" ] ; then
    PROMPT="echo"
else
    PROMPT="echo -e"
fi ;

#
# Shell Functions 
# for Menu Operations
#

docker_auth () { 
   $PROMPT "Docker Userid:   \c" ; read user ;
   $PROMPT "Docker Password: \c" ; read -s pass ; 
   echo "" ;
   docker login -u $user -p $pass
   TMP=`cat ~/.docker/config.json | grep  \"auth\": | wc -l | sed -e 's/^[ \t]*//'`
   #echo ".${TMP}."
   if [ "$TMP" == "1" ] ; 
   then 
   		AUTH="TRUE" ; 
   		ACCOUNT=$user ;
   else 
   		AUTH="FALSE"; 
   fi ; 
}

docker_pull() {
	if [ "$AUTH" != "TRUE" ] ; 
    then echo "Login Required!" ; 
    else 
    	docker pull -a $ACCOUNT/$CONTAINER ; 
    	#docker pull $ACCOUNT/$CONTAINER:$VERSION ; 
    fi ; 
}

docker_build() {
	if [ "$AUTH" != "TRUE" ] ; 
    then echo "Login Required!" ; 
    else 
  		$PROMPT "New Version:   \c" ; read newver ;
  		echo "Publishing Version: $newver"
 	  	docker build -t $ACCOUNT/$CONTAINER:$newver .
    fi ; 
}

docker_release() {
	if [ "$AUTH" != "TRUE" ] ; 
    then echo "Login Required!" ; 
    else 
  		echo "Building Versions: latest and $VERSION"
 	  	docker build -t $ACCOUNT/$CONTAINER:latest -t $ACCOUNT/$CONTAINER:$VERSION .
 	  	echo "Pushing Builds to Docker Hub"
 	  	docker push $ACCOUNT/$CONTAINER:latest ; 
 	  	docker push $ACCOUNT/$CONTAINER:$VERSION ; 
    fi ; 
}

docker_push() { 
	if [ "$AUTH" != "TRUE" ] ; 
    then echo "Login Required!" ; 
    else 
		docker push $ACCOUNT/$CONTAINER:$VERSION ; 
    fi ; 
}

docker_run() { 
	if [ "$AUTH" != "TRUE" ] ; 
    then echo "Login Required!" ; 
    else 
		docker run $ACCOUNT/$CONTAINER:$VERSION ; 
    fi ; 
}

docker_restart () {
	docker restart $ACCOUNT/$CONTAINER:$VERSION
}

docker_images() {
	docker images
}

docker_rmi() {
	IMG_ID=`docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}" | grep $ACCOUNT/$CONTAINER | tr -s ' ' | tr ' ' '|' | cut -f 1 -d '|' | head -1`
	while [ "$IMG_ID" != "" ]
	do
		echo "Removing Image: $IMG_ID"
 		docker rmi -f $IMG_ID
		IMG_ID=`docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}" | grep $ACCOUNT/$CONTAINER | tr -s ' ' | tr ' ' '|' | cut -f 1 -d '|' | head -1`
	done
}

docker_rmi_all() {
	IMG_ID=`docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}" | tr -s ' ' | tr ' ' '|' | cut -f 1 -d '|' | tail -n +2 | head -1`
	while [ "$IMG_ID" != "" ]
	do
		echo "Removing Image: $IMG_ID"
 		docker rmi -f $IMG_ID
		IMG_ID=`docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}" | tr -s ' ' | tr ' ' '|' | cut -f 1 -d '|' | tail -n +2 | head -1`
	done
}


docker_ps() {
	echo "Running Containers:"
	echo " "
	docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t"
}

docker_restart() {
	docker restart $ACCOUNT/$CONTAINER:$VERSION
}

docker_stop() {
	docker stop $ACCOUNT/$CONTAINER:$VERSION
}

docker_cmd () {
  	$PROMPT "CMD: \c" ; read cmd ;	
  	echo $cmd
	docker exec -it $ACCOUNT/$CONTAINER:$VERSION $cmd
}

docker_install() {
	if [ "$AUTH" != "TRUE" ] ; 
    then echo "Login Required!" ; 
    else 
        docker_uninstall
        docker_rmi
        docker_pull
        docker_run
    fi ; 
}

docker_uninstall() {
	if [ "$AUTH" != "TRUE" ] ; 
    then echo "Login Required!" ; 
    else 
		docker stop $ACCOUNT/$CONTAINER:$VERSION
		docker rm $ACCOUNT/$CONTAINER:$VERSION
    fi ; 
}

set_version() {
  	$PROMPT "Set Container Version: \c" ; read VERSION ;
 }

set_account() {
  	$PROMPT "Set Container Account: \c" ; read ACCOUNT ;
 }

okay_pause() {
	$PROMPT "\n[Okay] \c"; 
	read ans ; 
}


##
## MAIN MENU LOOP
##

while [ "$OPT" != "X" ]  
do
	clear
	echo ""
	echo "==========================================="
	echo "          D O C K E R   M E N U            "
	echo "==========================================="
	echo "> Container: $ACCOUNT/$CONTAINER:$VERSION  "
	echo " "
	echo "[1] login      - Login to Docker           " ;
	echo "[2] images     - Show Docker Images        " ;
	echo "[3] pull       - Pull Container Image      " ;
	echo "[4] run        - Run Container             " ;
	echo "[5] build      - Build Container Image     " ;
	echo "[6] push       - Push Build to Docker Hub  " ;
	echo "[7] ps         - Show Running Containers   " ;
	echo "[8] rmi        - Remove Container Image    " ;
	echo "[9] release    - Build Latest Version      " ;	
	if [ "$XMENU" = "N" ] ; then
		echo " "
		echo "[+] More Options                       " ;
	else
		echo " "
		echo "[i] install    - Install Container Image   " ;
		echo "[u] uninstall  - Remove Container Image    " ;
		echo "[r] restart    - Restart Container         " ;
		echo "[k] kill       - Stop Running Container    " ;
		echo "[s] shell      - Enter Container Shell     " ;
		echo "[d] delete     - Remove Local Images       " ;
		echo "[v] version    - Set Container Version     " ;
		echo "[a] account    - Set Container Account     " ;
		echo " " 
		echo "[-] Fewer Options                          " ;		
	fi ;
	echo "[X] Exit Menu                              " ;
	echo " "
	$PROMPT "Selection: \c"
	read OPT OPT1 OPT2
	case $OPT in
		1|login)		echo " " ; docker_auth ; 		okay_pause ;;
		2|images)	    echo " " ; docker_images ; 		okay_pause ;;
		3|pull)			echo " " ; docker_pull ; 		okay_pause ;;
		4|run) 			echo " " ; docker_run ; 		okay_pause ;;
		5|build)		echo " " ; docker_build ; 		okay_pause ;;
		6|push) 		echo " " ; docker_push ; 		okay_pause ;;
		7|ps) 			echo " " ; docker_ps ; 			okay_pause ;;
		8|rmi) 			echo " " ; docker_rmi ; 		okay_pause ;;
		9|release)		echo " " ; docker_release ;		okay_pause ;;
		i|I|install) 	echo " " ; docker_install ; 	okay_pause ;;
		u|U|uninstall)	echo " " ; docker_uninstall ; 	okay_pause ;;
		r|R|restart) 	echo " " ; docker_restart ; 	echo "Connector Instance Restarted!" ; okay_pause ;;
		k|K|kill) 		echo " " ; docker_stop ; 		echo "Connector Instance Stopped!" ; okay_pause ;;
		d|D|delete) 	echo " " ; docker_rmi_all ; 	okay_pause ;;
		v|V|version) 	echo " " ; set_version ; 		okay_pause ;;
		a|A|account) 	echo " " ; set_account ; 		okay_pause ;;
        debug)          echo " " ; if [ "$OPT1" = "" -o "$OPT1" = "on" ] ; then DEBUG="TRUE" ; echo "Debug ON" ; 
								   else DEBUG="FALSE" ; echo "Debug OFF" ; fi ; okay_pause ;;
		s|S|shell)		clear ; docker exec -it $ACCOUNT/$CONTAINER:$VERSION bash ; ;;
 		+)				XMENU="Y" ;;
		-)				XMENU="N" ;;
		x|X) 			clear ; OPT="X" ; echo "Exiting " ;; 
	esac
done

