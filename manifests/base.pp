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
(cd /home/build/ghc-source &&
# ./sync-all -r /tmp/ghcjs-libraries get &&
# ./sync-all -r /tmp/ghcjs-libraries --ghcjs get &&
./sync-all -r https://github.com/ghc get &&
./sync-all -r https://github.com/ghc get &&
./sync-all -r https://github.com/ghc get &&
./sync-all -r https://github.com/ghc get &&
# ./sync-all -r https://github.com/ghcjs --ghcjs get &&
cabal update &&
wget http://hdiff.luite.com/tmp/0006-ghc-all.patch &&
patch -p1 < 0006-ghc-all.patch &&
echo 'BuildFlavour = quick' > mk/build.mk &&
cat mk/build.mk.sample >> mk/build.mk &&
perl boot &&
./configure --prefix=$HOME/ghc &&
make -j5 &&
make install &&
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
