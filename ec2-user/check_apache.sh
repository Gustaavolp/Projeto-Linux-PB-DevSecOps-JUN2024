#!/bin/bash 
STATUS=$(systemctl is-active httpd)
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
if [ "$STATUS" = "active" ]; then
     echo "$TIMESTAMP Apache ONLINE - Tudo OK" >> /home/ec2-user/efs/Gustavo/apache_online.log
else
     echo "$TIMESTAMP Apache OFFLINE - Verifique o serviço" >> /home/ec2-user/efs/Gustavo/apache_offline.log
fi
