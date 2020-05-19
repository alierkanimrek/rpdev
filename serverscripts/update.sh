#!/bin/bash

path=$(dirname $(readlink -f $0))
appname=rplexus
static=/usr/share/nginx/html
app=/usr/share/$appname
log=/var/log/$appname
uname=alierkanimrek
repo=rpui
version="$(curl https://raw.githubusercontent.com/$uname/$repo/master/src/version)"

cd $path
curl -L https://github.com/$uname/$repo/releases/download/$version/$appname\_app\_$version.tar.gz>$appname\_app\_$version.tar.gz
OUT=$?
if ! [ $OUT -eq 0 ];then
    exit 1
fi
curl -L https://github.com/$uname/$repo/releases/download/$version/$appname\_assets\_$version.tar.gz>$appname\_assets\_$version.tar.gz
OUT=$?
if ! [ $OUT -eq 0 ];then
    exit 1
fi
curl -L https://github.com/$uname/$repo/releases/download/$version/$appname\_src\_$version.tar.gz>$appname\_src\_$version.tar.gz
OUT=$?
if ! [ $OUT -eq 0 ];then
    exit 1
fi

tar -xvf $appname\_src\_$version.tar.gz 2>&1 > /dev/null
OUT=$?
if ! [ $OUT -eq 0 ];then
    exit 1
fi
tar -xvf $appname\_assets\_$version.tar.gz 2>&1 > /dev/null
OUT=$?
if ! [ $OUT -eq 0 ];then
    exit 1
fi
tar -xvf $appname\_app\_$version.tar.gz 2>&1 > /dev/null
OUT=$?
if ! [ $OUT -eq 0 ];then
    exit 1
fi

systemctl stop nginx
systemctl stop rplexus
sleep 3

mkdir -p $static
mkdir -p $app/release
mkdir -p $app/backup
mkdir -p $log
mkdir -p $app/outgoing

#Backup
rm -rf $app/backup/* 2>&1 > /dev/null
cp -av $app/release/config.conf $app/backup 2>&1 > /dev/null

#Update
rm -rf $static/heap 2>&1 > /dev/null
rm -rf $app/release/* 2>&1 > /dev/null
cp -aRv nginx_root/heap $static 2>&1 > /dev/null
cp -aRv tornado_root/* $app/release 2>&1 > /dev/null

#Restore
cp -av $app/backup/config.conf $app/release 2>&1 > /dev/null

chown admin:admin -R $app/release
chown admin:admin -R $app/outgoing
chown admin:admin -R $static/heap
chown admin:admin $log

systemctl start rplexus
systemctl start nginx
sleep 3
systemctl status rplexus
systemctl status nginx

#Clean
/bin/rm -rf nginx_root
/bin/rm -rf tornado_root

