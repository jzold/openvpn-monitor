#!/bin/bash +x

# declaring an associative array for the VPN UUIDs
declare -A UUIDMAP

# add the preconfigured VPN UUIDs from <nmcli con show|grep vpn> of ADD THE UUIDS OF PRECONFIGURED NETWORKS INTO THE ARRAY
UUIDMAP[0]="aaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
UUIDMAP[1]="ffff-gggg-hhhh-iiii-jjjjjjjjjjjj"
UUIDMAPLEN=${#UUIDMAP[@]}

# set the delay 5 TO seconds
DELAY=5

# Log file path with write permission to the executing user
LOG="<PATH TO THE LOG FILE>"

# Enable/disable ping connection check
PING_CHECK=true

# Check IP/Hostname
CHECK_IP="8.8.8.8"

# Configure DISPLAY variable for desktop notifications
DISPLAY=0.0
if [[ $1 == "stop" ]]; then
  VPNCON=$(nmcli con show --active | grep vpn)
  if [ -z "$VPNCON" ]; then
    notify-send "there are no active VPN connections to STOP"
  else
    VPN_UID=nmcli con show --active | grep vpn|cut -d " " -f 3
    nmcli con down uuid $VPN_UID
    echo "$(date +%Y/%m/%d\ %H:%M:%S) -> VPN monitoring service STOPPED!" >> $LOG
    notify-send "VPN monitoring service STOPPED!"
    SCRIPT_FILE_NAME=`basename $0`
    PID=`pgrep -f $SCRIPT_FILE_NAME`
    kill $PID  
  fi
elif [[ $1 == "start" ]]; then
  notify-send "VPN monitoring service STARTING!"
  while [ "true" ]
  do
    VPNCON=$(nmcli con show --active | grep vpn)
    #if there is no active VPN connection available choose a new random VPN connection from the array and connect 
    if [ -z "$VPNCON" ]; then
      rand=$[ $RANDOM % $UUIDMAPLEN]
      echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Disconnected from VPN, trying to reconnect..." >> $LOG
      VPN_UID=$(echo ${UUIDMAP[$rand]} | cut -f1 -d' ')
      (sleep 1s && nmcli con up uuid $VPN_UID)  
      VPN_NAME=$(nmcli con show --active | grep vpn|cut -d " " -f 1)
      if [ -z "VPN_NAME" ]; then
        echo "$(date +%Y/%m/%d\ %H:%M:%S) -> ERROR: VPN connection is not established" >> $LOG  
      else
        echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Successfully connected to $VPN_NAME" >> $LOG  
      fi  
      
    fi
    sleep $DELAY

    if [[ $PING_CHECK = true ]]; then
      #ping the target IP 4 times. If packet loss>3 then choose a random VPN connection and connect
      PINGCOUNT=$(ping $CHECK_IP -c4 -q -W 3 |egrep "received"|cut -f 4 -d " ")
      if [[ $PINGCOUNT<3 ]]; then
      	echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Ping check timeout IP:$CHECK_IP, establishing a new VPN connection..." >> $LOG
        VPNCON=$(nmcli con show --active | grep vpn)
        VPN_UID=$(nmcli con show --active | grep vpn|cut -d " " -f 3)
        (nmcli con down uuid $VPN_UID)
        #if there are no active VPN connections choose a new random VPN connection from the array and connect
        if [ -z "$VPNCON" ]; then
          rand=$[ $RANDOM % UUIDMAPLEN]
          echo "$(date +%Y/%m/%d\ %H:%M:%S) -> No VPN connection, establishing new VPN connection..." >> $LOG
          VPN_UID=$(echo ${UUIDMAP[$rand]} | cut -f1 -d' ')
          (sleep 1s && nmcli con up uuid $VPN_UID)
          VPN_NAME=$(nmcli con show --active | grep vpn|cut -d " " -f 1)
          echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Successfully connected to $VPN_NAME" >> $LOG
        else
          echo "$(date +%Y/%m/%d\ %H:%M:%S) -> ERROR: the VPN connection is still active, trying to reconnect  ..." >> $LOG
        fi
      fi
    fi
  done
  echo "$(date +%Y/%m/%d\ %H:%M:%S) -> VPN monitoring service STARTED!" >> $LOG
  notify-send "VPN monitoring service STARTED!"
else 
  echo "$(date +%Y/%m/%d\ %H:%M:%S) -> Unrecognised command: $0 $@" >> $LOG
  echo "Please use $0 [start|stop]" 
  notify-send "UNRECOGNIZED COMMAND" "VPN monitoring service could not recognise the command!"
fi
