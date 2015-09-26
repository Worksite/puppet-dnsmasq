define dnsmasq::resolver(){
  file { "/etc/resolver/${name}":
    content => 'nameserver 127.0.0.1',
    group   => 'wheel',
    owner   => 'root',
    require => File['/etc/resolver'],
    notify  => Service['dev.dnsmasq'],
  }
}