#!/bin/bash

# yum install httpd -y
# echo "Server number: ${server_number}" >> /var/www/html/index.html
# service httpd start
# chkconfig httpd on

sudo mkdir -p /var/www/html
sudo cd /var/www/html
sudo echo "Server number: ${server_number}" >> /var/www/html/index.html
sudo echo "Starting SimpleHTTPServer ..." >> /var/www/html/SimpleHTTPServer-log.txt
nohup sudo python -m SimpleHTTPServer 80 &
sudo echo "... SimpleHTTPServer is running" >> /var/www/html/SimpleHTTPServer-log.txt
