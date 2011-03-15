class tools {

	if ( $operatingsystem == "Debian" ) {
		package {[
			"binutils",
			"bzip2",
			"dmidecode",
			"dnsutils",
			"ethtool",
			"file",
			"ftp",
			"host",
			"lsb-release",
			"less",
			"locate",
			"lshw",
			"manpages-dev",
			"mtr-tiny",
			"pciutils",
			"rsync",
			"screen",
			"smartmontools",
			"snmp",
			"sqlite3",
			"strace",
			"sysstat",
			"tcpdump",
			"telnet",
			"unzip",
			]:
		ensure => present }
	}	

# all is already include in RH minimal system :/
	if ( $operatingsystem == "RedHat" ) {
		package {[
			"lshw",
			"pciutils",
			"rsync",
			"screen",
			"net-snmp-utils",
			"strace",
			"sysstat",
			"tcpdump",
			]:
		ensure => present }
	}	
}
