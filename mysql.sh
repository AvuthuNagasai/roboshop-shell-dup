source common.sh

echo -e "\e[33m enabling disable MySQL 8 version \e[0m"
dnf module disable mysql -y &>>/tmp/roboshop.log

stat_check $?
echo -e "\e[33m enabling disable MySQL 8 version \e[0m"
cp /root/roboshop-shell-dup/mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

echo -e "\e[33m Setup the MySQL5.7 repo file \e[0m"
dnf install mysql-community-server -y &>>/tmp/roboshop.log
 stat_check $?
echo -e "\e[33m Start MySQL Service \e[0m"
systemctl enable mysqld &>>/tmp/roboshop.log

systemctl start mysqld &>>/tmp/roboshop.log
stat_check $?

echo -e " ${color}  Setup MySQL Password  ${nocolor} "
mysql_secure_installation --set-root-pass $1 &>>/tmp/roboshop.log
stat_check $?

