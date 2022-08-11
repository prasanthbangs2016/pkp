COMPONENT=mysql
source common.sh



if [ -z "$MYSQL_PASSWORD" ]; then
  echo -e "\e[33m env variable MYSQL_PASSWORD is missing \e[0m"
  exit 1
fi

#**Manual Steps to Install MySQL**

#As per the Application need, we are choosing MySQL 5.7 version.

#Setup MySQL Repo


echo set up mysql repo
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG}
statuscheck

echo installing mysql
yum install mysql-community-server -y &>>${LOG}
statuscheck

echo start mysql service
systemctl enable mysqld &>>${LOG}
systemctl start mysqld &>>${LOG}
statuscheck

#DEFAULT_PASSWORD=$(sudo grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
echo "show databases;" | mysql -uroot -p$MYSQL_PASSWORD &>>${LOG}
#if above commnand password is wrong we're changing the password
if [ $? -ne 0 ]; then
  echo Changing Default Password
  DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')
  echo "alter user 'root'@'localhost' identified with mysql_native_password by '$MYSQL_PASSWORD';" | mysql --connect-expired-password -uroot -p${DEFAULT_PASSWORD} &>>${LOG}
  statuscheck
fi

echo "show plugins;" | mysql -uroot -p$MYSQL_PASSWORD 2>&1 | grep validate_password &>>${LOG}
#checking plugin is available or not if not available removing it
if [ $? -eq 0 ]; then
  echo Remove Password Validate Plugin
  echo "uninstall plugin validate_password;" | mysql -uroot -p$MYSQL_PASSWORD &>>${LOG}
  statuscheck
fi

DOWNLOAD

echo "Extract & Load Schema"
cd /tmp &>>${LOG} && unzip -o mysql.zip &>>${LOG} &&  cd mysql-main &>>${LOG} && mysql -u root -p$MYSQL_PASSWORD <shipping.sql &>>${LOG}
StatusCheck


#Now a default root password will be generated and given in the log file.

#grep temp /var/log/mysqld.log 

#Next, We need to change the default root password in order to start using the database service. Use password RoboShop@1 or any other as per your choice. Rest of the options you can choose No

#mysql_secure_installation
#change mysql root password,first login to mysql and then change the password
#https://stackoverflow.com/questions/7534056/mysql-root-password-change
#ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'your_pass_here';
#echo "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'RoboShop@1';" | mysql --connect-expired-password -uroot -p$(DEFAULT_PASSWORD)



#You can check the new password working or not using the following command in MySQL
#echo "uninstall plugin validate_password;" | mysql -uroot -pRoboShop@1

#mysql -uroot -pRoboShop@1

#Once after login to MySQL prompt then run this SQL Command

#> uninstall plugin validate_password;
#**Setup Needed for Application.**

#As per the architecture diagram, MySQL is needed by

#- Shipping Service

#So we need to load that schema into the database, So those applications will detect them and run accordingly.

#o download schema, Use the following command


