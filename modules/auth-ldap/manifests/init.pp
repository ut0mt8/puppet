class auth-ldap {

	if ( $operatingsystem == "Debian" ) {

		$pkgautofs = $lsbdistcodename ? {
			lenny    => "autofs-ldap",
			squeeze  => "autofs5-ldap",
			default  => "autofs-ldap",
		}

		package { "autofs-ldap": 
			name   => "$pkgautofs",
			ensure => present,
		}

		package { sudo-ldap: ensure => present }
		package { nfs-common: ensure => present }
		package { ldap-utils: ensure => present }
		package { libpam-ldap: ensure => present }
		package { libnss-ldap: ensure => present }
		package { nscd: ensure => present }

		service { "autofs":
			enable => true,
			require => Package["autofs-ldap"],
		}
		service { "nscd":
			ensure => running,
			enable => true,
			require => Package["nscd"],
		}

		file { "/etc/nsswitch.conf":
			owner   => root,
			group   => root,
			mode    => 444,
			source  => "puppet:///modules/auth-ldap/etc/nsswitch.conf",
		}
		file { "/etc/ldap/schema":
			owner   => root,
			group   => root,
			mode    => 755,
			ensure => directory,
		}
		file { "/etc/ldap/schema/autofs.schema":
			owner   => root,
			group   => root,
			mode    => 444,
			source  => "puppet:///modules/auth-ldap/etc/ldap/schema/autofs.schema",
			require => Package["autofs-ldap"],
		}
		file { "/etc/pam.d/common-account":
			owner   => root,
			group   => root,
			mode    => 444,
			source  => "puppet:///modules/auth-ldap/etc/pam.d/common-account",
		}
		file { "/etc/pam.d/common-auth":
			owner   => root,
			group   => root,
			mode    => 444,
			source  => "puppet:///modules/auth-ldap/etc/pam.d/common-auth",
		}
		file { "/etc/pam.d/common-password":
			owner   => root,
			group   => root,
			mode    => 444,
			source  => "puppet:///modules/auth-ldap/etc/pam.d/common-password",
		}
		file { "/etc/pam.d/common-session":
			owner   => root,
			group   => root,
			mode    => 444,
			source  => "puppet:///modules/auth-ldap/etc/pam.d/common-session",
		}

		file { "/etc/libnss-ldap.conf":
			owner   => root,
			group   => root,
			mode    => 444,
			content  => template("auth-ldap/etc/libnss-ldap.conf"),
			require => Package["libnss-ldap"],
		}
		file { "/etc/pam_ldap.conf":
			owner   => root,
			group   => root,
			mode    => 444,
			content  => template("auth-ldap/etc/pam_ldap.conf"),
			require => Package["autofs-ldap"],
		}
		file { "/etc/default/autofs":
			owner   => root,
			group   => root,
			mode    => 444,
			content  => template("auth-ldap/etc/autofs"),
			require => Package["autofs-ldap"],
		}
		file { "/etc/ldap/ldap.conf":
			owner   => root,
			group   => root,
			mode    => 444,
			content  => template("auth-ldap/etc/ldap/ldap.conf"),
			require => Package["sudo-ldap"],
		}

		package { [
			"libnet-ldap-perl",
			"libio-socket-ssl-perl",
			"libterm-readkey-perl",
			]:
			ensure => present
		}
		file { "/usr/local/bin/pldap":
			owner   => root,
			group   => root,
			mode    => 755,
			source  => "puppet:///modules/auth-ldap/usr/local/bin/chpass",
			require => Package["libnet-ldap-perl", "libio-socket-ssl-perl","libterm-readkey-perl"],
		}
	}

	if ( $operatingsystem == "RedHat" ) {

		package { nfs-utils: ensure => present }
		package { autofs: ensure => present }
		package { nss_ldap: ensure => present }
		package { openldap-clients: ensure => present }
		package { nscd: ensure => present }

		service { "autofs":
			enable => true,
			require => Package["autofs"],
		}
		service { "nscd":
			ensure => running,
			enable => true,
			require => Package["nscd"],
		}

		file { "/etc/nsswitch.conf":
			owner   => root,
			group   => root,
			mode    => 444,
			source  => "puppet:///modules/auth-ldap/etc/nsswitch.conf",
		}
		file { "/etc/pam.d/system-auth-ac":
			owner   => root,
			group   => root,
			mode    => 444,
			source  => "puppet:///modules/auth-ldap/etc/pam.d/system-auth-ac",
		}
		file { "/etc/ldap.conf":
			owner   => root,
			group   => root,
			mode    => 444,
			content  => template("auth-ldap/etc/ldap.conf"),
			require => Package["nss_ldap"],
		}
		file { "/etc/openldap/ldap.conf":
			owner   => root,
			group   => root,
			mode    => 444,
			content  => template("auth-ldap/etc/ldap.conf"),
			require => Package["autofs"],
		}
		file { "/etc/sysconfig/autofs":
			owner   => root,
			group   => root,
			mode    => 444,
			content  => template("auth-ldap/etc/autofs"),
			require => Package["autofs"],
		}
	}
}

