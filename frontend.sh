color="\e[36m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"


echo -e "${color} Installing NGINX ${nocolor}"
yum install nginx -y &>>$log_file

echo -e "${color} removing old app content${nocolor}"
rm -rf /usr/share/nginx/html/* &>>$log_file

echo -e "\e[32m download frontend content${nocolor}"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$log_file

echo -e "${color} extracting frontend content${nocolor}"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$log_file

## we need to copy config file
cp /root/roboshop-shell-dup/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "${color} starting NGINX server${nocolor}"
systemctl enable nginx
systemctl start nginx