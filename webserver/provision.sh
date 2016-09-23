#!/bin/bash

cd ~
sudo apt-get update
sudo apt-get install git nginx nodejs npm build-essential nodejs-legacy -y

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update
sudo apt-get install -y mongodb-org
sudo apt-get install -y mongodb-org=3.2.9 mongodb-org-shell=3.2.9 mongodb-org-mongos=3.2.9 mongodb-org-tools=3.2.9

sudo tee -a /etc/systemd/system/mongodb.service <<EOF
[Unit]
Description=High-performance, schema-free document-oriented database
After=network.target

[Service]
User=mongodb
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf

[Install]
WantedBy=multi-user.target
EOF
sudo service mongod start

#Add a user and group
#adduser --disabled-password --gecos "" dave
#addgroup webadmin
#adduser dave webadmin
#sudo chown -R dave:webadmin /var/www/html
#usermod -g webadmin www-data

sudo cp ~/servers/webserver/default /etc/nginx/sites-available/default -f
sudo chown -R www-data:www-data /var/www
sudo chmod -R 775 /var/www
sudo service nginx restart

#Run the app in the background of the code
#npm install
sudo npm install pm2 -g
#git clone https://github.com/razki/bezzle.vs.razki.git .
pm2 kill
#pm2 start app.js
