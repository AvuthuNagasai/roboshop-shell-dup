echo -e "\e[34m enabling nodejs version 18 \e[0m"
dnf module disable nodejs -y &>>/tmp/roboshop.log
dnf module enable nodejs:18 -y &>>/tmp/roboshop.log


echo -e "\e[34m installing nodejs \e[0m"
dnf install nodejs -y &>>/tmp/roboshop.log
echo -e "\e[34m adding user \e[0m"
useradd roboshop &>>/tmp/roboshop.log
echo -e "\e[34m create app directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[34m Download the application code to created app directory \e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log
unzip /tmp/user.zip &>>/tmp/roboshop.log
echo -e "\e[34m download the dependencies \e[0m"
cd /app &>>/tmp/roboshop.log
npm install &>>/tmp/roboshop.log
echo -e "\e[33m Setting up SystemD Catalogue Service \e[0m"
cp  /root/roboshop-shell/user.service /etc/systemd/system/user.service &>>/tmp/roboshop.log


echo -e "\e[33m starting user \e[0m"

systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable user &>>/tmp/roboshop.log
systemctl start user &>>/tmp/roboshop.log

echo -e "\e[34m copy mongodb repo file \e[0m"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log &>>/tmp/roboshop.log

echo -e "\e[34m install Mongodb server \e[0m"
dnf install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[33m Loading List of products we want to sell \e[0m"
mongo --host mongodb-dev.devopsb73.tech </app/schema/user.js &>>/tmp/roboshop.log