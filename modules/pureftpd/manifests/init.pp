class pureftpd::install {
	package{"pure-ftpd":
	    ensure => present
	}
}

class pureftpd::install::mysql {
	package{"pure-ftpd-mysql":
	    ensure => present
	}
}

class pureftpd::service::mysql {
	service{"pure-ftpd-mysql":
	    enable  => true,
	}
}

class pureftpd::config::www {
	File {
	    require => Class["pureftpd::install::mysql"],
	    notify  => Class["pureftpd::service::mysql"],
	    owner   => "root",
	    group   => "root",
	    mode    => 644
	}

	file {"/etc/pure-ftpd/mysql-init.sql-www":
		source => "puppet:///modules/pureftpd/www/init.sql",
	}
	file {"/etc/pure-ftpd/db/mysql.conf-www":
		source => "puppet:///modules/pureftpd/www/db/mysql.conf",
		mode => 600,
	}
	file {"/etc/default/pure-ftpd-common":
		source => "puppet:///modules/pureftpd/www/pure-ftpd-common",
	}
}

class pureftpd {
	include pureftpd::install
}

class pureftpd::www {
	include pureftpd::install::mysql, pureftpd::service::mysql, pureftpd::config::www
}
