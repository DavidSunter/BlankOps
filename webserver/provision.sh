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

sudo tee -a /etc/nginx/sites-available/default <<EOF
server {
    listen 80;
    server_name localhost:3000;
    location / {
        proxy_pass http://localhost:8085;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
EOF

sudo chown -R www-data:www-data /var/www
sudo chmod -R 775 /var/www
sudo service nginx restart
sudo cp -R /root/workspace/David/app/. /var/www/html



#Run the app in the background of the code
#npm install
sudo npm install pm2 -g
#git clone https://github.com/razki/bezzle.vs.razki.git .
pm2 kill
#pm2 start app.js
