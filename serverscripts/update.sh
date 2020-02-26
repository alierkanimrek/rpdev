#!/bin/bash

path=$(dirname $(readlink -f $0))
appname=rplexus
deploy=$path/deploy
static=/usr/share/nginx
app=/usr/share/$appname
log=/var/log/$appname
uname=alierkanimrek
repo=rpui
version="$(curl https://raw.githubusercontent.com/$uname/$repo/master/src/version)"

cd $path
curl -L https://github.com/$uname/$repo/releases/download/$version/$appname_$version.tar.gz>$appname_$version.tar.gz

tar -xvf $appname_$version.tar.gz

systemctl stop rplexus
systemctl stop nginx

mkdir -p $static
mkdir -p $app/release
mkdir -p $app/backup
mkdir -p $app/outgoing
mkdir -p $log

#Backup
rm -rf $app/backup/*
cp -aRv $static/heap/css/fontawesome $app/backup
cp -av $app/release/config.conf $app/backup

#Update
rm -rf $static/heap
cp -aRv $deploy/static/* $static
cp -aRv $deploy/app/* $app/release

#Restore
cp -aRv $app/backup/fontawesome $static/heap/css
cp -av $app/backup/config.conf $app/release

chown admin:admin -R $app/release
chown admin:admin $log

systemctl start rplexus
systemctl start nginx
