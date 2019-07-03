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
ui_app_dist_app=$ui_app_dist/heap
ui_app_i18n=$ui_app/src/i18n
ui_app_i18n_dirs="$(find $ui_app_i18n/* -type d)"

mkdir -p $ui_app_dist_app/i18n
mkdir -p $tornado_chroot/template

cd $ui_app
current="$(du -bs src dist)"
last="$(cat src.total)"

if [[ $current != $last ]]; then
    rm $ui_app_dist_app/*.js > /dev/null 2>&1
    rm $ui_app_dist_app/*.map > /dev/null 2>&1
    rm $nginx_chroot/heap/* > /dev/null 2>&1


    ./node_modules/.bin/webpack
    OUT=$?
    if ! [ $OUT -eq 0 ];then
        exit 1
    fi
    du -bs src dist > src.total

    cd $ui_app_dist_app

    app_name=user
    for js in $app_name*.js
    do [ -f "$js" ]
        echo "" > $app_name.app.html
        echo "<script src='/heap/$js' ></script>" >> $app_name.app.html
    done

    app_name=node
    for js in $app_name*.js
    do [ -f "$js" ]
        echo "" > $app_name.app.html
        echo "<script src='/heap/$js' />" >> $app_name.app.html
    done

fi


for d in $ui_app_i18n_dirs
do
    /bin/cp -uv $d/*.json $ui_app_dist_app/i18n > /dev/null 2>&1
done

/bin/cp -uv $ui_app_i18n/lang.json $ui_app_dist_app/i18n > /dev/null

mkdir -p $mongo_chroot
/bin/cp -uRv $ui_app_dist/* $nginx_chroot > /dev/null
/bin/cp -uv $rpui/* $tornado_chroot > /dev/null
/bin/cp -uRv $rpui/lib $tornado_chroot > /dev/null
/bin/cp -uRv $ui_handlers $tornado_chroot > /dev/null
/bin/cp -uv $ui_app_dist_app/*.html $tornado_chroot/template > /dev/null

#/bin/cp -uRv $rpserver/* $tornado_chroot > /dev/null


