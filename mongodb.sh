source common.sh
echo -e "\e[33m Setup the MongoDB repo file \e[0m"
cp /root/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[31m Installing mongodb \e[0m"
dnf install mongodb-org -y &>>/tmp/roboshop.log
stat_check $?


echo -e "\e[31m Start & Enable MongoDB Service \e[0m"
systemctl enable mongod &>>/tmp/roboshop.log
systemctl start mongod &>>/tmp/roboshop.log

echo -e "\e[31m updating mongodb listen address \e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
stat_check $?

echo -e "\e[31m Start & Enable MongoDB Service \e[0m"
systemctl restart mongod &>>/tmp/roboshop.log

stat_check $?