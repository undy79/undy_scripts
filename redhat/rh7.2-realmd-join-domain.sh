#!/bin/bash
#
# 
# Script to join Redhat/CentOS 7.2 boxes to a Windows Domain
# POssibly buggy
#
#
# Not tested on 7.3 or later...
#


echo
echo "Script will install realmd and add server to the domain"
echo



#### Let's get some variables

# Color control
RED='\033[0;31m'
NC='\033[0m' # No Color 

# Get the name of the first network connection - more work need to be done in the rare case of multiple connections. 
nmcliconnection=$(nmcli --fields NAME con show | grep -v NAME | head -n 1)

# Get the hostname
hncheck=$(hostnamectl | grep hostname | cut -d " " -f 6)





#### Create some functions

changehostname () {
        read -p "Enter the hostname FQDN: " hn
        hostnamectl set-hostname ${hn}
        hnc=$(hostnamectl | grep hostname | cut -d " " -f 6)
        echo
	echo "Hostname is now ${hnc}"
	echo 
}


changedns () {
        read -p "Enter the DNS servers seperated by a space: " dnsservers 
	read -p "Enter the search domain: " dnssearchdomain
	echo
	nmcli con mod ${nmcliconnection} ipv4.dns 1.1.1.1
	nmcli con mod ${nmcliconnection} -ipv4.dns 1.1.1.1
	for i in ${dnsservers}
	do
		nmcli con mod ${nmcliconnection} +ipv4.dns $i
	done
	if [ ${dnssearchdomain} ]; then
		nmcli con mod ${nmcliconnection} ipv4.dns-search ${dnssearchdomain} 
	fi 
	echo
	nmcli con up ${nmcliconnection}
	echo "DNS settings are now: "
	nmcli con show ${nmcliconnection} | grep ipv4.dns
	echo
	echo
}


installdeps () {
	echo "installing the dependencies..."
        yum -y install sssd realmd oddjob-mkhomedir oddjob adcli samba-common samba-common-tools krb5-workstation sssd-krb5 nfs-utils
        echo
}


getdomaininfo () {
	echo
	read -p "Enter the name of the domain to join by DNS resolvable name (example: local.com): " domain
	echo 
}



domainjoin () {
        echo
        echo "Discovering the domain..."
        realm discover ${domain}
        echo
        read -p "Username with permission to add a machine to the domain: " dusr
        echo
        echo "Attempting join..."
        realm join ${domain} -U ${dusr}
        echo
        echo "Permiting Domain Admins group to login to this server."
        realm permit -g "${domain}\\domain admins"
        echo
        read -p "Additional group to allow login to this server? (without domain): " gusr
	if [ "${gusr}" ]; then
        realm permit -g "${domain}\\${gusr}"
        sleep 5
        echo
        echo
	fi
	realm list | grep -v permitted
	echo -e "${RED}"
	realm list | grep permitted
	echo -e "${NC}"
} 


configsssd () {
	echo
        echo "Changing SSSD configuration to allow sudo and login without using fully qualified names."
        cp -arp /etc/sssd/sssd.conf /etc/sssd/sssd.conf.back
        sed -i 's/^use_fully_qualified_names\s\=\sTrue/Use_fully_qualified_names \= False/' /etc/sssd/sssd.conf
        sed -i 's/^service.*/&\, sudo/' /etc/sssd/sssd.conf
	systemctl enable sssd
        systemctl restart sssd
        systemctl status sssd
	echo
	echo	
}


configsudo () {
	echo
        echo "Adding Domain Admins group to the sudoers file"
        echo "%domain\ admins      ALL=(ALL) ALL" >> /etc/sudoers
        if [ ${cusr} ]; then
		echo "%${cusr}             ALL=(ALL) ALL" >> /etc/sudoers
	fi
        echo
}


scriptdone () {
	echo
	echo -e "${RED}            SCRIPT COMPLETE           ${NC}"
	
}

# Check the hostname and domain
echo -e "Hostname is currently ${RED}${hncheck}${NC}"
while true
do

read -p  "Do we need to change the hostname to an FQDN? [y/n]: " chn
if [ $chn == "y" ]; then
        changehostname
	break
elif [ $chn == "n" ]; then 
        break
fi
done 

# Do we need to change DNS
echo -e "Current DNS settings: ${RED}"
nmcli con show ${nmcliconnection} | grep ipv4.dns 
echo -e "${NC}"
while true
do

read -p  "Do we need to change nameservers to point to the domain controllers? [y/n]: " cdns
if [ $cdns == "y" ]; then
        changedns
        break
elif [ $cdns == "n" ]; then
        break
fi
done


# Let's get the domain joined
while true
do
read -p "Do we want to join a windows domain? [y/n]: " dyn
if [ $dyn == "y" ]; then
	installdeps
	getdomaininfo
	domainjoin
	configsssd
	configsudo
	scriptdone
	break
elif [ $dyn == "n" ]; then
	echo
	echo "${RED}Not joining domain${NC}"
	echo "exiting..."
	exit
fi
done
