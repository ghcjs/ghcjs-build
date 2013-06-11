exec { "apt-update":
    command => "apt-get update",
    path => "/usr/bin"
}
package { 'ghc': ensure => present }
package { 'cabal-install': ensure => present }
package { 'happy': ensure => present }
package { 'alex': ensure => present }
package { 'autoconf': ensure => present }
package { 'libtool': ensure => present }
package { 'darcs': ensure => present }
package { 'git': ensure => present }
package { 'make': ensure => present }
package { 'libncurses5-dev': ensure => present }
package { 'libbz2-dev': ensure => present }
package { 'unzip': ensure => present }
vcsrepo { '/home/vagrant/ghc-source':
          ensure   => latest,
          provider => git,
          owner => vagrant,
          user => vagrant,
          revision => 'master',
          source => 'https://github.com/ghc/ghc'
        }

file { '/home/vagrant/dobuild.sh':
     content => "#!/bin/bash
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
echo 'PATH=/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/home/vagrant/jsshell:/home/vagrant/node/bin:\$PATH' >> /home/vagrant/.profile
echo 'LC_ALL=en_US.utf8' >> /home/vagrant/.profile

install_src_pkg() {
   wget \"http://ghcjs.github.io/packages/cabal-src/\$1/\$2/\$1-\$2.tar.gz\"
   tar -xzf \"\$1-\$2.tar.gz\"
   cd \"\$1-\$2\"
   cabal-src-install --src-only
   cd ..
}

(cd /home/vagrant &&

mkdir jsshell &&
cd jsshell &&
wget http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/jsshell-linux-x86_64.zip &&
unzip jsshell-linux-x86_64.zip &&
rm jsshell-linux-x86_64.zip &&
cd .. &&

wget http://nodejs.org/dist/v0.10.10/node-v0.10.10-linux-x64.tar.gz &&
tar -xzf node-v0.10.10-linux-x64.tar.gz &&
mv node-v0.10.10-linux-x64 node &&
rm node-v0.10.10-linux-x64.tar.gz &&

cd ghc-source &&
./sync-all -r https://github.com/ghc get &&
./sync-all -r https://github.com/ghc get &&
./sync-all -r https://github.com/ghc get &&
./sync-all -r https://github.com/ghc get &&
cabal update &&
wget http://ghcjs.github.io/patches/ghc-ghcjs.patch &&
patch -p1 < ghc-ghcjs.patch &&
perl boot &&
./configure --prefix=/home/vagrant/ghc &&
cp -r . ../ghcjs-boot &&
make -j5 &&
make install &&
hash -r &&
cd .. &&

(cabal update || cabal update || cabal update) &&
cabal install cabal-src &&

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
) &&

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
cabal install -f-compiler-only &&
# cabal install -f-compiler-only --enable-tests && # do this when test-framework works with HEAD

cd ../ghcjs-boot &&
ghcjs-boot --init &&

cd &&
# clean up a little so we get a smaller archive, but still enough to ghcjs-boot --reboot
rm -rf cabal &&
rm -rf ghcjs/dist &&
rm -rf ghcjs &&
(cd .cabal/bin && rm -f cabal-src-install ghcjs ghcjs-boot ghcjs-pkg jmacro) &&
rm -rf ghc-source &&
rm -rf pkg &&
rm -rf ghcjs-boot/ghc-tarballs/mingw &&
rm -rf ghcjs-boot/ghc-tarballs/mingw64 &&
rm -rf ghcjs-boot/ghc-tarballs/.git &&
rm -rf ghcjs-boot/compiler &&
rm -rf ghcjs-boot/ghc &&
(cd ghcjs-boot/inplace/bin && (rm -f deriveConstants dll-split genapply genprimopcode ghc-pwd ghctags hpc mkUserGuidePart || true)) &&
rm -rf ghcjs-boot/inplace/lib/bin &&
rm -rf ghcjs-boot/utils &&
(find ghcjs-boot -name \".git\" -exec rm -rf {} \\; || true) &&

cd /home &&
sudo chmod 777 /home &&
tar -cJvf ghcjs-test.tar.xz vagrant &&
sudo cp ghcjs-test.tar.xz /vagrant/ghcjs-test.tar.xz &&

echo Done) 2>&1| tee -a /tmp/build.log
",
     mode => 0755,
     require => Vcsrepo['/home/vagrant/ghc-source']
     }
file { '/usr/lib/libgmp.so.3':
        ensure => link,
        target => '/usr/lib/i386-linux-gnu/libgmp.so.10'
     }
exec { 'build':
  provider => 'shell',
  timeout => 100000,
  command => "/home/vagrant/dobuild.sh",
  path => "/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  creates => '/home/vagrant/ghc/bin/ghc',
  subscribe => [Vcsrepo['/home/vagrant/ghc-source'], File['/home/vagrant/dobuild.sh']],
  user => vagrant,
  require => [Package['cabal-install'], Package['ghc'],
              Vcsrepo['/home/vagrant/ghc-source'], File['/home/vagrant/dobuild.sh'], Package['happy'], Package['autoconf'],
              Package['libtool'], Package['alex'], Package['libbz2-dev'], Package['darcs'], Package['libncurses5-dev'],
              Package['make']]
}
