#!/bin/bash
# Sublime build system script ~/.config/sublime-text-3/Packages/User/

# This source file is part of the rpdev open source project
#    Copyright 2018 Ali Erkan IMREK and project authors
#    Licensed under the MIT License 





path=$(dirname $(readlink -f $0))
cd $path
source $path/vars.sh


version="$(cat $tornado_chroot/version)"
echo rplexus_app_$version.tar.gz
tar -zcvf rplexus_app_$version.tar.gz nginx_root/heap/*.js nginx_root/heap/*.map nginx_root/heap/i18n tornado_root/template/*.app.*

echo -e "\nrplexus_assets_$version.tar.gz" 
tar -zcvf rplexus_assets_$version.tar.gz nginx_root/heap/img nginx_root/heap/logo nginx_root/heap/wgt

echo -e "\nrplexus_assets_$version.tar.gz" 
tar -zcvf rplexus_src_$version.tar.gz nginx_root/heap/*.html nginx_root/heap/css tornado_root/ct_handlers tornado_root/lib tornado_root/ui_handlers tornado_root/*.py tornado_root/version tornado_root/template
