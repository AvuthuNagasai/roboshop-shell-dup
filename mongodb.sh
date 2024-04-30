source common.sh
color="\e[36m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"
echo -e "${color} Setup the MongoDB repo file ${nocolor}"
cp /root/roboshop-shell-dup/mongodb.repo /etc/yum.repos.d/mongo.repo &>>$log_file

echo -e "${color} Installing mongodb \e[0m"
dnf install mongodb-org -y &>>/tmp/roboshop.log
stat_check $?


echo -e "${color} Start & Enable MongoDB Service ${nocolor}"
systemctl enable mongod &>>$log_file
systemctl start mongod &>>$log_file

echo -e "${color} updating mongodb listen address ${nocolor}"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat_check $?

echo -e "${color} Start & Enable MongoDB Service ${nocolor}"
systemctl restart mongod &>>/tmp/roboshop.log

stat_check $?