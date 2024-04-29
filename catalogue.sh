source common.sh
component=catalogue

nodejs

echo -e "${color} copy mongodb repo file ${nocolor}"
cp /root/roboshop-shell-dup/mongodb.repo /etc/yum.repos.d/mongo.repo &>>$log_file

echo -e "${color} install Mongodb server ${nocolor}"
dnf install mongodb-org-shell -y &>>$log_file

echo -e "${color} Loading List of products we want to sell ${nocolor}"
mongo --host mongodb-dev.devopsb73.tech <${app_path}/schema/$component.js &>>$log_file