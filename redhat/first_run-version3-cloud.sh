#!/bin/bash

# Quick startup for setting up a new VM on current arch. 
# Puppet/kickstart/PXE is a better option - putting it on backlog
# but for now this script can run on start up to 
# ease common tasks with cloning this CentOS 7 Template.
#
# For use with CentOS/RHEL 7
#


# Are we root?
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root - USE SUDO!"
   exit 1
fi



echo 
echo "Starting first login script..."
sleep 4

echo
#echo "Warning! Deleting sshd keys. Restarting sshd will regenerate new keys in /etc/ssh."
#echo "Delete your fingerpirint in your known_hosts file if you have previously connected to this machine. "
# Delete the keys
#rm -rf /etc/ssh/*key*

# Restart ssh to regenerate
#systemctl restart sshd
#echo
#echo
#echo "Get sshd status..."
#systemctl status sshd
#echo 
#echo
#echo "Get the sshd log from journalctl..."
#journalctl --since -60 -r -u sshd

# Make journald persistant on reboots.
echo
echo "Making the journal persistant on reboots..."
mkdir -p /var/log/journal
chown root:systemd-journal /var/log/journal
chmod 2755 /var/log/journal
sleep 2
echo
echo
echo 
echo 

#echo "This script will get some basics setup.Use control-C to break"
#echo "There are no defaults configured, you must answer all questions."
#echo "Let's start with networking"

# Get the network info
read -p "Hostname: " hostname
read -p "Domain: " domain
 Verify
echo
echo "You entered: "
echo "Hostname: $hostname"
echo "Domain: $domain"
read -p "Is this correct? [y/n] " c1


# Set the hostname
hostnamectl set-hostname ${hostname}.${domain}
hostnamectl status


# If all is good, we will update this system. 
# Future plans for spacewalk will change this.


if [ $c1 == "y" ]; then 
	echo
	echo "Updating the system...."
	echo
	sleep 3
	yum update -y		
else 
	echo 
	echo "Unable to use this script. Please configure manually."
	echo
	exit
fi


echo "Installing a few packages...."
	yum -y install bash-completion yum-utils policycoreutils-python libsemanage-devel setools checkpolicy vim-enhanced psmisc ncurses net-tools bind-utils elinks tcpdump traceroute vim-enhanced mlocate
echo 


echo "

OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
O					O
O	Changing Root Password		O
O					O
00000000000000000000000000000000000000000

"
passwd




#echo
#echo "Remove script from startup.."
#	sed -i 's/^\/root\/first_run.sh/#/' /root/.bash_profile
#echo "Remove execute bit from first_run.sh script.."
#	chmod -x /root/first_run.sh
#echo
# Restart journald 

killall -USR1 systemd-journald

echo "System should be rebooted after update."
echo
read -p "Reboot now [y/n]:" rbn
if [ $rbn == "y" ]; then
	reboot
else
	exit	
fi

exit 

