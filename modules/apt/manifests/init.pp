class apt {
	$debianname = $lsbdistcodename ? {
		lenny    => "lenny",
		squeeze  => "squeeze",
		default  => "lenny",
        }

	file {
		"/etc/apt/sources.list":
		owner  => root, group => root, mode => 644,
		content => template("apt/sources.list"),
	}

	file {
		"/etc/apt/apt.conf.d/":
		owner  => root, group => root, mode => 755,
		ensure => directory,
	}
	file {
		"/etc/apt/apt.conf.d/00prefs":
		owner  => root, group => root, mode => 644,
		source => "puppet:///modules/apt/00prefs",
		require => File["/etc/apt/apt.conf.d/"],
	}

	file {
		"/etc/apt/preferences":
		owner  => root, group => root, mode => 644,
		content => template("apt/preferences"),
	}

	exec { "/usr/bin/apt-get -q -q update":
		logoutput   => false,
		refreshonly => true,
		subscribe   => File["/etc/apt/sources.list"]
	}

	# install key for debian-backports.
	exec {"/usr/bin/wget -O - http://backports.org/debian/archive.key | /usr/bin/apt-key add -":
		refreshonly => true,
		subscribe   => File["/etc/apt/preferences"],
	}
      
	exec { "apt-get_update":
		command => "/usr/bin/apt-get -q -q update",
		refreshonly => true,
	}

	exec { "apt-file_update":
		command => "/usr/bin/apt-file update",
		refreshonly => true,
		require  => [ Package["apt-file"] ]
	}
	
	package { "apt-file": 
		ensure => installed, 
		notify  => Exec["apt-file_update"]
	}

}

define apt::sources_list ( $ensure = present, $source = false, $content = false) { 
  if $source {
    file {"/etc/apt/sources.list.d/${name}.list":
      ensure => $ensure,
      source => $source,
      before => Exec["apt-get_update"],
      notify => Exec["apt-get_update"],
    }
  } else {
    file {"/etc/apt/sources.list.d/${name}.list":
      ensure => $ensure,
      content => $content,
      before => Exec["apt-get_update"],
      notify => Exec["apt-get_update"],
    }
  }
}

define apt::key($ensure=present, $source="") {

  case $ensure {

    present: {
      exec { "import gpg key $name":
        command => $source ? {
          "" => "gpg --keyserver keys.gnupg.net --recv-key '$name' && gpg --export --armor '$name' | /usr/bin/apt-key add -",
          default => "wget -O - '$source' | /usr/bin/apt-key add -",
        },
        unless => "apt-key list | grep -Fqe '${name}'",
        path => "/bin:/usr/bin",
        before => Exec["apt-get_update"],
        notify => Exec["apt-get_update"],
      }
    }
    
    absent: {
      exec {"/usr/bin/apt-key del ${name}":
        onlyif => "apt-key list | grep -Fqe '${name}'",
      }
    }
  }
}


