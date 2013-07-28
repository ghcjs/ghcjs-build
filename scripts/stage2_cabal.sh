#!/bin/sh
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
cd /home/vagrant

echo "===================================="
echo " Patching and installing Cabal"
echo "===================================="

cd cabal &&
(git remote add upstream https://github.com/haskell/cabal || true) &&
git fetch upstream &&
git rebase upstream/master &&

echo "== Cabal patched, installing" &&

cd Cabal &&
cabal install --force-reinstalls &&
cd ../cabal-install &&
cabal install --force-reinstalls &&
cd ../.. &&
hash -r &&

touch /home/vagrant/build2 &&

echo "Finished $0"
