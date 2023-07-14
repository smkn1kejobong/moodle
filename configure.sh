#!/bin/bash
myuser=$(whoami)

sudo apt-get update
sudo apt -y install software-properties-common
sudo apt-get update
sudo apt-get install -y nginx apache2-utils postgresql zip unzip php7.4 php7.4-fpm php7.4-pgsql php7.4-memcache php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath

sudo systemctl start php7.4-fpm
sudo systemctl start postgresql
sudo systemctl enable nginx
sudo systemctl enable php7.4-fpm
sudo systemctl enable postgresql
clear

echo " _      ____  ____  ____  _     _____ "
echo "/ \__/|/  _ \/  _ \/  _ \/ \   /  __/ "
echo "| |\/||| / \|| / \|| | \|| |   |  \   "
echo "| |  ||| \_/|| \_/|| |_/|| |_/\|  /_  "
echo "\_/  \|\____/\____/\____/\____/\____\ "
echo "Script Builder by Github(@shinau21)"
echo ""
read -p "Masukan Versi Moodle : " version
read -p "Masukan TimeZone : " timezone
read -p "Masukan User DB : " userdb
read -ps "Masukan Pass DB : " passdb
read -p "Masukan DB : " dbname

sudo timedatectl set-timezone ${timezone}
sudo cp conf/server.conf /etc/nginx/sites-available/
sudo sed -i "s#/var/www#${HOME}#g" /etc/nginx/sites-available/server.conf
sudo ln -s /etc/nginx/sites-available/server.conf /etc/nginx/sites-enabled/server.conf

sudo usermod -a -G www-data ${myuser}
sudo su postgres <<EOF
psql -c 'create database ${dbname};'
psql -c "create user ${userdb} with encrypted password '${passdb}';"
psql -c 'grant all privileges on database ${dbname} to ${userdb};'
EOF

sudo rm /etc/nginx/sites-enabled/default

cd ~/
curl https://download.moodle.org/download.php/stable${version}/moodle-latest-${version}.zip
unzip moodle-latest-${version}.zip
cd ~/moodle/
cp config-dist.php config.php
sed -i "s#'moodle'#'${dbname}'#g" config.php
sed -i "s#'username'#'${userdb}'#g" config.php
sed -i "s#'password'#'${passdb}'#g" config.php
chown -R www-data.www-data ~/moodle/
chmod -R 755 ~/moodle/

sudo systemctl restart nginx

clear
echo " _      ____  ____  ____  _     _____ "
echo "/ \__/|/  _ \/  _ \/  _ \/ \   /  __/ "
echo "| |\/||| / \|| / \|| | \|| |   |  \   "
echo "| |  ||| \_/|| \_/|| |_/|| |_/\|  /_  "
echo "\_/  \|\____/\____/\____/\____/\____\ "
echo "Script Builder by Github(@shinau21)"
echo ""
echo "Build Selesai"
