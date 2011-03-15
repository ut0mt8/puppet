class dovecot {
	package { ["dovecot-imapd", "dovecot-pop3d", "rsyslog"]:
		ensure => present,
	}
	service {"dovecot":
		ensure => true,
		enable => true,
	}
	service {"rsyslog":
		ensure => true,
		enable => true,
	}
	file  { "/etc/rsyslog.d/dovecot.conf":
                owner => root,
                group => root,
                mode => 644,
                source => "puppet:///modules/dovecot/ipmail/rsyslog-dovecot.conf",
                notify => Service["rsyslog"],
                require => Package["rsyslog"],
        }
}
