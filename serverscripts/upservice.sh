#!/bin/bash

path=$(dirname $(readlink -f $0))
cd $path

/bin/rm update.sh
curl https://raw.githubusercontent.com/alierkanimrek/rpdev/master/serverscripts/update.sh>update.sh

/bin/bash ./update.sh