#!/bin/sh
#
#  =========================================
#           APPTHORITY EMM CONNECTOR        
#  =========================================
#  > Instance: PROD
#   
#  [1] key        - Set Install Key                 
#  [2] appthority - Configure Appthority            
#  [3] emm        - Configure EMM Settings          
#  [4] install    - Install/Upgrade Connector       
#  [5] test       - Test Connector Config           
#   
#  [+] More Options                             
#  [X] Exit Menu                    
#
#  Copyright (c) 2017 - Appthority, Inc.
#

# Shell Variables
OPT=""
VERSION="1.3.1"
DEBUG="FALSE"
AUTH="FALSE"
VALID="FALSE"
XMENU="N"
HAS_AT_PROXY="FALSE"
HAS_EMM_PROXY="FALSE"
BASE="$HOME/.appthority"

# Default Instance (Default PROD)
INSTANCE="PROD"
FILE="$BASE/$INSTANCE/connector.config"
CONTAINER="appthority-$INSTANCE"
DEFAULT_IMAGE="mtp"
VERBOSE_LOGGING="false"

# Docker Mount Points
MNT_OSX_DESKTOP=""
MNT_BULK_API=""
MNT_BULK_FOLDER=""
MNT_SSL_CERTS=""

# Config Variables (With Defaults)
EMM_SSL_VERIFICATION=""
CA_CERTS_DEFAULT="/etc/pki/tls/certs/ca-bundle.crt"
CA_CERTS="$CA_CERTS_DEFAULT"
AUTH_USER="appthoritydocker"
RAILS_ENV="production"
EMM_DEPLOYED=""
EMM_TIMEOUT=""
EMM_DELAY=""
EMM_PROVIDER=""
EMM_DOMAIN=""
EMM_USER=""
EMM_USERNAME=""
EMM_PASSWORD=""
EMM_URL=""
EMM_API_TOKEN=""
EMM_API_VERSION="1"
EMM_API_ROLE=""
AT_ORG_ID=""
AT_USERNAME=""
AT_PASSWORD=""
AT_AUTH_TOKEN=""
AT_PROXY_ADDR=""
AT_PROXY_PORT=""
AT_PROXY_USR=""
AT_PROXY_PWD=""
EMM_PROXY_ADDR=""
EMM_PROXY_PORT=""
EMM_PROXY_USR=""
EMM_PROXY_PWD=""
HOST_ENTRY_1=""
HOST_ENTRY_2=""


## EMM Config Reset
emm_reset () {
    EMM_PROVIDER=""
    EMM_USERNAME=""
    EMM_PASSWORD=""
    EMM_URL=""
    EMM_API_TOKEN=""
    EMM_API_VERSION="1"
    EMM_PROXY_ADDR=""
    EMM_PROXY_PORT=""
    EMM_PROXY_USR=""
    EMM_PROXY_PWD=""    
}

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

update_instance_name () {
    FILE="$BASE/$INSTANCE/connector.config"
    CONTAINER="appthority-$INSTANCE"
    mkdir -p "$BASE/$INSTANCE"
    touch $FILE
    chmod go-r $FILE
}


config_view () {
    clear
    echo " "
    echo "========================================="
    echo "   APPTHORITY CONNECTOR  CONFIGURATION   "
    echo "========================================="
    echo " "
    echo "Connector Instance:          $INSTANCE"
    echo "Container Version:           $IMAGE"
    echo "Authenticated:               $AUTH"
    echo "Appthority Environment:      $RAILS_ENV"
    echo "Appthority Org ID:           $AT_ORG_ID"
    echo "Appthority Auth Token:       $AT_AUTH_TOKEN"
    echo "Appthority Proxy Host:       $AT_PROXY_ADDR"
    echo "Appthority Proxy Port:       $AT_PROXY_PORT"
    echo "Appthority Proxy Username:   $AT_PROXY_USR"
    if [ "$AT_PROXY_PWD" = "" ] ; 
    then
        echo "Appthority Proxy Password:   $AT_PROXY_PWD"
    else
        echo "Appthority Proxy Password:   *******"
    fi
    echo "EMM Provider:                $EMM_PROVIDER"
    echo "EMM Username:                $EMM_USERNAME"
    if [ "$EMM_PASSWORD" = "" ] ; 
    then
        echo "EMM Password:                $EMM_PASSWORD"
    else
        echo "EMM Password:                *******"
    fi
    echo "EMM URL:                     $EMM_URL"
    echo "EMM API Token:               $EMM_API_TOKEN"
    echo "EMM API Version:             $EMM_API_VERSION"
    #echo "EMM API Role:                $EMM_API_ROLE"
    echo "EMM Proxy Host:              $EMM_PROXY_ADDR"
    echo "EMM Proxy Port:              $EMM_PROXY_PORT"
    echo "EMM Proxy Username:          $EMM_PROXY_USR"
    if [ "$EMM_PROXY_PWD" = "" ] ; 
    then
        echo "EMM Proxy Password:          $EMM_PROXY_PWD"
    else
        echo "EMM Proxy Password:          *******"
    fi
    if [ "$OS" = "Darwin" ] ; then
        echo "OSX Desktop Folder:          $MNT_OSX_DESKTOP" 
    fi ;
    echo "Bulk API Directory:          $MNT_BULK_API" 
    echo "SSL Certs Directory:         $MNT_SSL_CERTS"          
    echo "CA Certs File Path:          $CA_CERTS"
    echo "Local Host Entry #1:         $HOST_ENTRY_1"
    echo "Local Host Entry #2:         $HOST_ENTRY_2"
    echo "EMM Delay:                   $EMM_DELAY"
    echo "EMM Timeout:                 $EMM_TIMEOUT"
    echo "EMM Deployed:                $EMM_DEPLOYED"
    
    if [ "$DEBUG" = "TRUE" ] ; 
    then 
        echo " "
        echo "***** DEBUG *****"
        echo "OS Flavor:                   $OS_FLAVOR"
        echo "Config File:                 $FILE"
        echo "Verbose Logging:             $VERBOSE_LOGGING"
        echo "EMM SSL Verification:        $EMM_SSL_VERIFICATION"
        echo "***** DEBUG *****"
    fi ;
}

