class bacula::storage {
	package { ["bacula-sd-mysql"]:
		ensure => present,
	}
	service { "bacula-sd":
		ensure => running,
		hasrestart => true,
		hasstatus => true,
		require => Package["bacula-sd-mysql"],
	}
	file {"/etc/bacula/bacula-sd.conf":
                owner  => root,
		group => bacula,
		mode => 640,
                source => "puppet:///modules/bacula/bacula-sd.conf",
		require => Package["bacula-sd-mysql"],
		notify => Service[bacula-sd],
	}

}
class bacula::director {
	package { ["bacula-director-mysql"]:
		ensure => present,
	}
	service { "bacula-director":
		ensure => running,
		hasrestart => true,
		hasstatus => true,
		require => Package["bacula-director-mysql"],
	}
	file {"/etc/bacula/bconsole.conf":
		owner  => root,
		group => bacula,
		mode => 640,
                source => "puppet:///modules/bacula/bconsole.conf",
		notify => Service[bacula-director],
	}
	file {"/etc/bacula/bacula-dir.conf":
                owner  => root,
		group => bacula,
		mode => 640,
                source => "puppet:///modules/bacula/bacula-dir.conf",
		require => Package["bacula-director-mysql"],
		notify => Service[bacula-director],
	}
	file {"/etc/bacula/scripts":
		owner  => root,
		group => bacula,
		mode => 640,
		ensure => directory,
	}
	file {"/etc/bacula/scripts/listTodayJobs.pl":
                owner  => root,
		group => bacula,
		mode => 755,
                source => "puppet:///modules/bacula/scripts/listTodayJobs.pl",
		require => File["/etc/bacula/scripts"],
	}
	file {"/etc/bacula/scripts/listPurgedVolumes.pl":
                owner  => root,
		group => bacula,
		mode => 755,
                source => "puppet:///modules/bacula/scripts/listPurgedVolumes.pl",
		require => File["/etc/bacula/scripts"],
	}
	file {"/etc/bacula/scripts/deleteFailedJobVolumes.pl":
                owner  => root,
		group => bacula,
		mode => 755,
                source => "puppet:///modules/bacula/scripts/deleteFailedJobVolumes.pl",
		require => File["/etc/bacula/scripts"],
	}
	file {"/etc/bacula/scripts/deleteClient.pl":
                owner  => root,
		group => bacula,
		mode => 755,
                source => "puppet:///modules/bacula/scripts/deleteClient.pl",
		require => File["/etc/bacula/scripts"],
	}
	file {"check_mk_bacula":
		path => "/usr/lib/check_mk_agent/plugins/bacula",
                owner  => root,
		group => bacula,
		mode => 755,
                source => "puppet:///modules/bacula/scripts/check_mk_bacula",
		require => File["/etc/bacula/scripts"],
	}
	file {"/etc/bacula/clients":
		owner  => root,
		group => bacula,
		mode => 640,
		ensure => directory,
	}
	file {"/etc/bacula/filesets":
		owner  => root,
		group => bacula,
		mode => 640,
		ensure => directory,
	}
	file {"/etc/bacula/messages.conf":
		owner  => root,
		group => bacula,
		mode => 440,
		source => "puppet:///modules/bacula/messages.conf",
		notify => Service[bacula-director],
	}
	file {"/etc/bacula/schedules.conf":
		owner  => root,
		group => bacula,
		mode => 440,
		source => "puppet:///modules/bacula/schedules.conf",
		notify => Service[bacula-director],
	}
	file {"/etc/bacula/storages.conf":
		owner  => root,
		group => bacula,
		mode => 440,
		source => "puppet:///modules/bacula/storages.conf",
		notify => Service[bacula-director],
	}

	define client ( $client_ip = '1.1.1.1', $admin_net = "no", $runbefore = "nothing" ) {
		file {"/etc/bacula/clients/$name.conf":
			owner  => root,
			group => bacula,
			mode => 440,
                	content => template("bacula/client.erb"),
			require => File["/etc/bacula/clients"],
			notify => Service[bacula-director],
        	}
		file {"/etc/bacula/filesets/$name.conf":
			owner  => root,
			group => bacula,
			mode => 440,
			source => "puppet:///modules/bacula/filesets/$name.conf",
			require => File["/etc/bacula/filesets"],
			notify => Service[bacula-director],
        	}
        }

}

class bacula::client {

	$packagename = $operatingsystem ? {
		Debian  => "bacula-fd",
		RedHat  => "bacula-client",
	}

	$workingdir = $operatingsystem ? {
		Debian  => "/var/lib/bacula",
		RedHat  => "/var/spool/bacula",
	}

	$piddir = $operatingsystem ? {
		Debian  => "/var/run/bacula",
		RedHat  => "/var/run",
	}

	package { "bacula-fd":
		name    => $packagename,
		ensure  => present,
	}

	file {"/etc/bacula/bacula-fd.conf":
                owner  => root,
		group => bacula,
		mode => 640,
                content => template("bacula/bacula-fd.erb"),
		require => Package["bacula-fd"],
		notify => Service[bacula-fd],
	}

	service { "bacula-fd":
		ensure => running,
		hasrestart => true,
	}

}
