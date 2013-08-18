#!/bin/bash
# generate a fresh ghcjs-prebuilt.tar.xz in the /vagrant dir
# the prebuilt branch downloads this archive to get up and running quicker
cd /home
tar -cJvf /vagrant/ghcjs-prebuilt.tar.xz --exclude-from=/vagrant/scripts/make_prebuilt_exclude vagrant

