######## Server ##########

class mysql::server::config {
	File{
	    notify  => Class["mysql::server::service"],
	    owner   => "root",
	    group   => "root",
	    mode    => 644
	}

	file { "/etc/mysql":
		ensure => directory,
		owner   => "root",
		group   => "root",
		mode    => 755,
	}

	file{"/etc/mysql/my.cnf":
		source => [
		"puppet:///modules/mysql/my.cnf.$hostname",
		"puppet:///modules/mysql/my.cnf",
			],
		require => File["/etc/mysql"],
	}
}

class mysql::server::service {
	service{"mysql":
	    ensure  => running,
	    enable  => true,
	    require => Class["mysql::server::config"],
	    subscribe => Class["mysql::server::config"],
	}
}

class mysql::server {
	include mysql::server::config, mysql::server::service
	define version  ($myversion = "5.0") {
		case $myversion {
                        '5.1': {
				package { "mysql-server-5.1":
					ensure => present,
					require => Class["mysql::server::config"],
				}
				package { "mysql-client-5.1":
					ensure => present,
				}
			}
			default: {
				package { "mysql-server-5.0":
					ensure => present,
					require => Class["mysql::server::config"],
				}
				package { "mysql-client-5.0":
					ensure => present,
				}
			}
		}
	}
	define setpassword ($password = "defaultlamepassword") {
		exec { "Set MySQL server root password":
			subscribe => [ Class["mysql::server::config"], Class["mysql::server::service"] ],
			refreshonly => true,
			path => "/bin:/usr/bin",
			unless => "mysqladmin -uroot -p$password status",
			command => "mysqladmin -uroot password $password",
		}
	}
	package { ["xfsprogs", "xfsdump", "mytop"]:
		ensure => present,
	}
}


######## Client ##########

class mysql::client::install {
    package { "mysql-client":
        ensure  => present
    }
}

class mysql::client {
	include mysql::client::install
}
