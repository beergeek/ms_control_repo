class profile::database_services::sqlserver (
  String $sql_source,
  String $sql_passwd,
  String $sql_user,
  Optional[String] $sqlserver_iso_location,
  Optional[String] $sqlserver_iso_source,
  Optional[String] $sqlserver_iso_mount_point,
  Optional[Hash] $db_hash   = {},
  String $sql_version       = 'MSSQL13',
  Boolean $enable_firewall  = true,
) {

  reboot { 'right_now':
    apply => 'immediately',
    when  => 'pending',
  }

  if $sqlserver_iso_location and $sqlserver_iso_source and $sqlserver_iso_mount_point {
    file { 'sqlserver_iso':
      ensure => file,
      path   => $sqlserver_iso_location,
      source => $sqlserver_iso_source,
    }

    mount_iso { 'sqlserver_iso':
      source       => $sqlserver_iso_location,
      drive_letter => $sqlserver_iso_mount_point,
      require      => File['sqlserver_iso'],
      before       => [Sqlserver_instance['MSSQLSERVER'],Sqlserver_features['Generic Features']],
    }
  }

  sqlserver_instance{'MSSQLSERVER':
    features              => ['SQLEngine','FullText'],
    source                => $sql_source,
    #    security_mode         => 'SQL',
    sa_pwd                => $sql_passwd,
    sql_sysadmin_accounts => [$sql_user],
    require               => Reboot['right_now'],
  }

  sqlserver_features { 'Generic Features':
    source   => 'E:/',
    features => ['BC', 'Conn'],
  }

  sqlserver::config { 'MSSQLSERVER':
    admin_user => 'sa',
    admin_pass => $sql_passwd,
  }

  $db_hash.each |String $key, Hash $value| {
    sqlserver::database { $key:
      instance => 'MSSQLSERVER',
    }
    sqlserver::login{ $key:
      password => $value['password'],
    }

    sqlserver::user{ $key:
      user     => $key,
      database => $key,
      require  => Sqlserver::Login[$key],
    }
  }

  if $enable_firewall {
    windows_firewall::exception { 'Sql browser access':
      ensure       => present,
      direction    => 'in',
      action       => 'Allow',
      enabled      => 'yes',
      program      => 'C:\Program Files (x86)\Microsoft SQL Server\90\Shared\sqlbrowser.exe',
      display_name => 'MSSQL Browser',
      description  => "MS SQL Server Browser Inbound Access",
    }

    windows_firewall::exception { 'Sqlserver access':
      ensure       => present,
      direction    => 'in',
      action       => 'Allow',
      enabled      => 'yes',
      program      => "C:\\Program Files\\Microsoft SQL Server\\${sql_version}.${db_instance}\\MSSQL\\Binn\\sqlservr.exe",
      display_name => 'MSSQL Access',
      description  => "MS SQL Server Inbound Access",
    }
  }

}
