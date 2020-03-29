#!/bin/bash

# set -x

# filename of the notification sound
NOTIFICATION=3.mp3
# location of the log file
LOG=http://s4ros.it/kawusia/log.txt
# how many times repeat the message
LOOP=3
# base location for config
BASE=$(dirname $0)

# get the log file and set vars
DATA=$(curl -s $LOG)
URL=$(echo $DATA | cut -d ' ' -f 1)
MD5=$(echo $DATA | cut -d ' ' -f 3)

# echo $URL
# echo $MD5

# if this is not the first run
if [[ -f ${BASE}/last.md5 ]]; then
    PREVIOUS_MD5=$(cat ${BASE}/last.md5 | cut -d ' ' -f 1)
fi

# if the latest md5 checksum is the same as the current
# exit 0
if [ ! -z ${PREVIOUS_MD5} ]; then
    test "${MD5}" == "${PREVIOUS_MD5}" && exit 0
fi

# download the file and play the attention
curl -s $URL -o ${BASE}/attention.ogg && DOWNLOADED=1

if [ ! -z ${DOWNLOADED} ]; then
    for i in $(seq 1 ${LOOP}); do
        timeout 10 mplayer ${BASE}/sounds/${NOTIFICATION} 
        timeout 40 ${BASE}/attention.ogg
        sleep 3
    done
fi

echo $MD5 > ${BASE}/last.md5
