#!/bin/bash
#Autor Òscar Herrán Morueco
#Configuració Google Chrome Gestionat
root_check()
{
if [ "$(id -u)" != "0" ]; then
	whiptail --title "Error!" \
    --msgbox "Heu d'executar aquest script com a root (sudo) > ./nomscript.sh" 10 70
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
    --inputbox "Escriviu la clau de token" 10 60 "" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
if [ -z $TOKEN ]; then
	whiptail --title "Avís!" \
    --msgbox "No heu introduït cap clau de token, per tant s'instal·larà Google Chrome sense gestionar" 10 70
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
    check
else
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb
    dpkg -i google-chrome-stable_current_i386.deb
    rm -f google-chrome-stable_current_i386.deb
    check
fi

}

check()
{
if [ -n "$(dpkg -l | grep google-chrome)" ]; then
    whiptail --title "Èxit!" \
        --msgbox "L'instal·lació s'ha dut a terme correctament!" 10 30
    exit 1
else
    whiptail --title "Error!" \
        --msgbox "L'instal·lació ha fallat!" 10 30
echo "L'instal·lació ha fallat, proveu a executar manualment les següents commandes:"
if [[ $(getconf LONG_BIT) = "64" ]]
then
    echo "wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" 
    echo "sudo dpkg -i google-chrome-stable_current_amd64.deb"
    echo "rm -f google-chrome-stable_current_amd64.deb"
    exit 1
else
    echo "wget https://dl.google.com/linux/direct/google-chrome-stable_current_i386.deb"
    echo "sudo dpkg -i google-chrome-stable_current_i386.deb"
    echo "rm -f google-chrome-stable_current_i386.deb"
    exit 1
fi
fi

}
root_check
