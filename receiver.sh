#!/bin/bash

#set -x

BASE=$(dirname ${0})
MESSAGE=${BASE}/message

while [ 1 ]; do
    nc -l 0.0.0.0 8666 > ${MESSAGE}
    TEXT=$(cat ${MESSAGE})
    cat ${BASE}/request-template.json | sed "s#PLACE_HERE#${TEXT}#" > ${BASE}/request.json
done
