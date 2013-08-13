#!/bin/sh
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
cd /home/vagrant

echo "===================================="
echo " Installing Cabal and cabal-install"
echo "===================================="

cd cabal/Cabal &&
cabal install --force-reinstalls &&
cd ../cabal-install &&
cabal install --force-reinstalls &&
cd ../.. &&
hash -r &&

# reinstall the library with the new cabal-install
rm -r ~/.ghc &&
cd cabal/Cabal &&
cabal install --force-reinstalls &&
cd ../.. &&

touch /home/vagrant/build2 &&

echo "Finished $0"
