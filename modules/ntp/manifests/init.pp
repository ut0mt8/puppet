class ntp {

	$servicename = $operatingsystem ? {
        	Debian  => "ntp",
        	RedHat  => "ntpd",
	} 

	package{"ntp":
	    ensure => present
	}

	case $operatingsystem { 
		Debian: { package{"ntpdate": ensure => present, } }
	}

	file{"ntp.conf":
		path    => "/etc/ntp.conf",
		source  => "puppet:///modules/ntp/ntp.conf",
		owner   => "root",
		group   => "root",
		mode    => 644,
		notify  => Service["ntp"],
	}

	service{"ntp":
		name    => "$servicename",
		ensure  => running,
		enable  => true,
		require => File["ntp.conf"],
	}
}

