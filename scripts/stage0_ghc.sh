#!/bin/sh
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
cd /home/vagrant

echo "====================================" && 
echo " Copy the ghc-build-refs into place" &&
echo "====================================" &&

cp -rf ghcjs-build-refs/cabal . &&
cp -rf ghcjs-build-refs/ghc-source . &&
cp -rf ghcjs-build-refs/ghcjs . &&
cp -rf ghcjs-build-refs/ghcjs-* . &&
cp -rf ghcjs-build-refs/ghc-packages/libffi-tarballs ghc-source/ &&
cp -rf ghcjs-build-refs/ghc-packages/utils/* ghc-source/utils/ &&
cp -rf ghcjs-build-refs/ghc-packages/libraries/* ghc-source/libraries/ &&

echo "====================================" &&
echo " cabal update" &&
echo "====================================" &&

(cabal update || cabal update || cabal update) &&


echo "====================================" &&
echo " Patching GHC" &&
echo "====================================" &&

cd ghc-source &&
patch -p1 < /home/vagrant/ghcjs-build-refs/patches/ghc-ghcjs.patch &&
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
