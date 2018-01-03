class profile::domain (
  String $top_domain_name,
  String $domain_controller,
) {

  $valid_domain = puppetdb_query("resources[count()] {type = 'Dsc_xwaitforaddomain' and title = \"${top_domain_name}\" and certname = \"${domain_controller}\"}")[0]['count']

  if $valid_domain == 1 {
    if $facts['kernel'] == 'Windows' {
      include profile::domain::windows
    } elsif $facts['kernel'] == 'Linux' {
      include profile::domain::sssd
    } else {
      fail("No domain option available for ${facts['kernel']}")
    }
  } else {
    warning('No domain controller/DNS server found, not joining the domain')
  }

}
