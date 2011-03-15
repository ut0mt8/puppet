#
# puppet class to manage squid
#

class squid {

	package { ["squid", "squidguard", "winbind", "samba-common-bin"]: 
       		ensure => present,
	}

# reload squid when the configuration file changes
	service { "squid":
       		require     => Package["squid"],
        	subscribe   => File["/etc/squid/squid.conf"],
	        restart     => "/usr/sbin/squid -k reconfigure",
		ensure => running,
	}

# Files

	file {"/etc/squid/squid.conf":
                owner  => root,
                mode => 640,
                source => "puppet:///modules/squid/squid.conf",
                require => Package["squid"],
                notify => Service[squid],
        }
	
        file {"/usr/share/squid/errors/French/ERR_NOT_AUTHENTIFIED":
                owner  => root,
                mode => 644,
                source => "puppet:///modules/squid/ERR/ERR_NOT_AUTHENTIFIED",
                require => Package["squid"],
                notify => Service[squid],
        }
        file {"/usr/share/squid/errors/French/ERR_MAXUSERS":
                owner  => root,
                mode => 644,
                source => "puppet:///modules/squid/ERR/ERR_MAXUSERS",
                require => Package["squid"],
                notify => Service[squid],
        }
        file {"/usr/share/squid/errors/French/ERR_NO_GROUP":
                owner  => root,
                mode => 644,
                source => "puppet:///modules/squid/ERR/ERR_NO_GROUP",
                require => Package["squid"],
                notify => Service[squid],
        }
        file {"/usr/share/squid/errors/French/ERR_RESTRICTED":
                owner  => root,
                mode => 644,
                source => "puppet:///modules/squid/ERR/ERR_RESTRICTED",
                require => Package["squid"],
                notify => Service[squid],
        }

}
