#!/bin/bash
cd /home/vagrant
rm -rf ghc ghc-source cabal ghcjs-boot pkg
rm -rf ghcjs ghcjs-base ghcjs-boot ghcjs-build-refs ghcjs-dom ghcjs-examples ghcjs-jquery ghcjs-prim
rm -rf .cabal .ghc .ghcjs
rm -rf jsshell node node-v*
wget --progress=dot:mega -c http://hdiff.luite.com/ghcjs/ghcjs-prebuilt.tar.xz
tar -xJvf ghcjs-prebuilt.tar.xz --strip-components=1
rm ghcjs-prebuilt.tar.xz

