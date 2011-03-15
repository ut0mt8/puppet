class ssh {

	$servicename = $operatingsystem ? {
	        Debian  => "ssh",
	        RedHat  => "sshd",
	}

	package{"openssh-server":
		ensure => present,
	}

	service{"sshd":
		name    => "$servicename",
		ensure  => running,
		enable  => true,
		require => File["sshd_config"],
	}

	file{"ssh_config":
		path    => "/etc/ssh/ssh_config",
		source => "puppet:///modules/ssh/ssh_config",
		owner   => "root",
		group   => "root",
		mode    => 644
	}

	file{"sshd_config":
		notify  => Service["sshd"],
		path    => "/etc/ssh/sshd_config",
		source  => "puppet:///modules/ssh/sshd_config",
		owner   => "root",
		group   => "root",
		mode    => 644
	}

	file{"/etc/ssh/ssh_host_dsa_key":
		source => "puppet:///modules/ssh/$hostname/ssh_host_dsa_key",
		owner  => "root",
		group  => "root",
		mode   => 600,
	}
	file{"/etc/ssh/ssh_host_dsa_key.pub":
		source => "puppet:///modules/ssh/$hostname/ssh_host_dsa_key.pub",
		owner  => "root",
		group  => "root",
		mode   => 644,
	}
	file{"/etc/ssh/ssh_host_rsa_key":
		source => "puppet:///modules/ssh/$hostname/ssh_host_rsa_key",
		owner  => "root",
		group  => "root",
		mode   => 600,
	}
	file{"/etc/ssh/ssh_host_rsa_key.pub":
		source => "puppet:///modules/ssh/$hostname/ssh_host_rsa_key.pub",
		owner  => "root",
		group  => "root",
		mode   => 644,
	}
}
