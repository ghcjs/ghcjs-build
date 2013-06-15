#!/bin/sh
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
cd /home/vagrant

echo "====================================" 
echo " Installing GHCJS" 
echo "===================================="

cd ghcjs &&
cabal install -f-compiler-only &&

cd ../ghcjs-boot &&
ghcjs-boot --init &&
cd libraries/bytestring &&
cabal install --ghcjs &&
cd ../unix &&
cabal install --ghcjs --constraint='bytestring>=0.10.3.0' &&
cd ../directory &&
cabal install --ghcjs --constraint='bytestring>=0.10.3.0' &&
cd ../process &&
cabal install --ghcjs --constraint='bytestring>=0.10.3.0' &&
cd ../../.. &&

cd .ghcjs/i386-linux-* &&
git clone https://github.com/ghcjs/shims &&
cd ../.. &&

echo "== Installing ghcjs-prim" &&
cd ghcjs-prim &&
cabal install --ghcjs &&
cd .. &&

echo "== Installing ghcjs-base" &&
cd ghcjs-base &&
cabal install --ghcjs &&
cd .. &&

echo "== Installing ghcjs-jquery" &&
cd ghcjs-jquery &&
cabal install --ghcjs &&
cd .. &&

# cabal unpack regex-posix-0.95.2 &&
# cd regex-posix-0.95.2 &&
# cabal configure --constraint='bytestring>=0.10.3.0' &&
# cabal build &&
# cabal install --ghcjs --constraint='bytestring>=0.10.3.0' &&
# cd .. &&

echo "====================================" &&
echo " Installing examples" &&
echo "====================================" &&

cd &&
cd ghcjs-examples/weblog &&
./build.sh &&
cd ../.. &&

cabal install warp-static &&

cd &&
# chown -R vagrant . &&
# chgrp -R vagrant . &&

touch /home/vagrant/build3 &&

echo "Finished $0" &&

echo "Done!"

