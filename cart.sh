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
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log
unzip /tmp/cart.zip &>>/tmp/roboshop.log
echo -e "\e[34m download the dependencies \e[0m"
cd /app &>>/tmp/roboshop.log
npm install &>>/tmp/roboshop.log
echo -e "\e[33m Setting up SystemD Cart Service \e[0m"
cp  /root/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>/tmp/roboshop.log


echo -e "\e[33m starting cart \e[0m"

systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable cart &>>/tmp/roboshop.log
systemctl start cart &>>/tmp/roboshop.log

