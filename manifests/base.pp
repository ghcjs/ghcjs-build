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
Vcsrepo { require => Package[git] }
Exec["apt-update"] -> Package <| |>
vcsrepo { '/home/vagrant/ghc-source':
          ensure   => latest,
          provider => git,
          owner => vagrant,
          user => vagrant,
          revision => 'master',
          # revision => '2f9278d2bfeff16fa06b71cdc4453558c8228bb0',
          source => 'https://github.com/ghc/ghc',
        }
vcsrepo { '/home/vagrant/cabal':
  ensure => latest,
  provider => git,
  owner => vagrant,
  user => vagrant,
  revision => 'master',
  source => 'https://github.com/haskell/cabal',
}
vcsrepo { '/home/vagrant/ghcjs-examples':
  ensure => latest,
  provider => git,
  owner => vagrant,
  user => vagrant,
  revision => 'master',
  source => 'https://github.com/ghcjs/ghcjs-examples',
}
vcsrepo { '/home/vagrant/ghcjs':
  ensure => latest,
  provider => git,
  owner => vagrant,
  user => vagrant,
  revision => 'master',
  source => 'https://github.com/ghcjs/ghcjs',
}
vcsrepo { '/home/vagrant/ghcjs-prim':
  ensure => latest,
  provider => git,
  owner => vagrant,
  user => vagrant,
  revision => 'master',
  source => 'https://github.com/ghcjs/ghcjs-prim',
}
vcsrepo { '/home/vagrant/ghcjs-base':
  ensure => latest,
  provider => git,
  owner => vagrant,
  user => vagrant,
  revision => 'master',
  source => 'https://github.com/ghcjs/ghcjs-base',
}
vcsrepo { '/home/vagrant/ghcjs-dom':
  ensure => latest,
  provider => git,
  owner => vagrant,
  user => vagrant,
  revision => 'master',
  source => 'https://github.com/ghcjs/ghcjs-dom',
}
vcsrepo { '/home/vagrant/ghcjs-jquery':
  ensure => latest,
  provider => git,
  owner => vagrant,
  user => vagrant,
  revision => 'master',
  source => 'https://github.com/ghcjs/ghcjs-jquery',
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

file { "/home/vagrant/pkg":
  ensure => directory,
  owner => vagrant,
  group => vagrant
}

###############################
# Prep 0: Update .profile
###############################

file { '/home/vagrant/prep0_profile.sh':
  ensure => present,
  source => "/vagrant/scripts/prep0_profile.sh",
  owner => vagrant,
  mode => 766
}
~>
exec { 'prep0':
  provider => 'shell',
  user => vagrant,
  group => vagrant,
  creates => '/home/vagrant/prep0',
  command => "/home/vagrant/prep0_profile.sh"
}

###############################
# Stage 0: Installing GHC
###############################

file { '/home/vagrant/stage0_ghc.sh':
  ensure => present,
  source => "/vagrant/scripts/stage0_ghc.sh",
  owner => vagrant,
  mode => 766
}
~>
exec { 'build0':
  provider => 'shell',
  timeout => 100000,
  user => vagrant,
  group => vagrant,
  logoutput => true,
  creates => '/home/vagrant/build0',
  # creates => '/home/vagrant/ghc/bin/ghc',
  command => "/home/vagrant/stage0_ghc.sh",
  path => "/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  require => [ Package['cabal-install']
              , Package['ghc']
              , Vcsrepo['/home/vagrant/ghc-source']
              , Package['happy']
              , Package['autoconf']
              , Package['libtool']
              , Package['alex']
              , Package['libbz2-dev']
              , Package['darcs']
              , Package['libncurses5-dev']
              , Exec['prep0']],
  subscribe => [ Vcsrepo['/home/vagrant/ghc-source'] ]
}

#####################################################
# Stage 1: Installing cabal-src-install & packages
#####################################################

file { '/home/vagrant/stage1_cabalsrc.sh':
  ensure => present,
  source => "/vagrant/scripts/stage1_cabalsrc.sh",
  owner => vagrant,
  mode => 766
}
~>
exec { 'build1':
  provider => 'shell',
  timeout => 100000,
  user => vagrant,
  group => vagrant,
  logoutput => true,
  onlyif => "test -e '/home/vagrant/build0'",                
  creates => '/home/vagrant/build1',
  command => '/home/vagrant/stage1_cabalsrc.sh',
  path => "/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  require => [ Package['cabal-install']
             , Package['ghc']
             , File['/home/vagrant/pkg']
             , Vcsrepo['/home/vagrant/pkg/generic-deriving']],
  subscribe => [ Exec['build0'] ]
}

###############################
# Stage 2: Installing Cabal
###############################

file { '/home/vagrant/stage2_cabal.sh':
  ensure => present,
  source => "/vagrant/scripts/stage2_cabal.sh",
  owner => vagrant,
  mode => 766
}
~>
exec { 'build2':
  provider => 'shell',
  timeout => 100000,
  user => vagrant,
  group => vagrant,
  logoutput => true,
  onlyif => "test -e '/home/vagrant/build1'",                
  creates => '/home/vagrant/build2',
  command => '/home/vagrant/stage2_cabal.sh',
  path => "/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  require => [ Package['cabal-install']
             , Package['ghc']
             , Vcsrepo['/home/vagrant/cabal']],
  subscribe => [ Exec['build1'] ]
}

###############################
# Stage 3: Installing GHCJS
###############################

file { '/home/vagrant/stage3_ghcjs.sh':
  ensure => present,
  source => "/vagrant/scripts/stage3_ghcjs.sh",
  owner => vagrant,
  mode => 766
}
~>
exec { 'build3':
  provider => 'shell',
  timeout => 100000,
  user => vagrant,
  group => vagrant,
  logoutput => true,
  onlyif => "test -e '/home/vagrant/build2'",                
  creates => '/home/vagrant/build3',
  command => '/home/vagrant/stage3_ghcjs.sh',
  path => "/home/vagrant/ghcjs/bin:/home/vagrant/.cabal/bin:/home/vagrant/ghc/bin:/usr/sbin:/usr/bin:/sbin:/bin",
  require => [ Package['cabal-install']
             , Package['ghc']
             , Vcsrepo['/home/vagrant/ghcjs']
             , Vcsrepo['/home/vagrant/ghcjs-base']
             , Vcsrepo['/home/vagrant/ghcjs-prim']
             , Vcsrepo['/home/vagrant/ghcjs-examples']],
  subscribe => [ Exec['build2'] ]
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