config_save () {
    update_instance_name
    mkdir -p "$BASE/$INSTANCE"
    rm -f $FILE
    touch $FILE
    chmod go-r $FILE
    echo "Appthority_Org_ID | $AT_ORG_ID" > $FILE
    echo "Appthority_Environment | $RAILS_ENV" >> $FILE
    echo "Appthority_Auth_Token | $AT_AUTH_TOKEN" >> $FILE
    echo "Appthority_Proxy_Host | $AT_PROXY_ADDR" >> $FILE
    echo "Appthority_Proxy_Port | $AT_PROXY_PORT" >> $FILE
    echo "Appthority_Proxy_Username | $AT_PROXY_USR" >> $FILE
    echo "Appthority_Proxy_Password | $AT_PROXY_PWD" >> $FILE
    echo "EMM_Provider | $EMM_PROVIDER" >> $FILE
    echo "EMM_Domain | $EMM_DOMAIN" >> $FILE
    echo "EMM_Account | $EMM_USER" >> $FILE    
    echo "EMM_Username | $EMM_USERNAME" >> $FILE
    echo "EMM_Password | $EMM_PASSWORD" >> $FILE
    echo "EMM_URL | $EMM_URL" >> $FILE
    echo "EMM_API_Token | $EMM_API_TOKEN" >> $FILE
    echo "EMM_API_Version | $EMM_API_VERSION" >> $FILE
    echo "EMM_API_Role | $EMM_API_ROLE" >> $FILE
    echo "EMM_Proxy_Host | $EMM_PROXY_ADDR" >> $FILE
    echo "EMM_Proxy_Port | $EMM_PROXY_PORT" >> $FILE
    echo "EMM_Proxy_Username | $EMM_PROXY_USR" >> $FILE
    echo "EMM_Proxy_Password | $EMM_PROXY_PWD" >> $FILE
    echo "DOCKER_IMAGE | $IMAGE" >> $FILE
    echo "MNT_BULK_API | $MNT_BULK_API" >> $FILE
    echo "MNT_SSL_CERTS | $MNT_SSL_CERTS" >> $FILE
    echo "CA_CERTS | $CA_CERTS" >> $FILE
    echo "HOST_ENTRY_1 | $HOST_ENTRY_1" >> $FILE
    echo "HOST_ENTRY_2 | $HOST_ENTRY_2" >> $FILE
    echo "EMM_DELAY | $EMM_DELAY" >> $FILE
    echo "EMM_TIMEOUT | $EMM_TIMEOUT" >> $FILE
    echo "EMM_DEPLOYED | $EMM_DEPLOYED" >> $FILE
    if [ "$OS" = "Darwin" ] ; then
        echo "MNT_OSX_DESKTOP | $MNT_OSX_DESKTOP" >> $FILE
    fi ;
}

