class profile::dns::resolv (
	Array[String] $dns_servers,
  Boolean $purge = false,
) {

	class { '::resolv_conf':
		domainname  => $facts['domain'],
		nameservers => $dns_servers,
	}

	@@host { $facts['fqdn']:
		ensure        => present,
		host_aliases  => [$facts['hostname']],
		ip            => $ip,
	}

	host { 'localhost':
		ensure       => present,
		host_aliases => ['localhost.localdomai','localhost6','localhost6.localdomain6'],
		ip           => '127.0.0.1',
	}

  # Need to convert this to a puppetdb_query
	Host <<| |>>

	if $purge {
		resources { 'host':
			purge => true,
		}
	}
}
