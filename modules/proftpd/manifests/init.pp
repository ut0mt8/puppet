class proftpd::install {
	package{"proftpd":
	    ensure => present
	}
}

class proftpd::config {
	File{
	    require => Class["proftpd::install"],
	    notify  => Class["proftpd::service"],
	    owner   => "root",
	    group   => "root",
	    mode    => 644
	}

	file{"/etc/proftpd.conf":
		source => "puppet:///modules/proftpd/proftpd.conf",
	}
}

class proftpd::service {
	service{"proftpd":
	    ensure  => running,
	    enable  => true,
	    require => Class["proftpd::config"],
	    subscribe => Class["proftpd::config"],
	}
}

class proftpd {
	include proftpd::install, proftpd::config, proftpd::service
}
