exec { "apt-update":
    command => "apt-get update",
    path => "/usr/bin"
}
package { 'selinux-policy-default': ensure => present }
package { 'selinux-policy-dev': ensure => present }
package { 'selinux-policy-src': ensure => present }
package { 'selinux-basics': ensure => present }
package { 'selinux-utils': ensure => present }
package { 'auditd': ensure => present }
package { 'libselinux1-dev': ensure => present }
package { 'checkpolicy': ensure => present }
package { 'setools': ensure => present }
package { 'autoconf': ensure => present }

file { '/home/vagrant/selinux_config.sh':
  ensure => present,
  source => "/vagrant/scripts/selinux_config.sh",
  owner => vagrant,
  mode => 766
}
~>
exec { 'selinux_config':
  provider => 'shell',
  timeout => 100000,
  user => root,
  group => root,
  logoutput => true,
  command => '/home/vagrant/selinux_config.sh',
  require => [ Package['selinux-basics']
             , Package['selinux-policy-default']]
}

