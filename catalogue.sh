component=catalogue
color="\e[36m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

echo -e "${color} enabling nodejs version 18 ${nocolor}"
dnf module disable nodejs -y &>>$log_file
dnf module enable nodejs:18 -y &>>$log_file


echo -e "${color} installing nodejs ${nocolor}"
dnf install nodejs -y &>>$log_file
echo -e "${color} adding user ${nocolor}"
useradd roboshop &>>$log_file
echo -e "${color} create app directory ${nocolor}"
rm -rf ${app_path}
mkdir ${app_path}

echo -e "${color} Download the application code to created app directory ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip &>>$log_file
cd ${app_path}
unzip /tmp/$component.zip &>>$log_file
echo -e "${color} download the dependencies ${nocolor}"
cd ${app_path}
npm install &>>$log_file
echo -e "${color} Setting up SystemD Catalogue Service ${nocolor}"
cp  /root/roboshop-shell-dup/$component.service /etc/systemd/system/$component.service


echo -e "${color} starting catalogue ${nocolor}"

systemctl daemon-reload
systemctl enable $component &>>$log_file
systemctl start $component &>>$log_file

echo -e "${color} copy mongodb repo file ${nocolor}"
cp /root/roboshop-shell-dup/mongodb.repo /etc/yum.repos.d/mongo.repo &>>$log_file

echo -e "${color} install Mongodb server ${nocolor}"
dnf install mongodb-org-shell -y &>>$log_file

echo -e "${color} Loading List of products we want to sell ${nocolor}"
mongo --host mongodb-dev.devopsb73.tech <${app_path}/schema/$component.js &>>$log_file