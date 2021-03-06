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
file { "/home/vagrant/jsshell":
  ensure => directory,
  owner => vagrant,
  group => vagrant
}

$jsshellArch = $architecture ? {
  /64/    => "x86_64",
  default => "i686",
}

exec { "wget http://ftp.mozilla.org/pub/mozilla.org/firefox/nightly/latest-trunk/jsshell-linux-${jsshellArch}.zip":
  creates => "/home/vagrant/jsshell-linux-${jsshellArch}.zip",
  cwd => "/home/vagrant",
  path => ["/usr/bin"],
  require => File["/home/vagrant/jsshell"],
  user => vagrant,
  group => vagrant
}
->
exec { "unzip /home/vagrant/jsshell-linux-${jsshellArch}.zip -d jsshell":
  cwd => "/home/vagrant",
  creates => "/home/vagrant/jsshell/js",
  path => ["/usr/bin"],
  user => vagrant,
  group => vagrant,
  require => Package['unzip']
}

$nodeVersion = "v0.10.25"

$nodeArch = $architecture ? { 
  /64/    => "x64",
  default => "x86",
}

exec { "wget http://nodejs.org/dist/${nodeVersion}/node-${nodeVersion}-linux-${nodeArch}.tar.gz":
  creates => "/home/vagrant/node-${nodeVersion}-linux-${nodeArch}.tar.gz",
  cwd => "/home/vagrant",
  path => ["/usr/bin"],
  user => vagrant,
  group => vagrant
#  require => [Package['wget']]
}
->
exec { "tar -xzf node-${nodeVersion}-linux-${nodeArch}.tar.gz":
  creates => "/home/vagrant/node-${nodeVersion}-linux-${nodeArch}/bin/node",
  cwd => "/home/vagrant",
  path => ["/bin"],
  user => vagrant,
  group => vagrant
}
~>
file { "/home/vagrant/node":
  ensure  => link,
  target  => "/home/vagrant/node-${nodeVersion}-linux-${nodeArch}",
#  require => File['/home/vagrant/node-${nodeVersion}-linux-${nodeArch}/bin/node']
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
              , Package['happy']
              , Package['autoconf']
              , Package['libtool']
              , Package['alex']
              , Package['libbz2-dev']
              , Package['darcs']
              , Package['libncurses5-dev']
              , Exec['prep0']]
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
             , File['/home/vagrant/pkg']],
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
             , Package['ghc']],
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
             , Package['ghc']],
  subscribe => [ Exec['build2'] ]
}
