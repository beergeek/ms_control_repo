class profile::dns::windows (
  Array[String] $dns_servers,
) {

  dsc_xdnsserveraddress { 'dns config':
    dsc_address        => $dns_servers,
    dsc_interfacealias => 'Ethernet',
    dsc_addressfamily  => 'IPv4',
  }

}
