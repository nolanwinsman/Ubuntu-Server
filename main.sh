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
'python3-pip'
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

                            Mullvad VPN

----------------------------------------------------------------------

"

# function to install all ubuntu packages
mullvad-vpn() {
        wget --content-disposition https://mullvad.net/download/app/deb/latest
        sudo apt install -y ./*"MullvadVPN"*

        # configures prefered setting for mullvad
        mullvad lan set allow
        mullvad always-require-vpn set on
        mullvad auto-connect set on

        echo "Run 'mullvad account login' To login to mullvad vpn"
}
if [ $AUTO == true ]
then
    mullvad-vpn
else
    read -p "Do you want to install Mullvad VPN? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        mullvad-vpn
    fi
fi


echo -ne "

----------------------------------------------------------------------

                            Plex Media Server Setup

----------------------------------------------------------------------

"

# function to setup plex media server
plex() {
    sudo apt install apt-transport-https curl wget -y
    sudo wget -O- https://downloads.plex.tv/plex-keys/PlexSign.key | gpg --dearmor | sudo tee /usr/share/keyrings/plex.gpg
    echo deb [signed-by=/usr/share/keyrings/plex.gpg] https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
    sudo apt update
    sudo apt install plexmediaserver -y
    # sudo ufw allow 32400
    # sudo ufw allow OpenSSH
    # sudo ufw enable
}
if [ $AUTO == true ]
then
    plex
else
    read -p "Do you want to setup Plex Media Server? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        plex
    fi
fi


echo -ne "

----------------------------------------------------------------------

                            Qbittorrent-Nox Setup

----------------------------------------------------------------------

"

# function to setup plex media server
qbittorrent-nox() {
    sudo apt install qbittorrent-nox
    sudo echo "[Unit]" > /etc/systemd/system/qbittorrent-nox.service
    sudo echo "Description=qBittorrent client" >> /etc/systemd/system/qbittorrent-nox.service
    sudo echo "After=network.target" >> /etc/systemd/system/qbittorrent-nox.service
    sudo echo "" >> /etc/systemd/system/qbittorrent-nox.service
    sudo echo "[Service]" >> /etc/systemd/system/qbittorrent-nox.service
    sudo echo "ExecStart=/usr/bin/qbittorrent-nox --webui-port=8080" >> /etc/systemd/system/qbittorrent-nox.service
    sudo echo "Restart=always" >> /etc/systemd/system/qbittorrent-nox.service
    sudo echo "" >> /etc/systemd/system/qbittorrent-nox.service
    sudo echo "[Install]" >> /etc/systemd/system/qbittorrent-nox.service
    sudo echo "WantedBy=multi-user.target" >> /etc/systemd/system/qbittorrent-nox.service


}
if [ $AUTO == true ]
then
    qbittorrent-nox
else
    read -p "Do you want to setup Qbittorrent-Nox? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        qbittorrent-nox
    fi
fi