#!/bin/bash
# generate a fresh ghcjs-prebuilt.tar.xz in the /vagrant dir
cd /home
tar -cJvf /vagrant/ghcjs-prebuilt.tar.xz --exclude=.ssh/ vagrant

