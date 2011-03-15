class exim::mailclient inherits exim {
	exec { "exim-update":
		command => "/usr/sbin/update-exim4.conf",
		subscribe => File["/etc/exim4/update-exim4.conf.conf"],
		refreshonly => true
	} 

	file { "/etc/exim4/update-exim4.conf.conf":
		owner => root,
		group => root,
		mode => 644,
		content => template("exim/update-exim4.conf.conf"),
		notify => Service["exim4"],
		require => Package["exim4"],
	}
}
