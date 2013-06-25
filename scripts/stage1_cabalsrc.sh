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
cabal install packedstring --ghc-options='-XStandaloneDeriving -XDeriveDataTypeable' &&
cabal install cabal-src &&

(cd pkg &&
install_src_pkg 'bzlib-conduit' '0.2.1.1' &&
install_src_pkg 'vector' '0.10.9' &&
install_src_pkg 'optparse-applicative' '0.5.2.1.1' &&
install_src_pkg 'MonadCatchIO-transformers' '0.3.0.0.1' &&
install_src_pkg 'contravariant' '0.4.1.1' &&
install_src_pkg 'lens' '3.10.0.0.1' &&
install_src_pkg 'aeson' '0.6.1.0.1' &&
install_src_pkg 'yaml' '0.8.2.3' &&
install_src_pkg 'haskell-src-meta' '0.6.0.2.1' &&
install_src_pkg 'th-orphans' '0.6.0.0.1' &&
install_src_pkg 'th-lift' '0.5.5.0.1' &&
install_src_pkg 'time' '1.4.0.2.1' &&
install_src_pkg 'HTTP' '4000.2.6.0.1' &&
install_src_pkg 'entropy' '0.2.2.1' &&
install_src_pkg 'Tensor' '1.0.0.1.1' &&
install_src_pkg 'jmacro' '0.6.7.0.1'
) &&

cd /home/vagrant/pkg/generic-deriving && 
cabal install &&

touch /home/vagrant/build1 &&

echo "Finished: $0"
