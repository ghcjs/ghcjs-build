exec { "apt-update":
    command => "apt-get update",
    path => "/usr/bin"
}
package { 'ghc': ensure => present }
package { 'cabal-install': ensure => present }
package { 'libwebkitgtk-3.0-dev': ensure => present }
package { 'happy': ensure => present }
package { 'alex': ensure => present }
package { 'autoconf': ensure => present }
package { 'libtool': ensure => present }
package { 'darcs': ensure => present }
package { 'git': ensure => present }
package { 'libncurses5-dev': ensure => present }
package { 'libbz2-dev': ensure => present }
package { 'default-jre': ensure => present }
user { 'build': ensure => present }
file { '/home/build': ensure => directory, owner => build, group => build }
vcsrepo { '/home/build/ghc-source':
          ensure   => latest,
          provider => git,
          owner => build,
          user => build,
          revision => 'master',
          require => [File['/home/build']]
          # , source   => '/tmp/ghc-repo'
          , source => 'https://github.com/ghc/ghc'
        }

file { '/home/build/ghc-source/dobuild.sh':
     content => "#!/bin/bash
export HOME=/home/build
export LC_ALL=en_US.utf8
export PATH=/home/build/ghcjs/bin:/home/build/.cabal/bin:/home/build/ghc/bin:$PATH
(cd /home/build/ghc-source &&
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
./configure --prefix=/home/build/ghc &&

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

wget http://ghcjs.github.io/packages/cabal-src/jmacro/0.6.4.0.1/jmacro-0.6.4.0.1.tar.gz &&
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

git clone https://github.com/haskell/cabal.git &&
cd cabal &&
wget http://ghcjs.github.io/patches/cabal-ghcjs.patch &&
patch -p1 < cabal-ghcjs.patch &&

cd Cabal &&
cabal install &&
cd ../cabal-install &&
cabal install &&
hash -r &&

git clone https://github.com/ghcjs/ghcjs.git &&
cd ghcjs &&
git checkout unbox &&
cabal install -fboot -f-compiler-only &&

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
(cabal-meta install -fwebkit1-8 -fgtk3 --force-reinstalls || cabal-meta install -fwebkit1-8 -fgtk3 --force-reinstalls) &&

cabal-meta install --ghcjs -fwebkit1-8 -fgtk3 --force-reinstalls --constraint='bytestring>=0.10.3.0' &&

echo Done) 2>&1| tee /tmp/build.log 
",
     mode => 0755,
     require => Vcsrepo['/home/build/ghc-source']
     }
# exec { 'unpackghc':
#      command => "/bin/tar -xjf /tmp/install-archives/ghc-7.6.3-i386-unknown-linux.tar.bz2 -C /usr/src",
#      creates => '/usr/src/ghc-7.6.3'
#     }
# exec { 'unpackcabal':
#      command => "/bin/tar -xzf /tmp/install-archives/cabal-install-1.16.0.2.tar.gz -C /usr/src",
#      creates => '/usr/src/cabal-install-1.16.0.2'
#      }
# exec { 'installcabal':
#        command => 'chmod +rx bootstrap.sh && ./bootstrap.sh --global',
#        provider => 'shell',
#        cwd => '/usr/src/cabal-install-1.16.0.2',
#        creates => '/usr/local/bin/cabal',
#        require => [Exec['installghc'], Exec['unpackcabal']]
#      }
file { '/usr/lib/libgmp.so.3':
        ensure => link,
        target => '/usr/lib/i386-linux-gnu/libgmp.so.10'
     }
# exec { 'installghc':
#   command => './configure --prefix=/usr/local && make install',
#   provider => 'shell',
#   cwd => '/usr/src/ghc-7.6.3',
#   creates => '/usr/local/bin/ghc',
#   subscribe => Exec['unpackghc'],
#   require => [Package['ghc'], Package['cabal-install'], File['/usr/lib/libgmp.so.3']]
# }
exec { 'build':
  provider => 'shell',
  timeout => 100000,
  command => "/home/build/ghc-source/dobuild.sh",
  creates => '/home/build/ghc/bin/ghc',
  subscribe => [Vcsrepo['/home/build/ghc-source'], File['/home/build/ghc-source/dobuild.sh']],
  user => build,
  require => [Package['cabal-install'], Package['ghc'],
              Vcsrepo['/home/build/ghc-source'], File['/home/build/ghc-source/dobuild.sh'], Package['happy'], Package['autoconf'],
              Package['libtool'], Package['alex'], Package['libbz2-dev'], Package['darcs'], Package['libncurses5-dev']]
}