config_load () {
    update_instance_name
    if [ -f "$FILE" ]
    then
        AT_ORG_ID=`grep Appthority_Org_ID $FILE | cut -f 2 -d '|' | tr -d ' '`
        RAILS_ENV=`grep Appthority_Environment $FILE | cut -f 2 -d '|' | tr -d ' '` 
        if [ "$RAILS_ENV" = "" ] ;
        then
            RAILS_ENV="production" ;
        fi
        AT_AUTH_TOKEN=`grep Appthority_Auth_Token $FILE | cut -f 2 -d '|' | tr -d ' '`
        AT_PROXY_ADDR=`grep Appthority_Proxy_Host $FILE | cut -f 2 -d '|' | tr -d ' '`
        AT_PROXY_PORT=`grep Appthority_Proxy_Port $FILE | cut -f 2 -d '|' | tr -d ' '`
        AT_PROXY_USR=`grep Appthority_Proxy_Username $FILE | cut -f 2 -d '|' | tr -d ' '`
        AT_PROXY_PWD=`grep Appthority_Proxy_Password $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_PROVIDER=`grep EMM_Provider $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_DOMAIN=`grep EMM_Domain $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_USER=`grep EMM_Account $FILE | cut -f 2 -d '|' | tr -d ' '`
        if [ "$EMM_DOMAIN" != "" ]
        then
            EMM_USERNAME="" ;
            EMM_USERNAME+=$EMM_DOMAIN ;
            EMM_USERNAME+='\\' ;
            EMM_USERNAME+=$EMM_USER ;
        else
            EMM_USERNAME=`grep EMM_Username $FILE | cut -f 2 -d '|' | tr -d ' '` ;
        fi      
        EMM_PASSWORD=`grep EMM_Password $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_URL=`grep EMM_URL $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_API_TOKEN=`grep EMM_API_Token $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_API_VERSION=`grep EMM_API_Version $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_API_ROLE=`grep EMM_API_Role $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_PROXY_ADDR=`grep EMM_Proxy_Host $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_PROXY_PORT=`grep EMM_Proxy_Port $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_PROXY_USR=`grep EMM_Proxy_Username $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_PROXY_PWD=`grep EMM_Proxy_Password $FILE | cut -f 2 -d '|' | tr -d ' '`
        DOCKER_IMAGE=`grep DOCKER_IMAGE $FILE | cut -f 2 -d '|' | tr -d ' '`
        CA_CERTS=`grep CA_CERTS $FILE | cut -f 2 -d '|' | tr -d ' '`
        HOST_ENTRY_1=`grep HOST_ENTRY_1 $FILE | cut -f 2 -d '|' | tr -d ' '`
        HOST_ENTRY_2=`grep HOST_ENTRY_2 $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_DELAY=`grep EMM_DELAY $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_TIMEOUT=`grep EMM_TIMEOUT $FILE | cut -f 2 -d '|' | tr -d ' '`
        EMM_DEPLOYED=`grep EMM_DEPLOYED $FILE | cut -f 2 -d '|' | tr -d ' '`
        MNT_SSL_CERTS=`grep MNT_SSL_CERTS  $FILE | cut -f 2 -d '|' | tr -d ' '`
        MNT_BULK_API=`grep MNT_BULK_API $FILE | cut -f 2 -d '|' | tr -d ' '`
        MNT_OSX_DESKTOP=`grep MNT_OSX_DESKTOP $FILE | cut -f 2 -d '|' | tr -d ' '`
        if [ "$MNT_BULK_API" = "" ] ; 
        then 
            MNT_BULK_FOLDER="" ;
        else 
            MNT_BULK_FOLDER="/bulkapi" ;
        fi
        if [ "$CA_CERTS" = "" ]
        then
            CA_CERTS="$CA_CERTS_DEFAULT"
        fi      
        if [ "$RAILS_ENV" = "" ] ;
        then
            RAILS_ENV="production"
        fi
        if [ "$EMM_PROVIDER" = "" ] ;
        then
            EMM_PROVIDER="airwatch" 
        fi
        if [ "$EMM_API_VERSION" = "" ] ;
        then
            EMM_API_VERSION="1"
        fi      
        if [ "$DOCKER_IMAGE" = "" ] ;
        then
            IMAGE="$DEFAULT_IMAGE"
        else
            IMAGE="$DOCKER_IMAGE"
        fi          
    else
        echo "Config File Not Found. $FILE"
    fi
}

proxy_check () {
    HAS_AT_PROXY="TRUE"
    HAS_EMM_PROXY="TRUE"
    if [ "$AT_PROXY_ADDR" != "" ] ;
    then
        if [ "$AT_PROXY_ADDR" = "" ]  ; then HAS_AT_PROXY="FALSE"  ; echo "Missing Appthority Proxy Address." ; fi ; 
        if [ "$AT_PROXY_PORT" = "" ]  ; then HAS_AT_PROXY="FALSE"  ; echo "Missing Appthority Proxy Port." ; fi ; 
        #if [ "$AT_PROXY_USR" = "" ]   ; then HAS_AT_PROXY="FALSE"  ; echo "Missing Appthority Proxy Login." ; fi ; 
        #if [ "$AT_PROXY_PWD" = "" ]   ; then HAS_AT_PROXY="FALSE"  ; echo "Missing Appthority Proxy Password." ; fi ; 
    fi ;
    if [ "$EMM_PROXY_ADDR" != "" ] ;
    then    
        if [ "$EMM_PROXY_ADDR" = "" ] ; then HAS_EMM_PROXY="FALSE" ; echo "Missing EMM Proxy Address." ; fi ; 
        if [ "$EMM_PROXY_PORT" = "" ] ; then HAS_EMM_PROXY="FALSE" ; echo "Missing EMM Proxy Port." ; fi ; 
        #if [ "$EMM_PROXY_USR" = "" ]  ; then HAS_EMM_PROXY="FALSE" ; echo "Missing EMM Proxy Login." ; fi ; 
        #if [ "$EMM_PROXY_PWD" = "" ]  ; then HAS_EMM_PROXY="FALSE" ; echo "Missing EMM Proxy Password." ; fi ; 
    fi ;
    #if [ "$XXX" = "" ] ; then VALID="FALSE" ; echo "Missing XXX." ; fi ; 
}

config_check () {
    VALID="TRUE"
    if [ "$AT_ORG_ID" = "" ] ; then VALID="FALSE" ; echo "Missing Appthority Org." ; fi ; 
    if [ "$AT_AUTH_TOKEN" = "" ] ; then VALID="FALSE" ; echo "Missing Appthority Auth Token." ; fi ; 
    if [ "$EMM_PROVIDER" = "" ] ; then VALID="FALSE" ; echo "Missing EMM Provider." ; fi ; 
    if [ "$EMM_USERNAME" = "" ] ; then VALID="FALSE" ; echo "Missing EMM User Name." ; fi ; 
    if [ "$EMM_PASSWORD" = "" ] ; then VALID="FALSE" ; echo "Missing EMM Password." ; fi ; 
    if [ "$EMM_URL" = "" ] ; then VALID="FALSE" ; echo "Missing EMM URL." ; fi ; 
    if [ "$EMM_PROVIDER" = "airwatch" -a "$EMM_API_TOKEN" = "" ] ; then VALID="FALSE" ; echo "Missing EMM API Token." ; fi ; 
    if [ "$EMM_API_VERSION" = "" ] ; then VALID="FALSE" ; echo "Missing EMM API Version." ; fi ; 
    #if [ "$XXX" = "" ] ; then VALID="FALSE" ; echo "Missing XXX." ; fi ; 
}

config_change() {
    echo "Available Configurations: "
    echo " "
    ls -rd ~/.appthority/* | cut -f5 -d/ 2>/dev/null
    echo " "
    $PROMPT "Configuration: \c" 
    read CONFIG_NAME 
    if [ "$CONFIG_NAME" = "" ] ;
    then
        echo " " ;
        echo "Enter an existing or create a new Config" ;
    else
       INSTANCE=$CONFIG_NAME ;
       update_instance_name ;
       config_load ;
    fi ;
}

config_test () {
    echo " "
    echo "Test Connector Config:" 
    update_instance_name
    docker exec $CONTAINER bash /mdm-connector/status.sh
}

container_version () {
    echo "Appthority Connector: $CONTAINER"
    echo " "
    ERRCHK=`docker exec $CONTAINER bash /mdm-connector/version.sh 2>&1 | head -n 1 | grep Error`
    if [ "$ERRCHK" = "" ] ;
    then
        docker exec $CONTAINER bash /mdm-connector/version.sh
    else
        echo "Version not available." ;
    fi ;
}

docker_pull() {
    docker pull appthority/connector:$IMAGE
}

OS_FLAVOR=""
OS=`uname -a | cut -f1 -d" "`
if [ "$OS" = "Darwin" ] ; then
    OS_FLAVOR="OSX"
else
    OS_FLAVOR="LINUX"
fi ;

docker_boot() { 
    update_instance_name
    config_check
    if [ "$OS_FLAVOR" = "OSX" ] ; then
        docker_boot_up
    else
        MNT_SSL_CERTS="/etc/pki/:/etc/pki/"
        docker_boot_up
    fi

}

docker_boot_up() {
    MNT_OSX=""
    MNT_SSL=""
    MNT_BULK=""
    if [ "$MNT_OSX_DESKTOP" != "" ] ; then
        MNT_OSX="-v $MNT_OSX_DESKTOP"
    fi
    if [ "$MNT_SSL_CERTS" != "" ] ; then
        MNT_SSL="-v $MNT_SSL_CERTS"
    fi
    if [ "$MNT_BULK_API" != "" ] ; then
        MNT_BULK="-v $MNT_BULK_API"
    fi  
    #echo $MNT_OSX
    #echo $MNT_BULK
    #echo $MNT_SSL
    #okay_pause
    if [ "$VALID" = "TRUE" ] ; then
        # Config must be valid first, then check Proxy Settings
        echo "Booting Up Instance: $INSTANCE..."
        if [ "$AT_PROXY_ADDR" = "" -a "$EMM_PROXY_ADDR" = "" ] ;
        then
            # Run with No Proxies
            docker run -d --name $CONTAINER \
            $MNT_OSX \
            $MNT_SSL \
            $MNT_BULK \
            --restart always \
            -e EMM_BULK_API_FOLDER=$MNT_BULK_FOLDER \
            -e SSL_CERT_FILE=$CA_CERTS \
            -e EMM_USERNAME=$EMM_USERNAME \
            -e EMM_PASSWORD=$EMM_PASSWORD \
            -e EMM_URL=$EMM_URL \
            -e EMM_API_TOKEN=$EMM_API_TOKEN \
            -e EMM_PROVIDER=$EMM_PROVIDER \
            -e EMM_API_VERSION=$EMM_API_VERSION \
            -e RAILS_ENV=$RAILS_ENV \
            -e AT_AUTH_TOKEN=$AT_AUTH_TOKEN \
            -e VERBOSE_LOGGING=$VERBOSE_LOGGING \
            -e HOST_ENTRY_1=$HOST_ENTRY_1 \
            -e HOST_ENTRY_2=$HOST_ENTRY_2 \
            -e EMM_DELAY=$EMM_DELAY \
            -e EMM_TIMEOUT=$EMM_TIMEOUT \
            -e EMM_DEPLOYED=$EMM_DEPLOYED \
            -e EMM_SSL_VERIFICATION=$EMM_SSL_VERIFICATION \
            -e EMM_API_ROLE=$EMM_API_ROLE \
            appthority/connector:$IMAGE 
        fi ;
        if [ "$AT_PROXY_ADDR" != "" -a "$EMM_PROXY_ADDR" != "" ] ;
        then
            # Run with Both Proxies 
            proxy_check
            if [ "$HAS_AT_PROXY" = "TRUE" -a "$HAS_EMM_PROXY" = "TRUE" ] ; then
                docker run -d --name $CONTAINER \
                $MNT_OSX \
                $MNT_SSL \
                $MNT_BULK \
                --restart always \
                -e EMM_BULK_API_FOLDER=$MNT_BULK_FOLDER \
                -e SSL_CERT_FILE=$CA_CERTS \
                -e EMM_USERNAME=$EMM_USERNAME \
                -e EMM_PASSWORD=$EMM_PASSWORD \
                -e EMM_URL=$EMM_URL \
                -e EMM_API_TOKEN=$EMM_API_TOKEN \
                -e EMM_PROVIDER=$EMM_PROVIDER \
                -e EMM_API_VERSION=$EMM_API_VERSION \
                -e RAILS_ENV=$RAILS_ENV \
                -e AT_AUTH_TOKEN=$AT_AUTH_TOKEN \
                -e AT_PROXY_ADDR=$AT_PROXY_ADDR \
                -e AT_PROXY_PORT=$AT_PROXY_PORT \
                -e AT_PROXY_USR=$AT_PROXY_USR \
                -e AT_PROXY_PWD=$AT_PROXY_PWD \
                -e EMM_PROXY_ADDR=$EMM_PROXY_ADDR \
                -e EMM_PROXY_PORT=$EMM_PROXY_PORT \
                -e EMM_PROXY_USR=$EMM_PROXY_USR \
                -e EMM_PROXY_PWD=$EMM_PROXY_PWD \
                -e VERBOSE_LOGGING=$VERBOSE_LOGGING \
                -e HOST_ENTRY_1=$HOST_ENTRY_1 \
                -e HOST_ENTRY_2=$HOST_ENTRY_2 \
                -e EMM_DELAY=$EMM_DELAY \
                -e EMM_TIMEOUT=$EMM_TIMEOUT \
                -e EMM_DEPLOYED=$EMM_DEPLOYED \
                -e EMM_SSL_VERIFICATION=$EMM_SSL_VERIFICATION \
                -e EMM_API_ROLE=$EMM_API_ROLE \
                appthority/connector:$IMAGE
            fi ;
        fi ;
        if [ "$AT_PROXY_ADDR" != "" -a "$EMM_PROXY_ADDR" = "" ] ;
        then
            # Run with Appthority Proxy Only
            proxy_check
            if [ "$HAS_AT_PROXY" = "TRUE" ] ; then
                docker run -d --name $CONTAINER \
                $MNT_OSX \
                $MNT_SSL \
                $MNT_BULK \
                --restart always \
                -e EMM_BULK_API_FOLDER=$MNT_BULK_FOLDER \
                -e SSL_CERT_FILE=$CA_CERTS \
                -e EMM_USERNAME=$EMM_USERNAME \
                -e EMM_PASSWORD=$EMM_PASSWORD \
                -e EMM_URL=$EMM_URL \
                -e EMM_API_TOKEN=$EMM_API_TOKEN \
                -e EMM_PROVIDER=$EMM_PROVIDER \
                -e EMM_API_VERSION=$EMM_API_VERSION \
                -e RAILS_ENV=$RAILS_ENV \
                -e AT_AUTH_TOKEN=$AT_AUTH_TOKEN \
                -e AT_PROXY_ADDR=$AT_PROXY_ADDR \
                -e AT_PROXY_PORT=$AT_PROXY_PORT \
                -e AT_PROXY_USR=$AT_PROXY_USR \
                -e AT_PROXY_PWD=$AT_PROXY_PWD \
                -e VERBOSE_LOGGING=$VERBOSE_LOGGING \
                -e HOST_ENTRY_1=$HOST_ENTRY_1 \
                -e HOST_ENTRY_2=$HOST_ENTRY_2 \
                -e EMM_DELAY=$EMM_DELAY \
                -e EMM_TIMEOUT=$EMM_TIMEOUT \
                -e EMM_DEPLOYED=$EMM_DEPLOYED \
                -e EMM_SSL_VERIFICATION=$EMM_SSL_VERIFICATION \
                -e EMM_API_ROLE=$EMM_API_ROLE \
                appthority/connector:$IMAGE
            fi ;
        fi ;
        if [ "$AT_PROXY_ADDR" = "" -a "$EMM_PROXY_ADDR" != "" ] ;
        then
            # Run with EMM Proxy Only
            proxy_check
            if [ "$HAS_EMM_PROXY" = "TRUE" ] ; then
                docker run -d --name $CONTAINER \
                $MNT_OSX \
                $MNT_SSL \
                $MNT_BULK \
                --restart always \
                -e EMM_BULK_API_FOLDER=$MNT_BULK_FOLDER \
                -e SSL_CERT_FILE=$CA_CERTS \
                -e EMM_USERNAME=$EMM_USERNAME \
                -e EMM_PASSWORD=$EMM_PASSWORD \
                -e EMM_URL=$EMM_URL \
                -e EMM_API_TOKEN=$EMM_API_TOKEN \
                -e EMM_PROVIDER=$EMM_PROVIDER \
                -e EMM_API_VERSION=$EMM_API_VERSION \
                -e RAILS_ENV=$RAILS_ENV \
                -e AT_AUTH_TOKEN=$AT_AUTH_TOKEN \
                -e EMM_PROXY_ADDR=$EMM_PROXY_ADDR \
                -e EMM_PROXY_PORT=$EMM_PROXY_PORT \
                -e EMM_PROXY_USR=$EMM_PROXY_USR \
                -e EMM_PROXY_PWD=$EMM_PROXY_PWD \
                -e VERBOSE_LOGGING=$VERBOSE_LOGGING \
                -e HOST_ENTRY_1=$HOST_ENTRY_1 \
                -e HOST_ENTRY_2=$HOST_ENTRY_2 \
                -e EMM_DELAY=$EMM_DELAY \
                -e EMM_TIMEOUT=$EMM_TIMEOUT \
                -e EMM_DEPLOYED=$EMM_DEPLOYED \
                -e EMM_SSL_VERIFICATION=$EMM_SSL_VERIFICATION \
                -e EMM_API_ROLE=$EMM_API_ROLE \
                appthority/connector:$IMAGE
            fi ;
        fi ;
    fi ;
}


docker_install() {
    config_check
    if [ "$VALID" = "TRUE" ] ; then
        update_instance_name
        docker_stop_all
        docker_delete
        docker_pull
        docker_boot
    fi ;    
}

docker_log () {
    update_instance_name
    docker exec -it $CONTAINER tail -f log/$RAILS_ENV.log
}

docker_restart () {
    update_instance_name
    docker restart $CONTAINER
}

docker_delete() {
    update_instance_name
    docker stop $CONTAINER > /dev/null 2>&1
    docker rm $CONTAINER > /dev/null 2>&1
    docker_rmi
}

docker_kill() {
    update_instance_name
    docker stop $CONTAINER  
    docker rm $CONTAINER > /dev/null 2>&1
}

docker_images() {
    echo "Appthority Script Version: $VERSION"
    echo " "
    echo "Appthority Connector Image(s):"
    echo " "
    docker images
}

docker_rmi() {
    IMG_ID=`docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}" | grep appthority/connector | tr -s ' ' | tr ' ' '|' | cut -f 1 -d '|' | head -1`
    while [ "$IMG_ID" != "" ]
    do
        echo "Removing Image: $IMG_ID"
        docker rmi -f $IMG_ID
        IMG_ID=`docker images --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}" | grep appthority/connector | tr -s ' ' | tr ' ' '|' | cut -f 1 -d '|' | head -1`
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

