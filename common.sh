color="\e[36m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

# shellcheck disable=SC1073
app_presetup() {

  echo -e "${color} adding user ${nocolor}"
  useradd roboshop &>>log_file
  if [ $? -eq 0 ]; then
        echo "success"
  else
        echo "failure"
  fi
  echo -e "${color} create app directory ${nocolor}"
  rm -rf ${app_path} &>>log_file
  mkdir ${app_path} &>>log_file
  if [ $? -eq 0 ]; then
        echo "success"
  else
        echo "failure"
  fi

  echo -e "${color} Download the application code to created app directory ${nocolor}"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>log_file
  cd ${app_path} &>>log_file

  if [ $? -eq 0 ]; then
        echo "success"
  else
        echo "failure"
  fi

  echo -e "${color} extract the content ${nocolor}"
  unzip /tmp/${component}.zip &>>log_file
  if [ $? -eq 0 ]; then
        echo "success"
  else
        echo "failure"
  fi

}


systemd_setup() {


  echo -e "${color} Setting up SystemD ${component} Service ${nocolor}"
  cp /root/roboshop-shell-dup/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  if [ $? -eq 0 ]; then
        echo "success"
  else
        echo "failure"
  fi

  echo -e "${color} starting ${component} ${nocolor}"
  systemctl daemon-reload &>>log_file
  systemctl enable ${component} &>>log_file
  systemctl start ${component} &>>log_file
  if [ $? -eq 0 ]; then
        echo "success"
  else
        echo "failure"
  fi
}


nodejs() {

  echo -e "${color} enabling nodejs version 18 ${nocolor}"
  dnf module disable nodejs -y &>>log_file
  dnf module enable nodejs:18 -y &>>log_file

  echo -e "${color} installing nodejs ${nocolor}"
  dnf install nodejs -y &>>log_file

  app_presetup

  echo -e "${color} download the dependencies ${nocolor}"
  cd ${app_path} &>>log_file
  npm install &>>log_file

  systemd_setup


}

mongo_schema_setup(){

  echo -e "${color} copy mongodb repo file ${nocolor}"
  cp /root/roboshop-shell-dup/mongodb.repo /etc/yum.repos.d/mongo.repo &>>$log_file

  echo -e "${color} install Mongodb server ${nocolor}"
  dnf install mongodb-org-shell -y &>>$log_file

  echo -e "${color} Loading List of products we want to sell ${nocolor}"
  mongo --host mongodb-dev.devopsb73.tech <${app_path}/schema/$component.js &>>$log_file
}


mysql_schema_setup() {

  echo -e "${color} installing mysql ${nocolor}"
  dnf install mysql -y &>>$log_file
  echo -e "${color} Loading Schema ${nocolor}"
  mysql -h mysql-dev.devopsb73.tech -uroot -pRoboShop@1 < ${app_path}/schema/${component}.sql &>>$log_file


}

maven() {
  echo -e "${color} installing maven ${nocolor}"

  dnf install maven -y &>>$log_file

  app_presetup

  echo -e "${color} download the dependencies & build the application ${nocolor}"
  cd ${app_path}
  mvn clean package &>>$log_file
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file

  mysql_schema_setup

  systemd_setup

}

python() {
  echo -e "${color} Install Python${nocolor}"
  yum install python36 gcc python3-devel -y &>>$log_file
   # shellcheck disable=SC1009
   if [ $? -eq 0 ]; then
      echo "success"
   else
      echo "failure"
   fi
  app_presetup
  
  echo -e "${color} Install Application Dependencies ${nocolor}"
  cd /app
  pip3.6 install -r requirements.txt &>>$log_file
   # shellcheck disable=SC1046
   if [ $? -eq 0 ]; then
       echo "success"
   else
       echo "failure"
   fi

   systemd_setup


   }
