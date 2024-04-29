component=catalogue


echo -e "\e[34m enabling nodejs version 18 \e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y


echo -e "\e[34m installing nodejs \e[0m"
dnf install nodejs -y
echo -e "\e[34m adding user \e[0m"
useradd roboshop
echo -e "\e[34m create app directory \e[0m"
rm -rf /app
mkdir /app

echo -e "\e[34m Download the application code to created app directory \e[0m"
curl -o /tmp/$component.zip https://roboshop-artifacts.s3.amazonaws.com/$component.zip
cd /app
unzip /tmp/$component.zip
echo -e "\e[34m download the dependencies \e[0m"
cd /app
npm install
echo -e "\e[33m Setting up SystemD Catalogue Service \e[0m"
cp  /root/roboshop-shell/$component.service /etc/systemd/system/$component.service


echo -e "\e[33m starting catalogue \e[0m"

systemctl daemon-reload
systemctl enable $component
systemctl start $component

echo -e "\e[34m copy mongodb repo file \e[0m"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[34m install Mongodb server \e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[33m Loading List of products we want to sell \e[0m"
mongo --host mongodb-dev.devopsb73.tech </app/schema/$component.js