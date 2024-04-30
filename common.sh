color="\e[36m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"
user_id=$(id -u)

if [ $user_id -ne 0 ]; then
  echo " script should be running as sudo"
  exit 1
 fi
stat_check() {
  if [ $? -eq 0 ]; then
          echo "success"
    else
          echo "failure"
    fi
}
app_presetup() {

  echo -e "${color} adding user ${nocolor}"

  id roboshop &>>log_file
  if [ $? -eq 1 ]; then
  useradd roboshop &>>log_file
  fi
  stat_check $?
  echo -e "${color} create app directory ${nocolor}"
  rm -rf ${app_path} &>>log_file
  mkdir ${app_path} &>>log_file
  stat_check $?

  echo -e "${color} Download the application code to created app directory ${nocolor}"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>log_file
  cd ${app_path} &>>log_file
  stat_check $?

  echo -e "${color} extract the content ${nocolor}"
  unzip /tmp/${component}.zip &>>log_file
  stat_check $?

}


systemd_setup() {


  echo -e "${color} Setting up SystemD ${component} Service ${nocolor}"
  cp /root/roboshop-shell-dup/${component}.service /etc/systemd/system/${component}.service &>>$log_file
  stat_check $?
  sed -i -e "s/roboshop_app_password/$roboshop_app_password/" /root/roboshop-shell-dup/$component.service
  echo -e "${color} starting ${component} ${nocolor}"
  systemctl daemon-reload &>>log_file
  systemctl enable ${component} &>>log_file
  systemctl start ${component} &>>log_file
  stat_check $?
}


nodejs() {

  echo -e "${color} enabling nodejs version 18 ${nocolor}"
  dnf module disable nodejs -y &>>log_file
  dnf module enable nodejs:18 -y &>>log_file
  stat_check $?
  echo -e "${color} installing nodejs ${nocolor}"
  dnf install nodejs -y &>>log_file
  stat_check $?
  app_presetup

  echo -e "${color} download the dependencies ${nocolor}"
  cd ${app_path} &>>log_file
  npm install &>>log_file
  stat_check $?
  systemd_setup
  stat_check $?

}


mongo_schema_setup() {
  echo -e "${color} Copy MongoDB Repo file ${nocolor}"
  cp /root/roboshop-shell-dup/mongodb.repo /etc/yum.repos.d/mongodb.repo  &>>$log_file
  stat_check $?

  echo -e "${color} Install MongoDB Client ${nocolor}"
  yum install mongodb-org-shell -y  &>>$log_file
  stat_check $?

  echo -e "${color} Load Schema ${nocolor}"
  mongo --host mongodb-dev.devopsb73.store <${app_path}/schema/$component.js  &>>$log_file
  stat_check $?
}

mysql_schema_setup() {
  echo -e "${color} Install MySQL Client ${nocolor}"
  yum install mysql -y  &>>$log_file
  stat_check $?

  echo -e "${color} Load Schema ${nocolor}"
  mysql -h mysql-dev.devopsb73.tech -uroot -p${mysql_root_password} </app/schema/${component}.sql   &>>$log_file
  stat_check $?

}

maven() {
  echo -e "${color} installing maven ${nocolor}"

  dnf install maven -y &>>$log_file
  stat_check $?
  app_presetup

  echo -e "${color} download the dependencies & build the application ${nocolor}"
  cd ${app_path}
  mvn clean package &>>$log_file
  mv target/${component}-1.0.jar ${component}.jar &>>$log_file

  mysql_schema_setup

  stat_check $?
  systemd_setup
  stat_check $?
}

python() {
  echo -e "${color} Install Python${nocolor}"
  yum install python36 gcc python3-devel -y &>>$log_file

   stat_check $?
  app_presetup
  
  echo -e "${color} Install Application Dependencies ${nocolor}"
  cd /app
  pip3.6 install -r requirements.txt &>>$log_file

   stat_check $?

   systemd_setup
   stat_check $?

   }
