#enabling exit in case of any errors
#if any command fails set -e immediately exits(man set)
COMPONENT=rabbitmq
source common.sh




if [ -z "$RABBITMQ_PASSWORD" ]; then
  echo -e "\e[33m env variable RABBITMQ_PASSWORD is missing \e[0m"
  exit 1
fi

#RabbitMQ is a messaging Queue which is used by some components of the applications.

#Erlang is a dependency which is needed for RabbitMQ

echo installing erlang from repo
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>${LOG}
statuscheck

echo install rabbit mq from repo
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>${LOG}
statuscheck




echo start rabbitmq service
systemctl enable rabbitmq-server &>>${LOG}
systemctl start rabbitmq-server &>>${LOG}
statuscheck

#RabbitMQ comes with a default username / password as guest/guest. But this user cannot be used to connect. Hence we need to create one user for the application

#Create application user and adding user if not exist
rabbitmqctl list_users | grep roboshop  &>>${LOG}
if [ $? -ne 0 ]; then
  echo adding rabbitmq user in rabbitmq
  rabbitmqctl add_user roboshop ${RABBITMQ_PASSWORD} &>>${LOG}
  rabbitmqctl set_user_tags roboshop administrator &>>${LOG}
  rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${LOG}
  statuscheck
fi
