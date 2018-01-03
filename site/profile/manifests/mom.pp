class profile::mom (
  Hash $firewall_rule_defaults,
  Optional[Hash] $firewall_rules = {},
  Boolean $enable_firewall = true,
) {

  service { 'pe-activemq':
    ensure => stopped,
    enable => false,
  }

  if $enable_firewall and $firewall_rules and !empty($firewall_rules) {
		$firewall_rules.each |String $rule_name, Hash $rule_data| {
			firewall { $rule_name:
				*   => $rule_data;
			default:
				* => $firewall_rule_defaults,
			}
		}
	}
}
