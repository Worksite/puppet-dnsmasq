# Dnsmasq Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-dnsmasq.png)](https://travis-ci.org/boxen/puppet-dnsmasq)

Install the [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html)
local resolver. After this module is included the `.dev` domain will
consistently resolve to `127.0.0.1`.

## Usage

```puppet
include dnsmasq
```

Alternatively, you can map additional TLD's...

```puppet
class { "dnsmasq" :
    tlds => {
      'dev'     => "127.0.0.1",
      'docker'  => "192.168.99.100",
      'vagrant' => "172.131.0.100",
    }
}
```

## Required Puppet Modules

* `boxen`
* `homebrew`

## Development

Write code. Run `script/cibuild` to test it. Check the `script`
directory for other useful tools.
