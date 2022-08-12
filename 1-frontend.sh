 #!/bin/bash
 #when script get executed shebang will ignored by the interpretor
COMPONENT=frontend
source common.sh



 echo "Installing nginx"
 yum install nginx -y &>>${LOG}
 statuscheck
 

DOWNLOAD

echo "cleaning old content"
cd /usr/share/nginx/html
#when u rerun the script it will everything
rm -rf * 
statuscheck


echo "unarchive the frontend code"
unzip -o /tmp/frontend.zip &>>${LOG}
mv frontend-main/static/* .
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
statuscheck

echo "start nginx service"
systemctl restart nginx &>>${LOG}
systemctl enable nginx &>>${LOG}
statuscheck