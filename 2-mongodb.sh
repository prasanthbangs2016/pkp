curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>/tmp/roboshop.log

yum install -y mongodb-org &>>/tmp/roboshop.log
systemctl enable mongod &>>/tmp/roboshop.log
systemctl start mongod &>>/tmp/roboshop.log

systemctl restart mongod &>>/tmp/roboshop.log

curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>/tmp/roboshop.log

cd /tmp
unzip -o mongodb.zip &>>/tmp/roboshop.log
cd mongodb-main
mongo < catalogue.js &>>/tmp/roboshop.log
mongo < users.js &>>/tmp/roboshop.log