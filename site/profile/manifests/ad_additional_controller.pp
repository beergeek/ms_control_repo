class profile::ad_additional_controller (
  String $domain_credential_user,
  String $domain_credential_passwd,
  String $safe_mode_passwd,
  String $domain_name,
  String $ad_db_path                 = 'C:\Windows\NTDS',
  String $sysvol_path                = 'C:\Windows\SYSVOL',
  String $ad_log_path                = 'C:\Windows\NTDS',
  String $ad_creation_retry_attempts = '20',
  String $ad_creation_retry_interval = '10',
) {

  require profile::rsat

  $domain_credentials = {
    'user'     => "${domain_name}\\${domain_credential_user}",
    'password' => $domain_credential_passwd,
  }

  $safemode_credentials = {
    'user'     => 'Administrator',
    'password' => $safe_mode_passwd,
  }

  reboot { 'reboot_after_ad_install':
    message => 'Installation of AD is complete, Puppet is rebooting this node',
    apply   => 'immediately',
  }

  dsc_windowsfeature { 'ADDSInstall':
    dsc_ensure => present,
    dsc_name   => 'AD-Domain-Services',
  }

  dsc_xaddomaincontroller { 'additional_domain_conotroller':
    dsc_domainname                    => $domain_name,
    dsc_domainadministratorcredential => $domain_credentials,
    dsc_safemodeadministratorpassword => $safemode_credentials,
    require                           => Dsc_windowsfeature['ADDSInstall'],
  }
}
