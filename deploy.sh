#!/bin/bash
# Sublime build system script ~/.config/sublime-text-3/Packages/User/

# This source file is part of the rpdev open source project
#    Copyright 2018 Ali Erkan IMREK and project authors
#    Licensed under the MIT License 





path=$(dirname $(readlink -f $0))
cd $path
source $path/vars.sh


deploy=$path/deploy
app=$deploy/app
static=$deploy/static

rm -rf $deploy
mkdir -p $app
mkdir -p $static
cp -aRv $tornado_chroot/* $app
cp -aRv $nginx_chroot/* $static
find $app | grep -E "(__pycache__|\.pyc|\.pyo$)" | xargs rm -rf
rm -rf $static/heap/css/fontawesome
rm $app/*.log*
rm $app/outgoing/*
rm $app/*.conf
chmod -R 775 $deploy
tar -zcvf rplexus.tar.gz deploy
rm -rf $deploy