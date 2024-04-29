echo -e "\e[34m Configuring YUM Repos from the script provided by vendor \e[0m"

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>/tmp/roboshop.log

echo -e "\e[34m Configuring YUM Repos for RabbitMQ. \e[0m"

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>/tmp/roboshop.log

echo -e "\e[34m installing  RabbitMQ \e[0m"

dnf install rabbitmq-server -y &>>/tmp/roboshop.log

echo -e "\e[34m Starting RabbitMQ Service \e[0m"

systemctl enable rabbitmq-server
systemctl start rabbitmq-server

echo -e "\e[34m updating RabbitMQ default username / password \e[0m"

rabbitmqctl add_user roboshop roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"