class profile::dns_server::windows (
) {

  dsc_windowsfeature { 'dns':
    dsc_ensure => present,
    dsc_name   => 'DNS',
  }

  dsc_xdnsserveraddress { 'DNSServerAddress':
    dsc_address        => '127.0.0.1',
    dsc_interfacealias => 'Ethernet',
    dsc_addressfamily  => 'IPv4',
    require            => Dsc_windowsfeature['dns'],
  }
}
