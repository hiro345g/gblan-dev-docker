#!/bin/sh

BASE_DIR=$(cd $(dirname $0)/../..;pwd)
FROM_DIR="devnode-desktop:/home/node/repo/gblan/gblan-dev"
DEST_DIR=${BASE_DIR}/gblan/gblan-dev

if [ ! -e ${DEST_DIR} ]; then
  echo "${DEST_DIR} error"
  exit 1;
fi
list="src tool gblan-dev.code-workspace README.md"
for t in ${list}; do
  echo "copy ${FROM_DIR}/${t} ${DEST_DIR}/"
  docker compose -p devnode-desktop cp "${FROM_DIR}/${t}" ${DEST_DIR}/
done

echo "${DEST_DIR}}/tool/node_modules/"
rm -fr ${DEST_DIR}}/tool/node_modules/