COMPONENT=mongodb
source common.sh



echo "set up mongodb"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>${LOG}
statuscheck

echo "installing mongodb"
yum install -y mongodb-org &>>${LOG}
statuscheck

echo start mongodb service
systemctl enable mongod &>>${LOG}
systemctl start mongod &>>${LOG}
statuscheck

echo update mongodb listen address
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${LOG}
statuscheck

DOWNLOAD

echo "extract Schemafile"
cd /tmp
unzip -o mongodb.zip &>>${LOG}
statuscheck

echo Load schema
cd mongodb-main
mongo < catalogue.js &>>${LOG}
mongo < users.js &>>${LOG}
statuscheck