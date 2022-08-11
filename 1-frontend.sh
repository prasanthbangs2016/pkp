 #!/bin/bash
 #when script get executed shebang will ignored by the interpretor

source common.sh

COMPONENT=frontend

 echo "Installing nginx"
 yum install nginx -y &>>/tmp/${Log}
 statuscheck
 

DOWNLOAD

echo "cleaning old content"
cd /usr/share/nginx/html
#when u rerun the script it will everything
rm -rf * 
statuscheck


echo "unarchive the frontend code"
unzip -o /tmp/frontend.zip &>>/tmp/${Log}
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/${COMPONENT}.conf
statuscheck

echo "start nginx service"
systemctl enable nginx &>>/tmp/${Log}
systemctl restart nginx &>>/tmp/${Log}