#This service is responsible for payments in RoboShop e-commerce app.

#This service is written on `Python 3`, So need it to run this app.

#CentOS 7 comes with `Python 2` by default. So we need `Python 3` to be installed.

yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log

useradd roboshop

cd /home/roboshop
curl -L -s -o /tmp/payment.zip "https://github.com/roboshop-devops-project/payment/archive/main.zip" &>>/tmp/roboshop.log
unzip -o /tmp/payment.zip &>>/tmp/roboshop.log
mv payment-main payment

cd /home/roboshop/payment 
pip3 install -r requirements.txt &>>/tmp/roboshop.log

#**Note: Above command may fail with permission denied, So run as root user**

#Update the roboshop user and group id in `payment.ini` file.
#Update SystemD service file 
    
#Update `CARTHOST` with cart server ip
    
#Update `USERHOST` with user server ip 
    
#Update `AMQPHOST` with RabbitMQ server ip.

mv /home/roboshop/payment/systemd.service /etc/systemd/system/payment.service
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable payment &>>/tmp/roboshop.log
systemctl start payment &>>/tmp/roboshop.log