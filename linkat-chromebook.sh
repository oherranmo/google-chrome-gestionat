#!/bin/bash
#Autor: Òscar Herrán Morueco
#Aquest script "capa" els ordinadors amb linkat, però, no és compatible amb el perfil robòtica.
#Aquest script desinstal·la aplicacions considerades per l'autor de l'script inapropiades per a l'alumnat.

root_check()
{
if [ "$(id -u)" != "0" ]; then
	whiptail --title "Error!" \
    --msgbox "Heu d'executar aquest script com a root (sudo) > ./nomscript.sh" 10 30
	exit 1
fi
comprova_connexio
}
comprova_connexio()
{


if nc -zw1 google.com 443; then
  token
  else
  whiptail --title "Error!" \
    --msgbox "Comproveu la connexió a internet!" 10 30
    clear
    exit 1
fi


}

token()
{

TOKEN=$(whiptail --title "Clau de token" \
    --inputbox "Escriviu la clau de token, o deixeu la clau per defecte" 10 60 "Aquí poseu el token proporcionat per la consola de google" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
if [ -z $TOKEN ]; then
	whiptail --title "Avís!" \
    --msgbox "No heu introduït cap clau de token, per tant s'instal·larà Google Chrome sense gestionar" 10 30
chrome

else
	mkdir -p "/etc/opt/chrome/policies/enrollment"
	echo "$TOKEN" > "/etc/opt/chrome/policies/enrollment/CloudManagementEnrollmentToken"
chrome
fi
else
clear
	whiptail --title "Avís!" \
    --msgbox "Heu triat cancel·lar" 10 30
fi

}


chrome()
{

if [[ $(getconf LONG_BIT) = "64" ]]
then
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    dpkg -i google-chrome-stable_current_amd64.deb
    rm -f google-chrome-stable_current_amd64.deb
    browsers
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
    dpkg -i google-chrome-stable_current_i386.deb
    rm -f google-chrome-stable_current_i386.deb
    browsers
fi

}

browsers()
{
apt remove --purge firefox chromium-browser -y
mkdir /etc/firefox/policies
echo '{' > /etc/firefox/policies/policies.json
echo ' "policies": {' >> /etc/firefox/policies/policies.json
echo '   "WebsiteFilter": {' >> /etc/firefox/policies/policies.json
echo '      "Block": ["<all_urls>"]' >> /etc/firefox/policies/policies.json
echo '    }' >> /etc/firefox/policies/policies.json
echo '  }' >> /etc/firefox/policies/policies.json
echo '}' >> /etc/firefox/policies/policies.json
echo "Ha finalitzat l'script!"
botiga
}


botiga()
{
apt remove --purge gnome-software -y
jocs

}


jocs()
{
apt remove --purge colobot -y
apt remove --purge gnome-mahjongg -y
apt remove --purge gnome-mines -y
apt remove --purge minetest -y
apt remove --purge robocode -y
apt remove --purge gnome-sudoku -y
apt remove --purge aisleriot -y
apt remove --purge remmina -y
apt remove --purge wireshark -y
apt remove --purge filezilla -y
apt remove --purge thunderbird -y
apt remove --purge transmission-gtk -y
apt remove --purge vim -y
apt remove --purge gnome-todo -y
apt remove --purge deja-dup -y
apt remove --purge playonlinux -y
paquets_brossa
}

paquets_brossa()
{
    apt update
    apt upgrade -y
    apt autoremove -y
    end
}

end()
{
if(whiptail  --title "Fi" \
    --yesno "Ha acabat l'script, voleu reiniciar l'equip?" \
    --yes-button "Si" \
    --no-button "No" 10 60) then

    reboot
else
    echo -e "Finalitzat!"
fi

}
root_check
