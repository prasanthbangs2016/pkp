#**Manual Steps to Install MySQL**

#As per the Application need, we are choosing MySQL 5.7 version.

#Setup MySQL Repo

curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>/tmp/roboshop.log

yum install mysql-community-server -y &>>/tmp/roboshop.log

systemctl enable mysqld &>>/tmp/roboshop.log
systemctl start mysqld &>>/tmp/roboshop.log

#DEFAULT_PASSWORD=$(sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
DEFAULT_PASSWORD=$('A temporary password' /var/log/mysqld.log | awk '{print $NF}')
#Now a default root password will be generated and given in the log file.

grep temp /var/log/mysqld.log 

#Next, We need to change the default root password in order to start using the database service. Use password RoboShop@1 or any other as per your choice. Rest of the options you can choose No

#mysql_secure_installation
#change mysql root password,first login to mysql and then change the password
#https://stackoverflow.com/questions/7534056/mysql-root-password-change
#ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_pass_here';
echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p$(DEFAULT_PASSWORD)



#You can check the new password working or not using the following command in MySQL
echo "uninstall plugin validate_password;" | mysql -uroot -pRoboShop@1

#mysql -uroot -pRoboShop@1

#Once after login to MySQL prompt then run this SQL Command

#> uninstall plugin validate_password;
#**Setup Needed for Application.**

#As per the architecture diagram, MySQL is needed by

#- Shipping Service

#So we need to load that schema into the database, So those applications will detect them and run accordingly.

#o download schema, Use the following command

curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>/tmp/roboshop.log

cd /tmp
unzip -o mysql.zip
cd mysql-main
mysql -u root -pRoboShop@1 <shipping.sql &>>/tmp/roboshop.log