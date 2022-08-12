statuscheck() {
    if [ $? -eq 0 ]; then
      echo -e "\e[32mSuccess\e[0m"
    else
      echo -e "\e[31mfailure\e[0m"
      exit 1
    fi
}

DOWNLOAD() {
    echo "Downloading ${COMPONENT} content"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>/tmp/${COMPONENT}.log
    statuscheck
}

APP_USER_SETUP() {
  id roboshop &>>${LOG}
  if [ $? -ne 0 ]; then
    echo Adding Application User
    useradd roboshop &>>${LOG}
    statuscheck
  fi
}

APP_CLEAN() {
  echo Cleaning old application content
  cd /home/roboshop &>>${LOG} && rm -rf ${COMPONENT} &>>${LOG}
  statuscheck
  
  echo Extract Application Archive
  unzip -o /tmp/${COMPONENT}.zip &>>${LOG} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG} && cd ${COMPONENT} &>>${LOG}
  statuscheck
}

SYSTEMD() {

  echo update systemd config
  sed -i -e 's/MONGO_DNSNAME/mongodb-dev.roboshop.internal/' /etc/systemd/system/${COMPONENT}.service &>>${LOG}
  statuscheck

  echo configuring ${COMPONENT} systemD service
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/shipping.service
  systemctl daemon-reload &>>/tmp/roboshop.log
  systemctl start shipping &>>/tmp/roboshop.log
  systemctl enable shipping &>>/tmp/roboshop.log
  statuscheck


}



NODEJS() {
    
    echo "downloading nodejs repos"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/${COMPONENT}.log
    statuscheck


    echo "Installing nodes"
    yum install nodejs -y &>>/tmp/${COMPONENT}.log
    statuscheck

    APP_USER_SETUP
    DOWNLOAD
    APP_CLEAN

    echo "Downloading application dependencies"
    npm install &>>/tmp/${COMPONENT}.log
    statuscheck

    echo "configuring the ${COMPONENT} systemd service"
    mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
    systemctl daemon-reload &>>/tmp/${COMPONENT}.log
    systemctl start ${COMPONENT} &>>/tmp/${COMPONENT}.log
    systemctl enable ${COMPONENT} &>>/tmp/${COMPONENT}.log
    statuscheck
 

}
#getting current running user id
USER_ID=$(id -u)
if [ $USER_ID -ne 0 ]; then
  echo -e "\e[32m You should run this script as root user or sudo\e[0"
  exit 1
fi

LOG=/tmp/${COMPONENT}.log
rm -rf ${LOG}

JAVA() {
  echo install maven
  yum install maven -y &>>${LOG}
  statuscheck
  APP_USER_SETUP
  DOWNLOAD
  APP_CLEAN
  echo shipping clean package with maven
  mvn clean package &>>${LOG}
  mv target/shipping-1.0.jar shipping.jar
  statuscheck
  SYSTEMD
  

}

PYTHON() {
  echo installing python
  yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log
  statuscheck

  APP_USER_SETUP
  DOWNLOAD
  APP_CLEAN
  
  echo install python dependencies
  cd /home/roboshop/payment 
  pip3 install -r requirements.txt &>>${LOG}
  statuscheck

  SYSTEMD
}
