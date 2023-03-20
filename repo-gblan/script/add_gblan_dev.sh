#!/bin/sh

cd ~/repo-gblan
git clone https://github.com/hiro345g/gblan.git
mv gblan/gblan-dev /home/node/repo/gblan/
git -C /home/node/repo/gblan/ add .
git -C /home/node/repo/gblan/ commit -m "add gblan-dev"
rm -fr gblan
