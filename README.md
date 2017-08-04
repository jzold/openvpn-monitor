# Summary
This bash script monitors configured OpenVPN connections and if/when a VPN connection disconnects it automatically reconnects choosing randomly from a list of predefined OpenVPN connections array.

# Dependencies
The script has following dependencies:

- Ubuntu/other Ubuntu flavors (Xubuntu, Kubuntu, etc.) but should work in other distros as well. The followings below are dependencies for Xubuntu:

  - nmcli (network-manager package)
  - notify-send (libnotify-bin package)
  - ping
  - grep and egrep
  
# Run bash script automatically at logon
This depends slighly on the flavor of distro used, for Xubuntu configure the script under "Session and Startup/Application Autostart" tab
