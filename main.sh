#!/bin/bash

# Script to Setup Ubuntu Servers to my liking

# Author : Nolan Winsman
# Date : 10-16-2022


# if the first argument is "-y" then everything is installed and configured.
if [[ "$1" == "-y" ]]; then
        echo "Auto accepting every setup"
        AUTO=true
else
        echo "Not automatically accepting every setup. Use -y as the first argument to automatically say yes to everything"
        AUTO=false
fi

sudo apt update
sudp apt upgrade


PKGS=(
'surfshark'
)


echo -ne "

----------------------------------------------------------------------

                            Ubuntu Packages

----------------------------------------------------------------------

"

# function to install all ubuntu packages
packages() {
    for PKG in "${PKGS[@]}"; do
        echo "INSTALLING: ${PKG}"
        sudo apt install "$PKG"
    done
}
if [ $AUTO == true ]
then
    packages
else
    read -p "Do you want to install Ubuntu Packages? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        packages
    fi
fi



echo -ne "

----------------------------------------------------------------------

                            Surfshark-VPN Setup

----------------------------------------------------------------------

"

# function to setup surfshark-vpn
surfshark() {
    sudo wget https://ocean.surfshark.com/debian/pool/main/s/surfshark-release/surfshark-release_1.0.0-2_amd64.deb
    sudo dpkg -i *"surfshark"*
    sudo apt-get update
    sudo apt-get install surfshark-vpn

    # custom DNS
    sudo rm -r /etc/resolv.conf
    sudo echo "nameserver 162.252.172.57" > /etc/resolv.conf
    sudo echo "nameserver 149.154.159.92" >> /etc/resolv.conf

    # Disable IP6 as Surfshark does not support IP6
    sudo echo "" >> /etc/sysctl.conf
    sudo echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
    sudo echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
    sudo echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
    sudo echo "net.ipv6.conf.tun0.disable_ipv6 = 1" >> /etc/sysctl.conf
    sudo sysctl -p
    echo "Reboot Required for Surfshark-VPN to work"
    echo "Run the Command 'sudo surfshark-vpn' to run the program " 
}
if [ $AUTO == true ]
then
    surfshark
else
    read -p "Do you want to setup Surfshark-vpn? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        surfshark
    fi
fi