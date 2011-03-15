class dovecot::ipmail inherits dovecot {
        file { "/etc/dovecot/dovecot.conf":
                ensure => present,
		owner => root,
                group => root,
                mode => 644,
                source => "puppet:///modules/dovecot/ipmail/dovecot.conf",
                notify => Service["dovecot"],
                require => Package["dovecot-imapd"],
        }
        file { "/etc/dovecot/dovecot-sql.conf":
                owner => root,
                group => root,
                mode => 600,
                content => template("dovecot/ipmail/dovecot-sql.conf"),
                notify => Service["dovecot"],
                require => Package["dovecot-imapd"],
        }
}
