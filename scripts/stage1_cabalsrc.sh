#!/bin/sh

export HOME=/home/vagrant
export LC_ALL=en_US.utf8
cd /home/vagrant

install_src_pkg() {
   wget -q "http://ghcjs.github.io/packages/cabal-src/$1/$2/$1-$2.tar.gz"
   tar -xzf "$1-$2.tar.gz"
   cd "$1-$2"
   cabal-src-install --src-only
   cd ..
}

echo "===================================="
echo " Installing cabal-src-install\n and packages"
echo "===================================="

(cabal update || cabal update || cabal update) &&

cabal install cabal-src &&

(cd pkg &&
 install_src_pkg 'lens' '4.0.4.1' 
) &&

touch /home/vagrant/build1 &&

echo "Finished: $0"
