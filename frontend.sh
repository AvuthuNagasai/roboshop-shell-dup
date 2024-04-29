echo -e "\e[31m Installing NGINX \e[0m"
yum install nginx -y &>>/tmp/roboshop.log

echo -e "\e[31m removing old app content\e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log

echo -e "\e[32m download frontend content\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[31m extracting frontend content\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>/tmp/roboshop.log

## we need to copy config file
cp /root/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[31m starting NGINX server\e[0m"
systemctl enable nginx
systemctl start nginx