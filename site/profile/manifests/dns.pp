class profile::dns (
  String $top_domain_name,
  String $domain_controller,
) {

  $valid_domain = puppetdb_query("resources[count()] {type = 'Dsc_xwaitforaddomain' and title = \"${top_domain_name}\" and certname = \"${domain_controller}\"}")[0]['count']

  if $valid_domain == 1 {
    if $facts['kernel'] == 'Windows' {
      include profile::dns::windows
      } elsif $facts['kernel'] == 'Linux' {
        include profile::dns::resolv
        } else {
          fail("No DNS option available for ${facts['kernel']}")
        }
  } else {
    warning('No domain controller/DNS server foundi, not joining the domain')
  }

}
