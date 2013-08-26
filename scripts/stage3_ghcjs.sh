#!/bin/sh
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
cd /home/vagrant

echo "====================================" 
echo " Installing GHCJS" 
echo "===================================="

cd ghcjs &&
cabal install -j4 --enable-executable-dynamic &&

# required for testsuite
cabal install stm QuickCheck &&

ghcjs-boot --init &&

cd &&

cabal install --ghcjs ./ghcjs-dom ./ghcjs-jquery &&

echo "====================================" &&
echo " Installing examples" &&
echo "====================================" &&

cd &&
cd ghcjs-examples/weblog &&
./build.sh &&
cd ../.. &&

cabal install warp-static &&

cd &&

touch /home/vagrant/build3 &&

echo "Finished $0" &&

echo "Done!"

