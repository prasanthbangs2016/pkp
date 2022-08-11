echo "setting nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo "Installing nodes"
yum install nodejs -y &>>/tmp/roboshop.log

#Let's now set up the cart application.

#As part of operating system standards, we run all the applications and databases as a normal user but not with root user.

#So to run the cart service we choose to run as a normal user and that user name should be more relevant to the project. Hence we will use `roboshop` as the username to run the service.

echo "adding application user"
useradd roboshop

echo "Downloading application content"
curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip" &>>/tmp/roboshop.log
cd /home/roboshop

echo "cleaing old application content"
rm -rf cart &>>/tmp/roboshop.log

echo "Extract cart application code"
unzip -o /tmp/cart.zip &>>/tmp/roboshop.log
mv cart-main cart
cd cart

echo "Installing node js dependencies"
npm install &>>/tmp/roboshop.log

#Update SystemD service file 
    
#Update `REDIS_ENDPOINT` with REDIS server IP Address
#Update `CATALOGUE_ENDPOINT` with Catalogue server IP address

echo "configuring the cart systemd service"
mv /home/roboshop/cart/systemd.service /etc/systemd/system/cart.service
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl start cart &>>/tmp/roboshop.log
systemctl enable cart &>>/tmp/roboshop.log