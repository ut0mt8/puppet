class resolv {
	file { "/etc/resolv.conf":
		owner => root,
		group => root,
		mode => 644,
		source => "puppet:///modules/resolv/resolv.conf"
	}
}