docker_instances() {
    echo "Available Configurations:"
    echo " "
    ls -rd ~/.appthority/* | cut -f5 -d/
    echo " "
    echo "Running Instances:"
    echo " "
    docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t"
}

docker_restart () {
    update_instance_name
    docker restart $CONTAINER
}

docker_stop () {
    update_instance_name
    docker stop $CONTAINER
}

docker_stop_all () {
    INST_ID=`docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t" | tr -s ' ' | tr ' ' '|' | cut -f 2 -d '|' | tail -n +2 | head -1`
    while [ "$INST_ID" != "" ]
    do
        echo "Stopping Instance: $INST_ID"
        docker stop $INST_ID  > /dev/null 2>&1
        docker rm $INST_ID > /dev/null 2>&1
        INST_ID=`docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t" | tr -s ' ' | tr ' ' '|' | cut -f 2 -d '|' | tail -n +2 | head -1`
    done    
}

docker_auth () { 
   $PROMPT "Enter Install Key: \c" ; read pass ; echo "" ;
   mkdir -p ~/.docker
   TMP=`docker login -u $AUTH_USER -p $pass 2>/dev/null | grep Succeeded | wc -l | sed -e 's/^[ \t]*//'`
   if [ "$TMP" -gt "0" ] ; then AUTH="TRUE" ; else AUTH="FALSE"; fi ; 
}


