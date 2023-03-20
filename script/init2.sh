#!/bin/sh

docker compose -p devnode-desktop cp ./repo-gblan devnode-desktop:/home/node/
docker compose -p devnode-desktop exec devnode-desktop sh /home/node/repo-gblan/script/init_repo.sh
docker compose -p devnode-desktop exec devnode-desktop rm -fr /home/node/repo-gblan
