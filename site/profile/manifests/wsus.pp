class profile::wsus (
) {

  require profile::database_services::sqlserver
  require iis

  dsc_windowsfeature { 'UpdateServices':
    dsc_ensure => present,
    dsc_name   => 'UpdateServices',
  }
}
