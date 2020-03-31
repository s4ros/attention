#!/bin/bash

#set -x

# filename of the notification sound
NOTIFICATION=3.mp3
# how many times repeat the message
LOOP=3
# base location for config
BASE=$(dirname $0)

# checksum of last request.json
MD5=$(md5sum ${BASE}/request.json | cut -d ' ' -f 1)

# if this is not the first run
if [[ -f ${BASE}/last.md5 ]]; then
    PREVIOUS_MD5=$(cat ${BASE}/last.md5)
fi

# if the latest md5 checksum is the same as the current
# exit 0
# if [ ! -z ${PREVIOUS_MD5} ]; then
#     test "${MD5}" != "${PREVIOUS_MD5}" && exit 0
# fi

if [[ "${MD5}" != ${PREVIOUS_MD5} ]]; then
    curl -X POST \
    -H "Authorization: Bearer "$(gcloud auth application-default print-access-token) \
    -H "Content-Type: application/json; charset=utf-8" \
    -d @request.json https://texttospeech.googleapis.com/v1/text:synthesize \
    | jq -r '.audioContent' | base64 -d > attention.mp3 && DOWNLOADED=1
fi

if [ ! -z ${DOWNLOADED} ]; then
    for i in $(seq 1 ${LOOP}); do
        #(timeout 10 mplayer -ao alsa ${BASE}/sounds/${NOTIFICATION})
        ${BASE}/play-notification ${NOTIFICATION}
        #("timeout 40 mplayer -ao alsa ${BASE}/attention.mp3")
        ${BASE}/play-message
    done
fi

echo $MD5 > ${BASE}/last.md5
