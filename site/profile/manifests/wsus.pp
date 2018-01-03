class profile::wsus (
) {

  require profile::database_services::sqlserver

  dsc_windowsfeature { 'UpdateServices':
    dsc_ensure => present,
    dsc_name   => 'UpdateServices',
  }
}
