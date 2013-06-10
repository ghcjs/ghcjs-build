#!/bin/sh
cd /home/vagrant
export PATH=/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/home/vagrant/jsshell:/home/vagrant/node-v0.10.10-linux-x86/bin:$PATH
cat >/home/vagrant/.profile <<EOF
source .bashrc
LC_ALL=en_US.utf8
PATH=$PATH
EOF

install_src_pkg() {
wget "http://ghcjs.github.io/packages/cabal-src/$1/$2/$1-$2.tar.gz"
   tar -xzf "$1-$2.tar.gz"
   cd "$1-$2"
   cabal-src-install --src-only
   cd ..
}


# Should be able to do that using Puppet, but wget doesn't work for some reason
cd jsshell &&
wget http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/jsshell-linux-i686.zip &&
unzip jsshell-linux-i686.zip &&
cd .. &&

echo "Syncing GHC source"
cd ghc-source 
# ./sync-all -r /tmp/ghcjs-libraries get 
# ./sync-all -r /tmp/ghcjs-libraries --ghcjs get 
./sync-all -r https://github.com/ghc get 
./sync-all -r https://github.com/ghc get 
./sync-all -r https://github.com/ghc get 
./sync-all -r https://github.com/ghc get 
# ./sync-all -r https://github.com/ghcjs --ghcjs get &&
cabal update 

echo "Patching GHC"
wget http://ghcjs.github.io/patches/ghc-ghcjs.patch 
patch -p1 < ghc-ghcjs.patch 
echo 'BuildFlavour = quick' > mk/build.mk 
cat mk/build.mk.sample >> mk/build.mk 
echo 'SRC_HC_OPTS     += -opta-U__i686' >> mk/build.mk 

echo "Installing GHC"
perl boot 
./configure --prefix=/home/vagrant/ghc 

cp -r . ../ghcjs-boot 

make -j5 
make install 
hash -r 
cd .. 

echo "Installing cabal-src and dependencies"
(cabal update || cabal update || cabal update) 
cabal install packedstring --ghc-options='-XStandaloneDeriving -XDeriveDataTypeable' 
cabal install cabal-src 

( mkdir pkg
  cd pkg
install_src_pkg 'bzlib-conduit' '0.2.1.1'
install_src_pkg 'vector' '0.10.9'
install_src_pkg 'optparse-applicative' '0.5.2.1.1'
install_src_pkg 'MonadCatchIO-transformers' '0.3.0.0.1'
install_src_pkg 'contravariant' '0.4.1.1'
install_src_pkg 'lens' '3.10.0.0.1'
install_src_pkg 'aeson' '0.6.1.0.1'
install_src_pkg 'yaml' '0.8.2.3'
install_src_pkg 'haskell-src-meta' '0.6.0.2.1'
install_src_pkg 'th-orphans' '0.6.0.0.1'
install_src_pkg 'th-lift' '0.5.5.0.1'
install_src_pkg 'time' '1.4.0.2.1'
install_src_pkg 'HTTP' '4000.2.6.0.1'
install_src_pkg 'entropy' '0.2.2.1'
install_src_pkg 'Tensor' '1.0.0.1.1'
install_src_pkg 'jmacro' '0.6.7.0.1'
)

git clone https://github.com/haskell/cabal.git &&
cd cabal &&
wget http://ghcjs.github.io/patches/cabal-ghcjs.patch &&
patch -p1 < cabal-ghcjs.patch &&

cd Cabal &&
cabal install &&
cd ../cabal-install &&
cabal install &&
cd ../.. &&
hash -r &&

git clone https://github.com/ghcjs/ghcjs.git &&
cd ghcjs &&
git checkout unbox &&
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

git clone https://github.com/ghcjs/ghcjs-prim &&
cd ghcjs-prim &&
cabal install --ghcjs &&
cd .. &&

git clone https://github.com/ghcjs/ghcjs-base &&
cd ghcjs-base &&
cabal install --ghcjs &&
cd .. &&

git clone https://github.com/ghcjs/ghcjs-jquery &&
cd ghcjs-jquery &&
cabal install --ghcjs &&
cd .. &&

cabal unpack regex-posix-0.95.2 &&
cd regex-posix-0.95.2 &&
cabal configure --constraint='bytestring>=0.10.3.0' &&
cabal build &&
cabal install --ghcjs --constraint='bytestring>=0.10.3.0' &&
cd .. &&

git clone https://github.com/ghcjs/ghcjs-examples.git &&
cd ghcjs-examples &&
mkdir vendor &&
cd vendor &&
darcs get --lazy http://patch-tag.com/r/hamish/gtk2hs &&
cabal install ./gtk2hs/tools &&
cd .. &&

cabal install cabal-meta &&
(cabal-meta install --ghcjs -fwebkit1-8 -fgtk3 --force-reinstalls --constraint='bytestring>=0.10.3.0' ||
 cabal-meta install --ghcjs -fwebkit1-8 -fgtk3 --force-reinstalls --constraint='bytestring>=0.10.3.0') &&
cd .. &&

cd &&
cd ghcjs-examples/weblog &&
./build.sh &&
cd ../.. &&

cabal install warp-static &&

echo Done
