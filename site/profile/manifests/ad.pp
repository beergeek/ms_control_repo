class profile::ad (
  String $domain_credential_user,
  String $domain_credential_passwd,
  String $safe_mode_passwd,
  String $domain_name,
  String $ad_db_path                          = 'C:\Windows\NTDS',
  String $sysvol_path                         = 'C:\Windows\SYSVOL',
  String $ad_log_path                         = 'C:\Windows\NTDS',
  String $ad_creation_retry_attempts          = '20',
  String $ad_creation_retry_interval          = '10',
  Optional[Array[String]] $child_domain_names = [],
  Optional[Hash] $ad_users                    = {},
) {

  require profile::dns_server
  require profile::rsat

  $domain_credentials = {
    'user'     => $domain_credential_user,
    'password' => $domain_credential_passwd,
  }

  $safemode_credentials = {
    'user'     => 'Administrator',
    'password' => $safe_mode_passwd,
  }

  $ad_user_defaults = {
  }


  reboot { 'reboot_after_ad_install':
    message => 'Installation of AD is complete, Puppet is rebooting this node',
    apply   => 'immediately',
  }

  dsc_windowsfeature { 'ADDSInstall':
    dsc_ensure => present,
    dsc_name   => 'AD-Domain-Services',
  }

  dsc_xaddomain { $domain_name:
    dsc_domainname                    => $domain_name,
    dsc_domainadministratorcredential => $domain_credentials,
    dsc_safemodeadministratorpassword => $safemode_credentials,
    dsc_databasepath                  => $ad_db_path,
    dsc_sysvolpath                    => $sysvol_path,
    dsc_logpath                       => $ad_log_path,
    require                           => Dsc_windowsfeature['ADDSInstall'],
    notify                            => Reboot['reboot_after_ad_install'],
  }

  dsc_xwaitforaddomain { $domain_name:
    dsc_domainname           => $domain_name,
    dsc_domainusercredential => $domain_credentials,
    dsc_retrycount           => $ad_creation_retry_attempts,
    dsc_retryintervalsec     => $ad_creation_retry_interval,
    require                  => Dsc_xaddomain[$domain_name],
  }

  if $ad_users and !empty($ad_users) {
    $ad_users.each |String $ad_user,Hash $ad_user_data| {
      dsc_xaduser { $ad_user:
        *                                   => $ad_user_data,;
        default:
          dsc_domainname                    => $domain_name,
          dsc_domainadministratorcredential => $domain_credentials,
          dsc_username                      => $ad_user,
          require                           => Dsc_xaddomain[$domain_name];
      }
    }
  }
}
