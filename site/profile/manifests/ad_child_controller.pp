class profile::ad_child_controller (
  String $domain_credential_user,
  String $domain_credential_passwd,
  String $safe_mode_passwd,
  String $domain_name,
  String $parent_domain_name,
  String $ad_db_path                 = 'C:\Windows\NTDS',
  String $sysvol_path                = 'C:\Windows\SYSVOL',
  String $ad_log_path                = 'C:\Windows\NTDS',
  String $ad_creation_retry_attempts = '5',
  String $ad_creation_retry_interval = '10',
) {

  require profile::rsat

  $domain_credentials = {
    'user'     => $domain_credential_user,
    'password' => $domain_credential_passwd,
  }

  $safemode_credentials = {
    'user'     => 'Administrator',
    'password' => $safe_mode_passwd,
  }

  dsc_windowsfeature { 'ADDSInstall':
    dsc_ensure => present,
    dsc_name   => 'AD-Domain-Services',
  }

  dsc_xaddomain { $domain_name:
    dsc_domainname                    => $domain_name,
    dsc_parentdomainname              => $parent_domain_name,
    dsc_domainadministratorcredential => $domain_credentials,
    dsc_safemodeadministratorpassword => $safemode_credentials,
    dsc_databasepath                  => $ad_db_path,
    dsc_sysvolpath                    => $sysvol_path,
    dsc_logpath                       => $ad_log_path,
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
