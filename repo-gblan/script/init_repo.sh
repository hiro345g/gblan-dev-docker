#!/bin/sh
REPO_GBLAN_DIR=/home/node/repo/gblan
GIT_USER_NAME=user001
GIT_USER_EMAIL=user001@example.jp

BASE_DIR=$(cd $(dirname $0)/..;pwd)

if [ -e ${REPO_GBLAN_DIR} ]; then
  echo "already exists: ${REPO_GBLAN_DIR}"
  exit 1;
fi
mkdir -p ${REPO_GBLAN_DIR}/dc
mkdir -p ${REPO_GBLAN_DIR}/gblan-dev
mv ${BASE_DIR}/README.md ${REPO_GBLAN_DIR}/gblan-dev/
mv ${BASE_DIR}/gblan-dev.code-workspace ${REPO_GBLAN_DIR}/gblan-dev/

cd ${REPO_GBLAN_DIR}
git config --global init.defaultBranch main
git init
git config user.name ${GIT_USER_NAME}
git config user.email ${GIT_USER_EMAIL}
git add .
git commit -m "init"
