class profile::dns_server {

  if $facts['kernel'] == 'Windows' {
    include profile::dns_server::windows
  } elsif $facts['kernel'] == 'Linux' {
    include profile::dns_server::bind
  } else {
    fail("No DNS server option available for ${facts['kernel']}")
  }

}
