#!/bin/bash


nginx=$path/nginx
nginx_docker=rp_nginx
nginx_run=rp_nginx.server
nginx_chroot=$path/nginx_root
nginx_root=/usr/share/nginx/html
nginx_logs='docker logs '$nginx_run

network_logs='docker network inspect rplexus-net|grep IPv4 -B 3'

tornado=$path/tornado
tornado_docker=rp_tornado
tornado_run=rp_tornado.server
tornado_chroot=$path/tornado_root
tornado_root=/usr/src/app

mongo=$path/mongo
mongo_docker=rp_mongo
mongo_run=rp_mongo.server
mongo_chroot=$path/mongo_db
mongo_root=/data/db
mongo_logs='docker logs '$mongo_run 

subnet=rplexus-net