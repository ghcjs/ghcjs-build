#!/bin/sh
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
cd /home/vagrant

echo "====================================" 
echo " Installing GHCJS" 
echo "===================================="

rm -rf ~/.ghcjs &&
cd ghcjs &&
cabal install -j4 --enable-executable-dynamic --enable-tests &&

# required for testsuite
# cabal install stm QuickCheck &&

# LIBDIR=`ghcjs --print-libdir` &&
# echo "using GHCJS library dir: $LIBDIR" &&
# mkdir -p "$LIBDIR" &&
# cd "$LIBDIR" &&
# cd .. &&
# rm -rf ghcjs-boot shims &&
# cp -rf "$HOME/ghcjs-build-refs/ghcjs-boot" . &&
# cp -rf "$HOME/ghcjs-build-refs/shims" . &&
# cd ghcjs-boot &&
# ghcjs-boot --init &&

# fixme install ghcjs-boot from refs again (git submodules are broken)

cd &&
ghcjs-boot --init -j4 &&

cabal install --ghcjs ./ghcjs-dom ./ghcjs-jquery &&

echo "====================================" &&
echo " Installing examples" &&
echo "====================================" &&

cd &&
cd ghcjs-examples/weblog &&
./build.sh &&
cd &&

cabal install warp-static &&

cd &&

touch /home/vagrant/build3 &&

echo "Finished $0" &&

echo "Done!"

