component=cart
color="\e[36m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

echo -e "${color} enabling nodejs version 18 ${nocolor}"
dnf module disable nodejs -y &>>log_file
dnf module enable nodejs:18 -y &>>log_file


echo -e "${color} installing nodejs ${nocolor}"
dnf install nodejs -y &>>log_file
echo -e "${color} adding user ${nocolor}"
useradd roboshop &>>log_file

echo -e "${color} create app directory ${nocolor}"
rm -rf ${app_path} &>>log_file
mkdir ${app_path} &>>log_file

echo -e "${color} Download the application code to created app directory ${nocolor}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>log_file
cd ${app_path} &>>log_file
unzip /tmp/${component}.zip &>>log_file
echo -e "${color} download the dependencies ${nocolor}"
cd ${app_path} &>>log_file
npm install &>>log_file
echo -e "\e[33m Setting up SystemD ${component} Service ${nocolor}"
cp  /root/roboshop-shell-dup/${component}.service /etc/systemd/system/${component}.service &>>log_file


echo -e "\e[33m starting ${component} ${nocolor}"

systemctl daemon-reload &>>log_file
systemctl enable ${component} &>>log_file
systemctl start ${component} &>>log_file

