#!/bin/sh
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
cd /home/vagrant

echo "===================================="
echo " Patching and installing Cabal"
echo "===================================="

cd cabal &&
wget -q http://ghcjs.github.io/patches/cabal-ghcjs.patch &&
patch -p1 < cabal-ghcjs.patch &&

echo "== Cabal patched, installing" &&

cd Cabal &&
cabal install &&
cd ../cabal-install &&
cabal install &&
cd ../.. &&
hash -r &&

touch /home/vagrant/build2 &&

echo "Finished $0"
