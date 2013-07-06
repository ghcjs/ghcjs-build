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
package { 'libgl1-mesa-dev': ensure => present }
package { 'libglu1-mesa-dev': ensure => present }
package { 'freeglut3-dev': ensure => present }
package { 'unzip': ensure => present }

file { '/home/vagrant/dobuild.sh':
     content => "#!/bin/bash
export HOME=/home/vagrant
export LC_ALL=en_US.utf8
echo 'PATH=/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/home/vagrant/jsshell:/home/vagrant/node-v0.10.10-linux-x86/bin:\$PATH' >> /home/vagrant/.profile
echo 'LC_ALL=en_US.utf8' >> /home/vagrant/.profile

(cd /home/vagrant &&

wget -c http://hdiff.luite.com/ghcjs/ghcjs-prebuilt.tar.gz &&
cd /home &&
tar -xzvf vagrant/ghcjs-prebuilt.tar.gz &&

echo Done) 2>&1| tee /tmp/extract.log 
",
     mode => 0755
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
  command => "/home/vagrant/dobuild.sh",
  path => "/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  creates => '/home/vagrant/ghc/bin/ghc',
  subscribe => [File['/home/vagrant/dobuild.sh']],
  user => vagrant,
  require => [Package['cabal-install'], Package['ghc'],
              File['/home/vagrant/dobuild.sh'], Package['happy'], Package['autoconf'],
              Package['libtool'], Package['alex'], Package['libbz2-dev'], Package['darcs'], Package['libncurses5-dev']]
}
