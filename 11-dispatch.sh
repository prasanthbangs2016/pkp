#Dispatch is the service which dispatches the product after purchase. It is written in GoLang, So wanted to install GoLang.

yum install golang -y &>>/tmp/roboshop.log

useradd roboshop

curl -L -s -o /tmp/dispatch.zip https://github.com/roboshop-devops-project/dispatch/archive/refs/heads/main.zip
unzip -o /tmp/dispatch.zip &>>/tmp/roboshop.log
mv dispatch-main dispatch 
cd dispatch 
go mod init dispatch &>>/tmp/roboshop.log
go get &>>/tmp/roboshop.log
go build &>>/tmp/roboshop.log

#Update the systemd file and configure the dispatch service in systemd

mv /home/roboshop/dispatch/systemd.service /etc/systemd/system/dispatch.service
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable dispatch &>>/tmp/roboshop.log
systemctl start dispatch &>>/tmp/roboshop.log