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
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/${COMPONENT}-devops-project/${COMPONENT}archive/main.zip" &>>/tmp/${COMPONENT}.log
    statuscheck
}
NODEJS() {
    
    echo "downloading nodejs repos"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/${COMPONENT}.log
    statuscheck


    echo "Installing nodes"
    yum install nodejs -y &>>/tmp/${COMPONENT}.log
    statuscheck

    id ${COMPONENT} & &>>/tmp/${COMPONENT}.log
    if [ $? -eq 0 ]; then
      echo "adding application user"
      useradd ${COMPONENT}
      statuscheck
    fi

    echo "Downloading ${COMPONENT} content"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/${COMPONENT}-devops-project/${COMPONENT}archive/main.zip" &>>/tmp/${COMPONENT}.log
    cd /home/${COMPONENT}
    statuscheck

    echo "cleaing old application content"
    rm -rf ${COMPONENT} &>>/tmp/${COMPONENT}.log
    statuscheck

    echo "Extract ${COMPONENT} application code"
    unzip -o /tmp/${COMPONENT}.zip &>>/tmp/${COMPONENT}.log
    mv ${COMPONENT}-main ${COMPONENT}
    cd ${COMPONENT}
    statuscheck

    echo "Downloading ${COMPONENT} app code"
    curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/${COMPONENT}-devops-project/${COMPONENT}/archive/main.zip" &>>/tmp/${COMPONENT}.log
    cd /home/${COMPONENT}
    statuscheck

    echo " Removing older application code"
    rm -rf ${COMPONENT}
    unzip -o /tmp/${COMPONENT}.zip &>>/tmp/${COMPONENT}.log
    mv ${COMPONENT}-main ${COMPONENT} 
    cd /home/${COMPONENT}/${COMPONENT}
    statuscheck

    echo "Downloading application dependencies"
    npm install &>>/tmp/${COMPONENT}.log
    statuscheck

    echo "configuring the ${COMPONENT} systemd service"
    mv /home/${COMPONENT}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
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
