#!/bin/bash

groupadd ftpgroup
useradd -g ftpgroup -d /dev/null -s /etc ftpuser
pure-pw useradd offsec -u ftpuser -d /ftphome
pure-pw mkdb
ln -s /etc/pure-ftpd/conf/PureDB /etc/pure-ftpd/auth/60pdb
mkdir -p /ftphome
chown -R ftpuser:ftpgroup /ftphome
systemctl start pure-ftpd
systemctl status pure-ftpd
