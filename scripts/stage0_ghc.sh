#!/bin/sh
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
cd /home/vagrant

echo "====================================" && 
echo " Updating ghc-build-refs" &&
echo "====================================" &&

# Uncoment this if you want to try out the very latest builds
#cd ghcjs-build-refs &&
#for a in \
#		ghc-source \
#		ghcjs \
#		ghcjs-* \
#		ghc-packages/libffi-tarballs \
#		ghc-packages/utils/* \
#		ghc-packages/libraries/*; \
#	do (echo "Updating $a" && cd "$a" && git checkout master && git pull) || exit 1; \
#done &&
#cd .. &&
#
#cd ghcjs-build-refs/cabal &&
#(git remote add upstream https://github.com/haskell/cabal || true) &&
#git fetch upstream &&
#git rebase upstream/master &&
#cd ../.. &&

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
echo " Syncing GHC source" &&
echo "====================================" &&

cp -rf ghcjs-build-refs/ghc-packages/libffi-tarballs ghcjs-build-refs/ghc-source/ &&
cp -rf ghcjs-build-refs/ghc-packages/libraries/* ghcjs-build-refs/ghc-source/libraries/ &&
cp -rf ghcjs-build-refs/ghc-packages/utils/* ghcjs-build-refs/ghc-source/utils/ &&
cd ghc-source &&
(cabal update || cabal update || cabal update) &&

echo "====================================" &&
echo " Patching GHC" &&
echo "====================================" &&

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
