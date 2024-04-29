component=catalogue
color="\e[36m"
nocolor="\e[0m"

echo -e "${color} enabling nodejs version 18 ${nocolor}"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y


echo -e "${color} installing nodejs ${nocolor}"
dnf install nodejs -y
echo -e "${color} adding user ${nocolor}"
useradd roboshop
echo -e "${color} create app directory ${nocolor}"
rm -rf /app
mkdir /app

echo -e "${color} Download the application code to created app directory ${nocolor}"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip
cd /app
unzip /tmp/$component.zip
echo -e "${color} download the dependencies ${nocolor}"
cd /app
npm install
echo -e "\e[33m Setting up SystemD Catalogue Service ${nocolor}"
cp  /root/roboshop-shell/$component.service /etc/systemd/system/$component.service


echo -e "\e[33m starting catalogue ${nocolor}"

systemctl daemon-reload
systemctl enable $component
systemctl start $component

echo -e "${color} copy mongodb repo file ${nocolor}"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "${color} install Mongodb server ${nocolor}"
dnf install mongodb-org-shell -y

echo -e "\e[33m Loading List of products we want to sell ${nocolor}"
mongo --host mongodb-dev.devopsb73.tech </app/schema/$component.js