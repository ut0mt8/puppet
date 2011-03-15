class puppet {

	file {"/etc/default/puppet":
		owner  => root,
		group => root,
		mode => 644,
		source => "puppet:///modules/puppet/puppet",
	}
	file {"/etc/puppet/puppet.conf":
		owner  => root,
		group => root,
		mode => 644,
		source => "puppet:///modules/puppet/puppet.conf",
		notify => Service["puppet"]
	}
	file {"/etc/puppet/auth.conf":
		owner  => root,
		group => root,
		mode => 644,
		source => "puppet:///modules/puppet/auth.conf",
		notify => Service["puppet"]
	}
	file {"/etc/puppet/namespaceauth.conf":
		owner  => root,
		group => root,
		mode => 644,
		source => "puppet:///modules/puppet/namespaceauth.conf",
		notify => Service["puppet"]
	}
	service{"puppet":
		enable  => true,
		require => Package["puppet"],
	}
	package { puppet:
		ensure => present
	}

}