host_entries () { 
   $PROMPT "Enter Host Entry #1: \c" ; read HOST_ENTRY_1 ; 
   $PROMPT "Enter Host Entry #2: \c" ; read HOST_ENTRY_2 ; 
}


reset_setup () {
    echo "Resetting Appthority Connector to Factory Defaults." ;
    echo "This will remove all Configurations and Images."
    $PROMPT "Are you sure? (y/n): \c"
    read yn
    if [ "$yn" == "y" ] ;
    then
        echo " "
        echo "Stopping all running instances"
        docker_stop_all
        echo " "
        echo "Deleting connector images"
        docker_rmi_all
        echo " "
        echo "Removing authentication credentials"
        rm -f ~/.docker/config.json > /dev/null 2>&1
        echo " "
        echo "Removing configurations"
        rm -rf $BASE/* > /dev/null 2>&1
        echo " "
        echo "Done!"
        update_instance_name
    fi  
}

config_appthority () {
    echo "Configure Appthority" ;
    echo "-----------------------------------------"
    $PROMPT "Appthority Org ID:             \c" ; read AT_ORG_ID ; 
    $PROMPT "Appthority Auth Token:         \c" ; read AT_AUTH_TOKEN ; 
    $PROMPT "Is there a Proxy (y/n)?        \c" ; read yn ; 
    if [ "$yn" == "y" ] ;
    then
        $PROMPT "Appthority Proxy Host:         \c" ; read AT_PROXY_ADDR ; 
        $PROMPT "Appthority Proxy Port:         \c" ; read AT_PROXY_PORT ; 
        $PROMPT "Appthority Proxy Username:     \c" ; read AT_PROXY_USR ; 
        $PROMPT "Appthority Proxy Password:     \c" ; read -s AT_PROXY_PWD ; 
        HAS_AT_PROXY="TRUE" ;
    fi ;
}

config_emm () {
    emm_reset ;
    echo "Configure EMM" ;
    echo "-----------------------------------------"
    EMM="NULL" ;
    while [ "$EMM" = "NULL" ]  
    do
        echo "Select EMM Provider: " ;
        echo " " ;
        echo "[A]  - AirWatch 9.X" ;
        echo "[M]  - MobileIron Core 9.X" ;
        echo "[MC] - MobileIron Cloud" ;
        #echo "[X]  - XenMobile 10.X" ;
        echo " " ;
        $PROMPT "EMM Provider:           \c" ; read EMM ; 
        case $EMM in
            A|a)    EMM_PROVIDER="airwatch"   ; EMM_API_VERSION="1" ;;
            M|m)    EMM_PROVIDER="mobileiron" ; EMM_API_VERSION="1" ;;
            MC|Mc|mC|mc)    EMM_PROVIDER="mobileiron_cloud" ; EMM_API_VERSION="1" ;;
            #X|x)   EMM_PROVIDER="xenmobile"  ; EMM_API_VERSION="1" ;;
            *)      EMM="NULL"
        esac
    done
    echo "EMM Provider Selected:  $EMM_PROVIDER" ;  
    if [ "$EMM_PROVIDER" = "mobileiron" ] ; 
    then
        $PROMPT "Is MobileIron Core On-Premise? (y/n): \c" ; read yn ; 
        if [ "$yn" == "y" ] ;
        then
            EMM_DEPLOYED="ONPREM" ;
        else
            EMM_DEPLOYED="CLOUD" ;
        fi
    fi ;
    $PROMPT "EMM URL:                \c" ; read EMM_URL ; 
    if [ "$EMM_PROVIDER" = "airwatch" ] ; 
    then
        $PROMPT "EMM API Token:          \c" ; read EMM_API_TOKEN ; 
        #$PROMPT "EMM API Role:          \c" ; read EMM_API_ROLE ; 
    fi ;
    $PROMPT "Is the EMM User a Domain Account (y/n)? \c" ; read yn ; 
    if [ "$yn" == "y" ] ;
    then
        $PROMPT "EMM Domain:             \c" ; read EMM_DOMAIN ; 
        $PROMPT "EMM Username:           \c" ; read EMM_USER ; 
        $PROMPT "EMM Password:           \c" ; read -s EMM_PASSWORD ; 
        echo ""
        EMM_USERNAME="" ;
        EMM_USERNAME+=$EMM_DOMAIN ;
        EMM_USERNAME+='\\' ;
        EMM_USERNAME+=$EMM_USER ;
    else
        EMM_DOMAIN=""
        EMM_USER=""
        $PROMPT "EMM Username:           \c" ; read EMM_USERNAME ; 
        $PROMPT "EMM Password:           \c" ; read -s EMM_PASSWORD ; 
        echo "" ;
    fi
    $PROMPT "Is there a Proxy (y/n)? \c" ; read yn ; 
    if [ "$yn" == "y" ] ;
    then
        $PROMPT "EMM Proxy Host:         \c" ; read EMM_PROXY_ADDR ; 
        $PROMPT "EMM Proxy Port:         \c" ; read EMM_PROXY_PORT ; 
        $PROMPT "EMM Proxy Username:     \c" ; read EMM_PROXY_USR ; 
        $PROMPT "EMM Proxy Password:     \c" ; read -s EMM_PROXY_PWD ; 
        HAS_EMM_PROXY="TRUE" ;
        echo " " ;
    fi ;
    $PROMPT "Set EMM API Delay (y/n)? \c" ; read yn ; 
    if [ "$yn" == "y" ] ;
    then
        $PROMPT "EMM Delay (in milliseconds): \c" ; read EMM_DELAY ; 
    fi ;    
    $PROMPT "Set EMM API Timeout (y/n)? \c" ; read yn ; 
    if [ "$yn" == "y" ] ;
    then
        $PROMPT "EMM Timeout (in seconds): \c" ; read EMM_TIMEOUT ; 
    fi ;    
}


ca_certs () {
    echo " "
    echo "Changing SSL Certs Directory to: $MNT_SSL_CERTS" ;
    echo "Current CA Certs File Location is: $CA_CERTS" ;
    $PROMPT "Do you want to update location of CA Certs (y/n)? \c" 
    read yn 
    if [ "$yn" == "y" ] ;
    then
        $PROMPT "Enter New CA Cert File: \c" ; 
        read cacerts ; 
        if [ "$cacerts" != "" ] ;
        then
            CA_CERTS=$cacerts 
        fi
        echo "New CA Certs File: $CA_CERTS"
    fi ;
}

config_mounts () {
    MNTOPT="NULL" ;
    while [ "$MNTOPT" != "X" ]  
    do
        clear
        echo ""
        echo "================================================="
        echo "           CONFIGURE DOCKER MOUNTS               " ;
        echo "================================================="
        echo " "
        echo "Mount Points (Select to Update): " ;
        echo " " ;
        if [ "$OS_FLAVOR" = "OSX" ] ; then
            echo "[D]  - OSX Desktop Folder:  $MNT_OSX_DESKTOP" ;
        fi
        echo "[B]  - Bulk API Directory:  $MNT_BULK_API" ;
        echo "[S]  - SSL Certs Directory: $MNT_SSL_CERTS" ;
        echo "       CA Certs Location:   $CA_CERTS"
        echo " " ;
        echo "[X]  - Exit Menu" ;
        echo " " ;
        $PROMPT "Update Mount Point: \c" ; read MNTOPT ; 
        case $MNTOPT in
            D|d)    if [ "$MNT_OSX_DESKTOP" = "" ] ; 
                    then 
                        MNT_OSX_DESKTOP="$HOME/Desktop:/Desktop" ;
                    else 
                        MNT_OSX_DESKTOP="" ; 
                    fi ;;
            B|b)    if [ "$MNT_BULK_API" = "" ] ; 
                    then 
                        MNT_BULK_API="$HOME/bulkapi:/bulkapi" ;
                        MNT_BULK_FOLDER="/bulkapi" ;
                    else 
                        MNT_BULK_API="" ; 
                        MNT_BULK_FOLDER="" ;
                    fi ;;
            S|s)    if [ "$MNT_SSL_CERTS" = "" ] ; 
                    then MNT_SSL_CERTS="/etc/pki/:/etc/pki" ;
                    else MNT_SSL_CERTS="" ; fi ; ca_certs ;;
            x|X)    clear ; MNTOPT="X" ; echo "Exiting " ;; 
        esac
    done
}


connector_install () {
    echo "Install/Update Connector:" ; 
    echo " "
    if [ "$AUTH" != "TRUE" ] ; 
    then echo "Install Key Required!" ; 
    else docker_install ; fi ; 
}

connector_update () {
    echo "Updating Connector Image:" ; 
    echo " "
    if [ "$AUTH" != "TRUE" ] ; 
    then echo "Install Key Required!" ; 
    else docker_pull ; fi ; 
}

set_emm_delay() {
   $PROMPT "Set EMM API Delay (y/n)? \c" ; read yn ; 
    if [ "$yn" == "y" ] ;
    then
        $PROMPT "EMM Delay (in milliseconds): \c" ; read EMM_DELAY ; 
    fi ;        
}

set_emm_timeout() {
    $PROMPT "Set EMM API Timeout (y/n)? \c" ; read yn ; 
    if [ "$yn" == "y" ] ;
    then
        $PROMPT "EMM Timeout (in seconds): \c" ; read EMM_TIMEOUT ; 
    fi ;    
}

okay_pause () {
    $PROMPT "\n[Okay] \c"; 
    read ans ; 
}


##
## MAIN MENU LOOP
##

update_instance_name
config_load

while [ "$OPT" != "X" ]  
do
    clear
    echo ""
    echo "================================================="
    echo "           APPTHORITY EMM CONNECTOR              "
    echo "================================================="
    echo "> Instance: $INSTANCE"
    echo " "
    echo "[1]  key         - Set Install Key                 " ;
    echo "[2]  appthority  - Configure Appthority            " ;
    echo "[3]  emm         - Configure EMM Settings          " ;
    echo "[4]  install     - Install or Update Connector     " ;
    echo "[5]  uninstall   - Stop All Instances & Uninstall  " ;
    echo "[6]  test        - Test Connector Configuration    " ;
    # Extended Menus
    if [ "$XMENU" = "N" ] ; then
        echo " "
        echo "[+]  More Options                              " ;
    else
        echo " "
        echo "[A]  about       - About Connector Image       " ;
        echo "[U]  update      - Update Connector Image      " ;        
        echo "[D]  delete      - Delete Connector Image      " ;        
        echo "[S]  save        - Save Configuration          " ;        
        echo "[V]  view        - View Configuration          " ;        
        echo "[L]  load        - Load Configuration          " ;        
        echo "[C]  change      - Change Configuration        " ;        
        echo "[I]  instances   - Show Running Instances      " ;        
        echo "[B]  boot        - Boot Up Instance $INSTANCE  " ;        
        echo "[R]  restart     - Restart Instance $INSTANCE  " ;        
        echo "[K]  kill        - Kill Instance $INSTANCE     " ;        
        echo "[T]  logs        - Tail Logs for $INSTANCE     " ;    
        echo "[M]  mounts      - Configure Docker Mounts     " ;        
        echo "[H]  localhosts  - Enter Local Host Entries    " ;        
        echo "[ED] emm delay   - Set EMM API Throttle Delay  " ;      
        echo "[ET] emm timeout - Set EMM API Timeouts        " ;      
        echo " "
        echo "[-]  Fewer Options                             " ;        
    fi ;
    echo "[X]  Exit Menu                                     " ; 
    echo " "
    $PROMPT "Selection: \c"
    read OPT OPT1 OPT2
    case $OPT in
        1|key)          echo " " ; docker_auth ; okay_pause ;;
        2|appthority)   echo " " ; config_appthority ; okay_pause ;;
        3|emm)          echo " " ; config_emm ; okay_pause ;;
        4|install)      echo " " ; connector_install ; okay_pause ;;
        5|uninstall)    echo " " ; reset_setup ; okay_pause ;;
        6|test)         echo " " ; config_test ; okay_pause ;;
        a|A|about)      echo " " ; docker_images ; echo " "; container_version ; echo " " ; okay_pause ;;
        u|U|update)     echo " " ; connector_update ; okay_pause ;;
        d|D|delete)     echo " " ; docker_delete ; echo " " ; okay_pause ;;
        c|C|change)     echo " " ; config_change ; okay_pause ;;
        s|S|save)       echo " " ; config_save ; echo "Connector Config Saved!" ; okay_pause ;;
        l|L|load)       echo " " ; config_load ; echo "Connector Config Loaded!" ; okay_pause ;;
        v|V|view)       echo " " ; config_view ; okay_pause ;;
        i|I|instances)  echo " " ; docker_instances ; okay_pause ;;
        b|B|boot)       echo " " ; docker_boot ; okay_pause ;;
        r|R|restart)    echo " " ; docker_restart ; echo "Connector Instance Restarted!" ; okay_pause ;;
        k|K|kill)       echo " " ; if [ "$OPT1" = "all" ] ; then docker_stop_all ; 
                                   else docker_kill ; echo "Connector Instance Killed!" ; fi ; okay_pause ;;
        t|T|log|logs)   echo " " ; docker_log ; okay_pause ;;
        h|H|localhosts) echo " " ; host_entries ; okay_pause ;;
        production)     echo " " ; echo "Appthority Production Enabled" ; RAILS_ENV="production" ; okay_pause ;;
        staging)        echo " " ; echo "Appthority Staging Enabled" ; RAILS_ENV="staging" ; okay_pause ;;
        debug)          echo " " ; if [ "$OPT1" = "" -o "$OPT1" = "on" ] ; then DEBUG="TRUE" ; echo "Debug ON" ; 
                                   else DEBUG="FALSE" ; echo "Debug OFF" ; fi ; okay_pause ;;
        verbose)        echo " " ; if [ "$OPT1" = "" -o "$OPT1" = "on" ] ; then VERBOSE_LOGGING="true" ; echo "Verbose Logging ON" ; 
                                   else VERBOSE_LOGGING="false" ; echo "Verbose Logging OFF" ; fi ; okay_pause ;;
        ssl)            echo " " ; if [ "$OPT1" = "" -o "$OPT1" = "on" ] ; then EMM_SSL_VERIFICATION="ON" ; echo "EMM SSL ON" ; 
                                   else EMM_SSL_VERIFICATION="OFF" ; echo "EMM SSL OFF" ; fi ; okay_pause ;;
        version)        $PROMPT "Connector Version: \c" ; read IMAGE ; ;;
        shell)          clear ; docker exec -it $CONTAINER bash ; ;;
        m|M|mounts)     config_mounts ;;
        ed|ED)          echo " " ; set_emm_delay ; okay_pause ;;
        et|ET)          echo " " ; set_emm_timeout ; okay_pause ;;
        +)              XMENU="Y" ;;
        -)              XMENU="N" ;;
        x|X)            clear ; OPT="X" ; echo "Exiting " ;; 
    esac
done


