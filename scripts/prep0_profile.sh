#!/bin/sh
echo 'PATH=/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/home/vagrant/jsshell:/home/vagrant/node-v0.10.10-linux-x86/bin:$PATH' >> /home/vagrant/.profile
echo 'LC_ALL=en_US.utf8' >> /home/vagrant/.profile

touch /home/vagrant/prep0 &&

echo "Finished $0"
