#!/bin/sh

BASE_DIR=$(cd $(dirname $0)/../..;pwd)
FROM_DIR=devnode-desktop:/home/node/repo/gblan/dc/gblan
DEST_DIR=${BASE_DIR}/gblan/dc/

cd ${DEST_DIR}
docker compose -p devnode-desktop exec devnode-desktop sh /home/node/repo/gblan/gblan-dev/src/build_dc/script/deploy.sh
echo "deploy: from: ${FROM_DIR}, to: ${DEST_DIR}"
docker compose -p devnode-desktop cp ${FROM_DIR} .
