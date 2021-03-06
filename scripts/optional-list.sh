#!/bin/bash
#================================================================================================
# This script will download optional-list.txt and add domains from the rep to whitelist.txt file.
# OFFICIAL Project homepage: https://github.com/anudeepND/whitelist
# Licence: https://github.com/anudeepND/whitelist/blob/master/LICENSE
# Created by Anudeep (Slight change by cminion)
#------------------------------------------------------------------------------------------------
# EPiC *fork* -4- optional-list.sh (+optional-list.txt) usage only
#------------------------------------------------------------------------------------------------
# git clone https://github.com/EPiC-APOC/whitelist.git
# cd whitelist/scripts
# sudo chmod +x optional-list.sh
# sudo ./optional-list.sh
#================================================================================================
# https://github.com/anudeepND/whitelist/commit/22b4be7d60ad68dc9e1014cff55f4e5975cca977
#================================================================================================
TICK="[\e[32m ✔ \e[0m]"


echo -e " \e[1m This script will download optional-list.txt and add domains from the repo to whitelist.txt \e[0m"
sleep 1
echo -e "\n"

if [ "$(id -u)" != "0" ] ; then
	echo "This script requires root permissions. Please run this as root!"
	exit 2
fi

if [ "$(dpkg-query -W -f='${Status}' gawk 2>/dev/null |  grep -c "ok installed")" -eq 0 ];
then
  echo -e " [...] \e[32m Installing gawk... \e[0m"
  apt-get install gawk -qq > /dev/null
  wait
  echo -e " ${TICK} \e[32m Finished \e[0m"
fi


#curl -sS https://raw.githubusercontent.com/anudeepND/whitelist/master/domains/optional-list.txt >>/etc/pihole/whitelist.txt
curl -sS https://raw.githubusercontent.com/EPiC-APOC/whitelist/master/domains/optional-list.txt >>/etc/pihole/whitelist.txt
echo -e " ${TICK} \e[32m Adding optional-list to whitelist... \e[0m"
sleep 0.5
echo -e " ${TICK} \e[32m Removing comments and newlines... \e[0m"
sed -i -e 's/^#.*$//' -e '/^$/d' /etc/pihole/whitelist.txt
sort -o /etc/pihole/whitelist.txt /etc/pihole/whitelist.txt
echo -e " ${TICK} \e[32m Removing duplicates... \e[0m"
gawk -i inplace '!a[$0]++' /etc/pihole/whitelist.txt
wait
echo -e " [...] \e[32m Pi-hole gravity rebuilding lists. This may take a while... \e[0m"
pihole -g > /dev/null
wait
echo -e " ${TICK} \e[32m Pi-hole's gravity updated \e[0m"
echo -e " ${TICK} \e[32m Done! \e[0m"


echo -e " \e[1m  Happy AdBlocking :)\e[0m"
echo -e "\n\n"