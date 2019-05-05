#!/bin/bash
# Docker builder
: <<'COMMENT'
   
COMMENT


path=$(dirname $(readlink -f $0))
cd $path
source $path/vars.sh

cd $nginx
sudo docker build -t $nginx_docker .

#cd $mongo
#sudo docker build -t $mongo_docker .

#cd $tornado
#sudo docker build -t $tornado_docker .

cd ..
docker network create $subnet
echo .
docker network inspect $subnet|grep Subnet

