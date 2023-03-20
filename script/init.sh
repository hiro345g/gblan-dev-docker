#!/bin/sh

cd /gblan/
if [ -e /gblan/devnode-desktop/ ]; then rm -fr /gblan/devnode-desktop/; fi
wget -O devnode-desktop-main.zip https://github.com/hiro345g/devnode-desktop/archive/refs/heads/main.zip
unzip devnode-desktop-main.zip 
mv devnode-desktop-main devnode-desktop
chown -R node: devnode-desktop/ devnode-desktop-main.zip
