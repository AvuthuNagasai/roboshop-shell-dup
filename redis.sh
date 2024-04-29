source common.sh
echo -e "\e[34m install redis repos \e[0m"
dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>/tmp/roboshop.log
stat_check $?

echo -e "\e[34m enable redis version 6 \e[0m"
dnf module enable redis:remi-6.2 -y &>>/tmp/roboshop.log
stat_check $?

echo -e "\e[34m nstall redis \e[0m"
dnf install redis -y &>>/tmp/roboshop.log

stat_check $?

echo -e "\e[34m update listening address \e[0m"
sed -i 's/127.0.0.1/0.0.0.0/' /etc/redis.conf  /etc/redis/redis.conf &>>/tmp/roboshop.log

echo -e "\e[34m starting redis \e[0m"
systemctl enable redis
systemctl start redis

stat_check $?