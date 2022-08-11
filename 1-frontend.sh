 #!/bin/bash
 #when script get executed shebang will ignored by the interpretor
 echo "Installing nginx"
 yum install nginx -y &>>/tmp/roboshop.log
 


 echo "start nginx service"
 systemctl enable nginx &>>/tmp/roboshop.log
 systemctl start nginx &>>/tmp/roboshop.log

 echo "download the frontend code"

 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>/tmp/roboshop.log

 cd /usr/share/nginx/html
 #when u rerun the script it will everything
 rm -rf * 
 echo "unarchive the frontend code"
 unzip -o /tmp/frontend.zip &>>/tmp/roboshop.log
 mv frontend-main/static/* .
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf

systemctl restart nginx &>>/tmp/roboshop.log