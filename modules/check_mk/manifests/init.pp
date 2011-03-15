# Class: check_mk
#
class check_mk {

	file { "/usr/local/sbin/check_mk_agent":
		owner   => root,
		group   => root,
		mode    => 700,
		source => "puppet:///modules/check_mk/check_mk_agent",
	} 

	file { "/usr/bin/waitmax":
		owner   => root,
		group   => root,
		mode    => 555,
		source => "puppet:///modules/check_mk/waitmax.$architecture",
	}

	xinetd::service { "check_mk":
		port        => "6556",
		server      => "/usr/local/sbin/check_mk_agent",
		untype      => "UNLISTED",
	}

	file { "plugindirparent2" :
		path => "/usr/lib/check_mk_agent",
		ensure => "directory",
		owner   => root,
		group   => root,
		mode    => 755,
	}

	file { "plugindirparent1" :
		path => "/usr/lib/check_mk_agent/plugins",
		ensure => "directory",
		owner   => root,
		group   => root,
		mode    => 755,
		require => File["plugindirparent2"],
	}

# homemade checks
	file {"exim_mailq":
		path => "/usr/lib/check_mk_agent/plugins/exim_mailq",
		source => "puppet:///modules/check_mk/client/exim_mailq",
		require => File["plugindirparent1"],
		owner   => root,
		group   => root,
		mode    => 755,
	}

}

class check_mk::server {
# Create the destination directory before 
	file {"libdir":
		path => "/usr/share/check_mk",
		ensure => "directory",
		owner   => root,
		group   => root,
		mode    => 755,
	}
	file {"checksdir":
		path => "/usr/share/check_mk/checks",
		     ensure => "directory",
		     require => File["libdir"],
		     owner   => root,
		     group   => root,
		     mode    => 755,
	}
# homemade modules
	file {"exim_mailq_check":
		path => "/usr/share/check_mk/checks/exim_mailq",
		     source => "puppet:///modules/check_mk/server/exim_mailq",
		     owner   => root,
		     group   => root,
		     mode    => 664,
		     require => File["checksdir"],
	}
	file {"redback_cpu":
		path => "/usr/share/check_mk/checks/redback_cpu",
		     source => "puppet:///modules/check_mk/server/redback_cpu",
		     owner   => root,
		     group   => root,
		     mode    => 664,
		     require => File["checksdir"],
	}
	file {"redback_ps":
		path => "/usr/share/check_mk/checks/redback_ps",
		     source => "puppet:///modules/check_mk/server/redback_ps",
		     owner   => root,
		     group   => root,
		     mode    => 664,
		     require => File["checksdir"],
	}
	file {"bacula":
		path => "/usr/share/check_mk/checks/bacula",
		     source => "puppet:///modules/check_mk/server/bacula",
		     owner   => root,
		     group   => root,
		     mode    => 664,
		     require => File["checksdir"],
	}
}
