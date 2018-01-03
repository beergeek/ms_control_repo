class profile::ssh (
  Boolean $enable_firewall = true,
) {

  if $enable_firewall {
    firewall { '010 accept SSH':
      proto  => 'tcp',
      dport  => '22',
      action => 'accept',
    }
  }
}

