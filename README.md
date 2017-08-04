# Summary
The bash script monitors configured OpenVPN connections and if/when a VPN connection disconnects it automatically reconnects choosing randomly from a list of predefined OpenVPN connections array.

# Dependencies
The script has following dependencies:

- Ubuntu/other Ubuntu flavors (Xubuntu, Kubuntu, etc.) but should work in other distros as well. The followings below are dependencies for Xubuntu:

  - nmcli (network-manager package)
  - notify-send (libnotify-bin package)
  - ping
  - grep, pgrep and egrep

# Prerequisites
The VPN connections have to be created and configured with Network Manager, I recommend saving all the credentials required for authentication in the config to make sure the script can auto-reconnect to any VPN connections without any user intervention.

Step1: Configure all VPN connections in Network Manager

Step2: Get a list of all the network UUIDs:

     nmcli con show|grep vpn
  
Step3: add all the network UUIDs in the script like this:

...

UUIDMAP[0]="aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"

UUIDMAP[1]="ffffffff-gggg-hhhh-iiii-jjjjjjjjjjjj"

...

# Usage
/path/to/the/script.sh start - start the VPN monitoring script
/path/to/the/script.sh stop - stop the VPN monitoring script

# Improvements
1. Rather than editing the script with UUIDs the script should automatically list UUIDs and append to the array
2. ...

# Run bash script automatically at logon
This depends slighly on the flavor of distro used, for Xubuntu configure the script under "Session and Startup/Application Autostart" tab:

Name: VPN Monitoring script

Command: /path/to/the/script.sh start
