#!/bin/sh
cd /home/vagrant
export PATH=/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/home/vagrant/jsshell:/home/vagrant/node-v0.10.10-linux-x86/bin:$PATH
cat >/home/vagrant/.profile <<EOF
source .bashrc
LC_ALL=en_US.utf8
PATH=$PATH
EOF

# Should be able to do that using Puppet, but wget doesn't work for some reason
cd jsshell &&
wget http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/jsshell-linux-i686.zip &&
unzip jsshell-linux-i686.zip &&
cd .. &&

echo "Syncing GHC source"
cd ghc-source &&
# ./sync-all -r /tmp/ghcjs-libraries get &&
# ./sync-all -r /tmp/ghcjs-libraries --ghcjs get &&
./sync-all -r https://github.com/ghc get &&
./sync-all -r https://github.com/ghc get &&
./sync-all -r https://github.com/ghc get &&
./sync-all -r https://github.com/ghc get &&
# ./sync-all -r https://github.com/ghcjs --ghcjs get &&
cabal update &&
wget http://ghcjs.github.io/patches/ghc-ghcjs.patch &&
patch -p1 < ghc-ghcjs.patch &&
echo 'BuildFlavour = quick' > mk/build.mk &&
cat mk/build.mk.sample >> mk/build.mk &&
echo 'SRC_HC_OPTS     += -opta-U__i686' >> mk/build.mk &&
perl boot &&
./configure --prefix=/home/vagrant/ghc &&

cp -r . ../ghcjs-boot &&

make -j5 &&
make install &&
hash -r &&
cd .. &&

(cabal update || cabal update || cabal update) &&
cabal install packedstring --ghc-options='-XStandaloneDeriving -XDeriveDataTypeable' &&
cabal install cabal-src &&

wget http://ghcjs.github.io/packages/cabal-src/bzlib-conduit/0.2.1.1/bzlib-conduit-0.2.1.1.tar.gz &&
tar -xzf bzlib-conduit-0.2.1.1.tar.gz &&
cd bzlib-conduit-0.2.1.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/vector/0.10.9/vector-0.10.9.tar.gz &&
tar -xzf vector-0.10.9.tar.gz &&
cd vector-0.10.9 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/optparse-applicative/0.5.2.1.1/optparse-applicative-0.5.2.1.1.tar.gz &&
tar -xzf optparse-applicative-0.5.2.1.1.tar.gz &&
cd optparse-applicative-0.5.2.1.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/MonadCatchIO-transformers/0.3.0.0.1/MonadCatchIO-transformers-0.3.0.0.1.tar.gz &&
tar -xzf MonadCatchIO-transformers-0.3.0.0.1.tar.gz &&
cd MonadCatchIO-transformers-0.3.0.0.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/lens/3.10.0.0.1/lens-3.10.0.0.1.tar.gz &&
tar -xzf lens-3.10.0.0.1.tar.gz &&
cd lens-3.10.0.0.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/aeson/0.6.1.0.1/aeson-0.6.1.0.1.tar.gz &&
tar -xzf aeson-0.6.1.0.1.tar.gz &&
cd aeson-0.6.1.0.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/yaml/0.8.2.3/yaml-0.8.2.3.tar.gz &&
tar -xzf yaml-0.8.2.3.tar.gz &&
cd yaml-0.8.2.3 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/haskell-src-meta/0.6.0.2.1/haskell-src-meta-0.6.0.2.1.tar.gz &&
tar -xzf haskell-src-meta-0.6.0.2.1.tar.gz &&
cd haskell-src-meta-0.6.0.2.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/th-orphans/0.6.0.0.1/th-orphans-0.6.0.0.1.tar.gz &&
tar -xzf th-orphans-0.6.0.0.1.tar.gz &&
cd th-orphans-0.6.0.0.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/th-lift/0.5.5.0.1/th-lift-0.5.5.0.1.tar.gz &&
tar -xzf th-lift-0.5.5.0.1.tar.gz &&
cd th-lift-0.5.5.0.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/time/1.4.0.2.1/time-1.4.0.2.1.tar.gz &&
tar -xzf time-1.4.0.2.1.tar.gz &&
cd time-1.4.0.2.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/HTTP/4000.2.6.0.1/HTTP-4000.2.6.0.1.tar.gz &&
tar -xzf HTTP-4000.2.6.0.1.tar.gz &&
cd HTTP-4000.2.6.0.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/entropy/0.2.2.1/entropy-0.2.2.1.tar.gz &&
tar -xzf entropy-0.2.2.1.tar.gz &&
cd entropy-0.2.2.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/Tensor/1.0.0.1.1/Tensor-1.0.0.1.1.tar.gz &&
tar -xzf Tensor-1.0.0.1.1.tar.gz &&
cd Tensor-1.0.0.1.1 &&
cabal-src-install --src-only &&
cd .. &&

wget http://ghcjs.github.io/packages/cabal-src/jmacro/0.6.7.0.1/jmacro-0.6.7.0.1.tar.gz &&
tar -xzf jmacro-0.6.7.0.1.tar.gz &&
cd jmacro-0.6.7.0.1 &&
cabal-src-install --src-only &&
cd .. &&

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
