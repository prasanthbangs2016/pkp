#enabling exit in case of any errors
#if any command fails set -e immediately exits(man set)
set -e

#RabbitMQ is a messaging Queue which is used by some components of the applications.

#Erlang is a dependency which is needed for RabbitMQ

yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>/tmp/roboshop.log

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/roboshop.log

yum install rabbitmq-server -y &>>/tmp/roboshop.log

systemctl enable rabbitmq-server &>>/tmp/roboshop.log
systemctl start rabbitmq-server &>>/tmp/roboshop.log

#RabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect. Hence we need to create one user for the application

#Create application user

rabbitmqctl add_user roboshop roboshop123 &>>/tmp/roboshop.log
rabbitmqctl set_user_tags roboshop administrator &>>/tmp/roboshop.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/roboshop.log