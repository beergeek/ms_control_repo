class profile::rsat {


  dsc_windowsfeature { 'rsat-adds':
    dsc_ensure => present,
    dsc_name   => 'RSAT-ADDS',
  }

  dsc_windowsfeature { 'rsat-ad-tools':
    dsc_ensure => present,
    dsc_name   => 'RSAT-AD-Tools',
  }

  dsc_windowsfeature { 'rsat-adds-tools':
    dsc_ensure => present,
    dsc_name   => 'RSAT-ADDS-Tools',
  }
}
