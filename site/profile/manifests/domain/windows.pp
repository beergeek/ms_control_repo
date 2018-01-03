class profile::domain::windows (
  String $domain_credential_user,
  String $domain_credential_passwd,
  String $domain_name,
) {

  $domain_credentials = {
    'user'     => "${domain_name}\\${domain_credential_user}",
    'password' => $domain_credential_passwd,
  }

  dsc_xcomputer { 'joindomain':
    dsc_name       => $facts['hostname'],
    dsc_domainname => $domain_name,
    dsc_credential => $domain_credentials,
    notify         => Reboot['reboot_after_joining_domain'],
  }

  reboot { 'reboot_after_joining_domain':
    message => 'Puppet is rebooting this machine due to domain joining',
    apply   => 'immediately',
  }

}
