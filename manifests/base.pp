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
vcsrepo { '/home/vagrant/ghc-source':
          ensure   => latest,
          provider => git,
          owner => vagrant,
          user => vagrant,
          revision => 'master',
          source => 'https://github.com/ghc/ghc'
        }
vcsrepo { '/home/vagrant/ghcjs-examples':
  ensure => latest,
  provider => git,
  owner => vagrant,
  user => vagrant,
  revision => 'master',
  source => 'https://github.com/ghcjs/ghcjs-examples'
}

file { "/home/vagrant/jsshell":
  ensure => directory,
  owner => vagrant,
  group => vagrant
}
# exec { "wget http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/jsshell-linux-i686.zip":
#   creates => "/home/vagrant/jsshell/jsshell.zip",
#   cwd => "/home/vagrant/jsshell",
#   path => ["/usr/bin"],
#   require => File["/home/vagrant/jsshell"],
#   user => vagrant,
#   group => vagrant
# }
# ->
# exec { "unzip /home/vagrant/jsshell/jsshell.zip":
#   cwd => "/home/vagrant/jsshell",
#   creates => "/home/vagrant/jsshell/js",
#   path => ["/usr/bin"],
#   user => vagrant,
#   group => vagrant
# }
exec { "wget http://nodejs.org/dist/v0.10.10/node-v0.10.10-linux-x86.tar.gz":
  creates => "/home/vagrant/node-v0.10.10-linux-x86.tar.gz",
  cwd => "/home/vagrant",
  path => ["/usr/bin"],
  user => vagrant,
  group => vagrant
#  require => [Package['wget']]
}
->
exec { "tar -xzf node-v0.10.10-linux-x86.tar.gz":
  creates => "/home/vagrant/node-v0.10.10-linux-x86/bin/node",
  cwd => "/home/vagrant",
  path => ["/bin"],
  user => vagrant,
  group => vagrant
}

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
# exec { 'build':
#   provider => 'shell',
#   timeout => 100000,
#   command => "/vagrant/bootstrap.sh",
#   path => "/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/usr/sbin:/usr/bin:/sbin:/bin",
#   creates => '/home/vagrant/ghc/bin/ghc',
#   subscribe => [Vcsrepo['/home/vagrant/ghc-source'], File['/home/vagrant/ghc-source/dobuild.sh']],
#   user => vagrant,
#   require => [Package['cabal-install'], Package['ghc'],
#               Vcsrepo['/home/vagrant/ghc-source'], File['/home/vagrant/ghc-source/dobuild.sh'], Package['happy'], Package['autoconf'],
#               Package['libtool'], Package['alex'], Package['libbz2-dev'], Package['darcs'], Package['libncurses5-dev']]
# }
