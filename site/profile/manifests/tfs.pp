class profile::tfs (
  Hash $web_sites,
  Hash $website_defaults,
) {

  require profile::database_services::sqlserver
  require iis
  $web_sites.each |String $website_name, Hash $website_data| {
    iis::website { $website_name:
      * => $website_data,;
      default:
        * => $website_defaults,;
    }
  }

  staging::file { 'tfs':
    source => 'https://download.microsoft.com/download/d/b/0/db0b6e5f-4cb3-4d09-8023-bc4ee8f5d0c3/tfsserver2017.2.exe',
  }

}
