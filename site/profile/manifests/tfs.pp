class profile::tfs (
) {

  require profile::database_services::sqlserver

  staging::file { 'tfs':
    source => 'https://download.microsoft.com/download/d/b/0/db0b6e5f-4cb3-4d09-8023-bc4ee8f5d0c3/tfsserver2017.2.exe',
  }

  
}
