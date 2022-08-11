#Shipping service is responsible for finding the distance of the package to be shipped and calculate the price based on that.

#Shipping service is written in Java, Hence we need to install Java.

#Install Maven, This will install Java too

yum install maven -y &>>/tmp/roboshop.log

#As per the standard process, we always run the applications as a normal user.

useradd roboshop

cd /home/roboshop
curl -s -L -o /tmp/shipping.zip "https://github.com/roboshop-devops-project/shipping/archive/main.zip" &>>/tmp/roboshop.log
unzip -o /tmp/shipping.zip &>>/tmp/roboshop.log
mv shipping-main shipping
cd shipping
mvn clean package &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar

#Update SystemD Service file 
    
#Update `CARTENDPOINT` with Cart Server IP.
    
#Update `DBHOST` with MySQL Server IP

mv /home/roboshop/shipping/systemd.service /etc/systemd/system/shipping.service
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl start shipping &>>/tmp/roboshop.log
systemctl enable shipping &>>/tmp/roboshop.log
