# Public: Install and configure dnsmasq from homebrew.
#
# Examples
#
#   include dnsmasq
class dnsmasq(
  $host       = undef,
  $tlds       = undef,
  $configdir  = undef,
  $configfile = undef,
  $datadir    = undef,
  $executable = undef,
  $logdir     = undef,
  $logfile    = undef,
) {
  require homebrew
  include stdlib
  $servicename = 'dev.dnsmasq'
  $tld_names = keys($tlds)

  file { [$configdir, $logdir, $datadir]:
    ensure => directory,
  }

  file { "${configdir}/dnsmasq.conf":
    content => template('dnsmasq/dnsmasq.conf.erb'),
    notify  => Service[$servicename],
    require => File[$configdir],
  }

  file { '/Library/LaunchDaemons/dev.dnsmasq.plist':
    content => template('dnsmasq/dev.dnsmasq.plist.erb'),
    group   => 'wheel',
    notify  => Service[$servicename],
    owner   => 'root',
  }

  file { '/etc/resolver':
    ensure => directory,
    group  => 'wheel',
    owner  => 'root',
  }

  dnsmasq::resolver{ $tld_names: }

  homebrew::formula { 'dnsmasq':
    before => Package['boxen/brews/dnsmasq'],
  }

  package { 'boxen/brews/dnsmasq':
    ensure => '2.71-boxen1',
    notify => Service[$servicename],
  }

  service { $servicename:
    ensure  => running,
    require => Package['boxen/brews/dnsmasq'],
  }

  service { 'com.boxen.dnsmasq': # replaced by dev.dnsmasq
    before => Service[$servicename],
    enable => false,
  }
}
