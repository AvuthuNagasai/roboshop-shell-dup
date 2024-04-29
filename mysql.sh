echo -e "\e[33m enabling disable MySQL 8 version \e[0m"
dnf module disable mysql -y &>>/tmp/roboshop.log


echo -e "\e[33m enabling disable MySQL 8 version \e[0m"
cp /root/roboshop-shell/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

echo -e "\e[33m Setup the MySQL5.7 repo file \e[0m"
dnf install mysql-community-server -y &>>/tmp/roboshop.log

echo -e "\e[33m Start MySQL Service \e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log

systemctl start mysqld &>>/tmp/roboshop.log

echo -e "\e[33m Start change the default root password  \e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
echo -e "\e[33m check the new password working or not  \e[0m"
mysql -uroot -pRoboShop@1