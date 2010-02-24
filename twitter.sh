#!/bin/sh

user="vimtricks"
pass="vim123"
curl="/usr/bin/curl"

LINES=`wc -l $1 | awk '{ print ($1 + 1) }'`
RANDSEED=`date '+%S%M%I'`
LINE=`cat $1 | awk -v COUNT=$LINES -v SEED=$RANDSEED 'BEGIN { srand(SEED); \
i=int(rand()*COUNT) } FNR==i { print $0 }'`
echo $LINE

$curl --basic --user "$user:$pass" --data-ascii \
  "status=`echo $LINE | tr ' ' '+'`" \
  "http://twitter.com/statuses/update.json"

exit 1
