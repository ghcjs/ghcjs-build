#!/bin/sh
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
cd /home/vagrant

echo "====================================" && 
echo " Copy the ghc-build-refs into place" &&
echo "====================================" &&

cp -rf ghcjs-build-refs/alex . &&
cp -rf ghcjs-build-refs/happy . &&
cp -rf ghcjs-build-refs/cabal . &&
# cp -rf ghcjs-build-refs/ghc-source . &&
cp -rf ghcjs-build-refs/ghcjs . &&
cp -rf ghcjs-build-refs/ghcjs-* . &&
# some problems with the build of these, remove comments when fixed
# cp -rf ghcjs-build-refs/ghc-packages/libffi-tarballs ghc-source/ &&
# cp -rf ghcjs-build-refs/ghc-packages/utils/* ghc-source/utils/ &&
# cp -rf ghcjs-build-refs/ghc-packages/libraries/* ghc-source/libraries/ &&

echo "====================================" &&
echo " cabal update" &&
echo "====================================" &&

(cabal update || cabal update || cabal update) &&
cd alex  && cabal install && cd .. &&
cd happy && cabal install && cd .. &&
hash -r &&

mkdir -p ghc-source &&
cd ghc-source &&
# remove when fixed refs build works again
git clone https://github.com/ghc/ghc.git &&
cd ghc &&
git checkout ghc-7.8 &&
#

echo "====================================" &&
echo " Installing GHC" &&
echo "====================================" &&

# remove this when haddock works again
# echo "HADDOCK_DOCS       = NO" > mk/build.mk &&
cat mk/build.mk.sample >> mk/build.mk &&
#

# remove when fixed refs builds works again
./sync-all get &&
./sync-all checkout ghc-7.8 &&
#

perl boot && 
./configure --prefix=/home/vagrant/ghc &&

make -j5 &&
make install &&
hash -r &&
cd &&

touch /home/vagrant/build0 &&

echo "Finished $0"
