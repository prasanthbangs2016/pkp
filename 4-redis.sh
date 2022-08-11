
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>/tmp/roboshop.log
yum install redis-6.2.7 -y &>>/tmp/roboshop.log

#Update the bind from 127.0.0.1 to 0.0.0.0 in config file /etc/redis.conf & /etc/redis/redis.conf

systemctl enable redis &>>/tmp/roboshop.log
systemctl start redis &>>/tmp/roboshop.log
