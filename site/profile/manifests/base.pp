class profile::base (
  Boolean $enable_firewall = true,
) {

  # Stop MCO
  service { 'mcollective':
    ensure => stopped,
    enable => false,
  }

  include staging

  if $facts['kernel'] == 'Windows' {
    include chocolatey
    Class['chocolatey'] -> Package<||>

    reboot { 'after_dotnet':
      apply => 'immediately',
      when  => pending,
    }

    reboot { 'after_powershell':
      apply => 'immediately',
      when  => pending,
    }

    package { 'dotnet4.5.2':
      ensure          => present,
      provider        => 'chocolatey',
      notify          => Reboot['after_dotnet'],
    }

    package { 'powershell':
      ensure          => present,
      provider        => 'chocolatey',
      install_options => ['-pre'],
      notify          => Reboot['after_powershell'],
    }

    file { 'ISOs':
      ensure => directory,
      path   => 'c:\\ISOs',
    }

    if $trusted['extensions']['pp_role'] != 'ad_controller' and $trusted['extensions']['pp_role'] != 'ad_child_controller' {
      include profile::dns
      include profile::domain
    }

    include profile::wsus_services

    reboot { 'dsc_reboot':
      message => 'DSC is rebooting this machine',
      when    => 'pending',
    }
		} elsif $facts['kernel'] == 'Linux' {
			include profile::dns

			if $enable_firewall {
				include ::firewall
				include profile::fw::pre
				include profile::fw::post
			} else {
				class { '::firewall':
					ensure => stopped,
				}
			}
      include profile::ssh
		}
}
