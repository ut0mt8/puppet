class motd {
	file { "/etc/motd.tail":
                content => template("motd/motd.erb") 
	}
	file { "/etc/motd":
                content => template("motd/motd.erb") 
	}
	file { "/var/run/motd":
                content => template("motd/motd.erb") 
	}
}
