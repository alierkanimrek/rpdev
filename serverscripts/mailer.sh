#!/bin/bash
#

# All rights reserved (c) 2018 Ali Erkan IMREK <alierkanimrek@gmail.com>

# Add this entry to /etc/crontab 
# */5 * * * * root /bin/bash /usr/share/rplexus/scripts/mailer.sh








path=/usr/share/rplexus/outgoing/
if [ -f "$path"/mailer.lock ]; then
  exit
fi
touch "$path"/mailer.lock
for mail in "$path"/*.email
do
  if [ -f "$mail" ];then
    sendmail -t < $mail
    wait ${!}
    sleep 2
    rm $mail
  fi
done
rm "$path"/mailer.lock