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
ct_handlers=$rpui/ct_handlers

ui_app_dist=$ui_app/dist
ui_app_dist_app=$ui_app_dist/heap
ui_app_i18n=$ui_app/src/i18n
ui_app_i18n_dirs="$(find $ui_app_i18n/* -type d)"
apps=(user node front admin)

mkdir -p $nginx_chroot/heap/i18n 2>&1 > /dev/null
mkdir -p $mongo_chroot 2>&1 > /dev/null
mkdir -p $tornado_chroot/outgoing 2>&1 > /dev/null
mkdir -p $tornado_chroot/template 2>&1 > /dev/null

cd $ui_app
current="$(du -bs src)"
last="$(cat src.total)"

if [[ $current != $last ]]; then
    rm $nginx_chroot/heap/*.js  > /dev/null
    rm $nginx_chroot/heap/*.map  > /dev/null
    rm $tornado_chroot/template/*.html > /dev/null

    ./node_modules/.bin/webpack 2>&1 > /dev/null
    OUT=$?
    if ! [ $OUT -eq 0 ];then
        exit 1
    fi
    du -bs src > src.total

    cd $ui_app_dist_app

    for app_name in "${apps[@]}"
    do
        for js in $app_name*.js
        do [ -f "$js" ]
            echo "<script src='/heap/$js' ></script>" > $tornado_chroot/template/$app_name.app.html
            /bin/mv $js* $nginx_chroot/heap 2>&1 > /dev/null
        done
    done
fi

rm $nginx_chroot/heap/i18n/* > /dev/null
/bin/cp -av $ui_app_i18n/lang.json $nginx_chroot/heap/i18n 2>&1 > /dev/null
for app_name in "${apps[@]}"
do
    /bin/cp -av $ui_app_i18n/$app_name/*.json $nginx_chroot/heap/i18n 2>&1 > /dev/null
done

/bin/cp -aRv $ui_app_dist/heap/img $nginx_chroot/heap 2>&1 > /dev/null
/bin/cp -aRv $ui_app_dist/heap/logo $nginx_chroot/heap 2>&1 > /dev/null
/bin/cp -aRv $ui_app_dist/heap/wgt $nginx_chroot/heap 2>&1 > /dev/null

/bin/cp -aRv $ui_app_dist/heap/css $nginx_chroot/heap 2>&1 > /dev/null
/bin/cp -av $rpui/*.py $tornado_chroot 2>&1 > /dev/null
/bin/cp -av $rpui/version $tornado_chroot 2>&1 > /dev/null
/bin/cp -aRv $rpui/lib $tornado_chroot 2>&1 > /dev/null
/bin/cp -aRv $ui_handlers $tornado_chroot 2>&1 > /dev/null
/bin/rm -rf $tornado_chroot/ui_handlers/template 2>&1 > /dev/null
/bin/cp -aRv $ct_handlers $tornado_chroot 2>&1 > /dev/null

/bin/cp -av $ui_app_dist_app/*.html $nginx_chroot/heap 2>&1 > /dev/null
/bin/cp -aRv $ui_handlers/template/* $tornado_chroot/template 2>&1 > /dev/null

chmod -R 775 $nginx_chroot/*