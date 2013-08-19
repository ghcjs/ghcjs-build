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

cd ../ghcjs-boot &&
ghcjs-boot --init &&

cd &&

cp -rf ghcjs-build-refs/shims .ghcjs/*-linux-*/ &&

cabal install --ghcjs ./ghcjs-boot/libraries/bytestring \
                      ./ghcjs-boot/libraries/unix \
                      ./ghcjs-boot/libraries/directory \
                      ./ghcjs-boot/libraries/process \
                      ./ghcjs-prim \
                      ./ghcjs-base \
                      ./ghcjs-dom \
                      ./ghcjs-jquery &&

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

