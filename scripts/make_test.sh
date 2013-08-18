#!/bin/bash
# builds the test base archive for Travis
# run this on a 64 bit VM
cd /home 
sudo tar -cJvf /vagrant/ghcjs-test.tar.xz --exclude-from=/vagrant/scripts/make_test_exclude vagrant 

