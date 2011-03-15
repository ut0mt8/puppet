class mysql-mmm {

    package {[
		"iproute",
		"libalgorithm-diff-perl",
		"libclass-singleton-perl",
		"libdbd-mysql-perl",
		"libdbi-perl",
		"liblog-dispatch-perl",
		"liblog-log4perl-perl",
 		"libmailtools-perl",
		"libnet-arp-perl",
		"libproc-daemon-perl",
    ]:
	ensure => present }
}
