#!/bin/sh
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
cd /home/vagrant

echo "====================================" 
echo " Syncing GHC source"
echo "====================================" &&

cd ghc-source &&
(
./sync-all -r https://github.com/ghc get ||
./sync-all -r https://github.com/ghc get ||
./sync-all -r https://github.com/ghc get ||
./sync-all -r https://github.com/ghc get ) &&
(cabal update || cabal update || cabal update) &&

echo "====================================" &&
echo " Patching GHC" &&
echo "====================================" &&

# wget http://hdiff.luite.com/ghcjs/ghc-bswap.patch &&
# patch -p1 < ghc-bswap.patch &&
wget http://ghcjs.github.io/patches/ghc-ghcjs.patch &&
patch -p1 < ghc-ghcjs.patch &&
echo 'BuildFlavour = quick' > mk/build.mk &&
cat mk/build.mk.sample >> mk/build.mk &&
# echo 'SRC_HC_OPTS     += -opta-U__i686' >> mk/build.mk 

echo "====================================" &&
echo " Installing GHC" &&
echo "====================================" &&

perl boot && 
./configure --prefix=/home/vagrant/ghc &&

cp -r . ../ghcjs-boot &&

make -j5 &&
make install &&
hash -r &&
cd .. &&

touch /home/vagrant/build0 &&

echo "Finished $0"
