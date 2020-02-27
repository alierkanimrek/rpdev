#!/bin/bash

path=$(dirname $(readlink -f $0))
cd $path

/bin/rm update.sh
curl https://raw.githubusercontent.com/alierkanimrek/rpdev/master/serverscripts/update.sh?token=AKNJMMX6PXZU6PURZYNOX226K5PIA>update.sh

/bin/bash ./update.sh