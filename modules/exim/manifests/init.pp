class exim {
	package { ["exim4", "exim4-base", "exim4-config", "exim4-daemon-light"]:
		ensure => present,
	}
	service {"exim4":
		ensure => running,
	}
}
