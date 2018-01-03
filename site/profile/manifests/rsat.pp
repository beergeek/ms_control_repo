class profile::rsat {

  dsc_windowsfeature { 'rsat':
    dsc_ensure => present,
    dsc_name   => 'RSAT-ADDS',
  }
}
