#!/bin/bash

path=$(dirname $(readlink -f $0))
cd $path

touch /etc/yum.repos.d/nginx.repo
echo '
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
' > /etc/yum.repos.d/nginx.repo

touch /etc/yum.repos.d/mongodb.repo
echo '
[MongoDB]
name=MongoDB Repository
baseurl=http://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
' > /etc/yum.repos.d/mongodb.repo

yum install -y nginx python3 git mc firewalld  mongodb-org gcc python3-devel unzip

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3 get-pip.py
python3 -m pip install tornado motor argon2 bson

firewall-cmd --zone=public --add-service=http --permanent
firewall-cmd --zone=public --add-service=https --permanent
firewall-cmd --reload

# Let's Encrypt
# https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-centos-7
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install epel-release.noarch
yum install -y certbot python2-certbot-nginx
sed -i -e 's/localhost/rplexus.net www.rplexus.net/g' /etc/nginx/conf.d/default.conf
certbot --nginx -d rplexus.net -d www.rplexus.net

/usr/bin/cp rplexus.service /lib/systemd/system
systemctl daemon-reload

#Update service
/usr/bin/cp upservice.sh /home/admin
/usr/bin/chmod +x /home/admin/upservice.sh