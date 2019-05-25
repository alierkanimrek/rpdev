#!/bin/bash
# Sublime build system script ~/.config/sublime-text-3/Packages/User/

# This source file is part of the rpdev open source project
#    Copyright 2018 Ali Erkan IMREK and project authors
#    Licensed under the MIT License 





path=$(dirname $(readlink -f $0))
cd $path
source $path/vars.sh


rpserver=$path/../rpserver/src
rpui=$path/../rpui/src
ui_app=$rpui/ui_app
ui_handlers=$rpui/ui_handlers

ui_app_dist=$ui_app/dist
ui_app_dist_app=$ui_app_dist/app
ui_app_i18n=$ui_app/src/i18n
ui_app_i18n_dirs="$(find $ui_app_i18n/* -type d)"

mkdir -p $ui_app_dist_app/i18n


cd $ui_app
current="$(du -bs src)"
last="$(cat src.total)"

if [[ $current != $last ]]; then
    rm $ui_app_dist_app/*.js
    rm $ui_app_dist_app/*.map
    rm $nginx_chroot/app/*
    rm $tornado_chroot/app/*

    ./node_modules/.bin/webpack
    OUT=$?
    if ! [ $OUT -eq 0 ];then
        exit 1
    fi
    du -bs src > src.total

    cd $ui_app_dist_app

    app_name=user
    for js in $app_name*.js
    do [ -f "$js" ]
        echo "" > $app_name.app.html
        echo "<script src='/app/$js' ></script>" >> $app_name.app.html
    done

    app_name=node
    for js in $app_name*.js
    do [ -f "$js" ]
        echo "" > $app_name.app.html
        echo "<script src='/app/$js' />" >> $app_name.app.html
    done

fi


for d in $ui_app_i18n_dirs
do
    /bin/cp -uv $d/*.json $ui_app_dist_app/i18n
done

/bin/cp -uv $ui_app_i18n/lang.json $ui_app_dist_app/i18n


/bin/cp -uRv $rpserver/* $tornado_chroot
/bin/cp -uRv $ui_handlers $tornado_chroot
/bin/cp -uRv $ui_app_dist/* $tornado_chroot
/bin/cp -uRv $ui_app_dist/* $nginx_chroot
