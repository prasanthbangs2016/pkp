COMPONENT=catalogue
source common.sh



sed -i -e 's/MONGO_DNSNAME/mongodb-dev.roboshop.internal/' /etc/systemd/system/${COMPONENT}.service &>>${LOG}
statuscheck

NODEJS




