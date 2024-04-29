echo -e "\e[33m installing maven \e[0m"

dnf install maven -y &>>/tmp/roboshop.log

echo -e "\e[33m adding user \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[34m create app directory \e[0m"
rm -rf /app
mkdir /app &>>/tmp/roboshop.log

echo -e "\e[33m Download the application code to created app directory \e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>/tmp/roboshop.log
cd /app
unzip /tmp/shipping.zip &>>/tmp/roboshop.log

echo -e "\e[33m download the dependencies & build the application \e[0m"
cd /app
mvn clean package &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar &>>/tmp/roboshop.log

echo -e "\e[33m installing mysql \e[0m"
dnf install mysql -y &>>/tmp/roboshop.log

echo -e "\e[33m Loading Schema \e[0m"
mysql -h mysql-dev.devopsb73.tech -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>/tmp/roboshop.log

echo -e "\e[33m Setting up SystemD shipping Service \e[0m"
cp /root/roboshop-shell/shipping.service /etc/systemd/system/shipping.service &>>/tmp/roboshop.log

echo -e "\e[33m starting shipping \e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable shipping &>>/tmp/roboshop.log
systemctl start shipping &>>/tmp/roboshop.log


