#!/bin/bash

# Simple script to register client with FWH spacewalk servers

# Rev 3 - 2017-12-11

# Are we root?
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root - USE SUDO!" 
   exit 1
fi

# exit on error
set -e

# Do we install? 
while true; do
read -p "Install Spacewalk client v2.3-2 for CentOS 7? (y/n) :" -n 1 -r install
	case "$install" in 
  		y|Y ) install="y"; echo; break;;
  		n|N ) install="n"; echo; break;;
  		* ) echo "      invalid - Answer y or n";;
	esac
done




if [ $install == "y" ]; then
echo
read -p "Spacewalk server FQDN hostname? (example: spacewalk.something.something): " server
read -p "Spacewalk Activation Key: " key

	
	echo	
	echo "Installing RH CA Trusted Certificate"
	echo

	if rpm -qa | grep rhn-org-trusted-ssl-cert-1.0-2
	        then
	echo "rhn-org-trusted-ssl-cert-1.0-2 is already installed..."
		else	
	curl -o /tmp/rhn-org-trusted-ssl-cert-1.0-2.noarch.rpm http://${server}/pub/rhn-org-trusted-ssl-cert-1.0-2.noarch.rpm
	yum -y install /tmp/rhn-org-trusted-ssl-cert-1.0-2.noarch.rpm	
		fi
        echo
        echo "Downloading and Installing client..."
        echo

	if rpm -qa | grep spacewalk-client-repo-2.3-2.el7
		then
	echo "spacewalk-client-repo-2.3-2.el7.noarch.rpm already installed..."
		else

	curl -o /tmp/spacewalk-client-repo-2.3-2.el7.noarch.rpm http://yum.spacewalkproject.org/2.3-client/RHEL/7/x86_64/spacewalk-client-repo-2.3-2.el7.noarch.rpm
	yum -y install /tmp/spacewalk-client-repo-2.3-2.el7.noarch.rpm
		fi
	if rpm -qa | grep yum-rhn-plugin
		then
	echo "yum plugin installed..."
		else
	yum -y install yum-rhn-plugin
		fi

	echo 
	echo "Registering with Spacewalk..."
	echo 
 	if rhnreg_ks --activationkey ${key} --serverUrl https://${server}/XMLRPC
		then 	
			echo "Backing up /etc/yum.repos.d/ to the /root directory.."
			tar -cpvf /root/yum.repos.d_$(date +%Y-%m-%d-%H-%M-%S).tar /etc/yum.repos.d
			echo "Disabling all repos except for spacewalk"
			sed -i 's/enabled.*//g' /etc/yum.repos.d/*	
			sed -i '/name=/a enabled=0' /etc/yum.repos.d/*
			echo""
			echo "Done"
			echo ""
		else
	echo
	echo "Could not register with spacewalk server..."
	echo 	
		exit 1
		fi
	
elif [ $install == "n" ]; then
	echo 
	echo "Cancelled"	
        echo "exiting..."
        echo

	exit
fi
exit
