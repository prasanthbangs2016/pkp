COMPONENT=redis
source common.sh



echo "set up yum repo"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG}
statuscheck

echo Installing redis
yum install redis-6.2.7 -y &>>${LOG}
statuscheck

#Update the bind from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf

echo start Redis service
systemctl enable redis &>>${LOG}
systemctl restart redis &>>${LOG}
statuscheck
