# vim:syntax=ruby
class nginx {
    case $operatingsystem {
        default: { include nginx::base }
    }
}

class nginx::base {
        $nginx_sites = "/etc/nginx/sites"
        $nginx_conf = "/etc/nginx/conf.d"

	package {"nginx":
		ensure => installed,
	}

	service {"nginx":
		ensure => running,
		enable => true,
		hasstatus => false,
		require => Package[nginx],
	}

	file { "nginx_config":
		path => '/etc/nginx/nginx.conf',
		source => [ "puppet:///modules/nginx/${fqdn}/nginx.conf",
		"puppet:///modules/nginx/nginx.conf",],
		owner => root,
		group => 0,
		mode => 0644,
		require => Package[nginx],
		notify => Service[nginx],
	}
	file { ["/etc/nginx", "${nginx_sites}-enabled", "${nginx_sites}-available"]:
		ensure => directory,
		mode => 755,
		owner => root,
		group => root,
		require => Package["nginx"],
	}


# Notify this when Nginx needs a reload. This is only needed when
# sites are added or removed, since a full restart then would be
# a waste of time. When the module-config changes, a force-reload is
# needed.
	exec { "reload-nginx":
		command => "/etc/init.d/nginx reload",
		refreshonly => true,
		before => Service["nginx"]
	}

# Define an nginx site. Place all site configs into
# /etc/nginx/sites-available and en-/disable them with this type.
	define site ( $ensure = 'present', $content = '' ) {
		case $ensure {
			'present' : {
				nginx::base::install_site { $name:
				content => $content
				}
			}
			'installed' : {
				nginx::base::install_site { $name:
				content => $content
				}
			}
			'absent' : {
				exec { "/bin/rm ${nginx::base::nginx_sites}-enabled/$name":
					onlyif => "/bin/sh -c '[ -L ${nginx::base::nginx_sites}-enabled/$name ] && [ ${nginx::base::nginx_sites}-enabled/$name -ef ${nginx::base::nginx_sites}-available/$name ]'",
					notify => Exec["reload-nginx"],
					require => Package["nginx"],
				}
			}
			default: { err ( "Unknown ensure value: '$ensure'" ) }
		}
	}

# helper method to actually install a site -- called by site()
	define install_site ($content = '' ) {
# first, make sure the site config exists
		case $content {
			'': {
				file { "${nginx::base::nginx_sites}-available/${name}":
					source => "puppet:///modules/nginx/sites-available/${name}",
					mode => 644,
					owner => root,
					group => root,
					ensure => present,
					alias => "site-$name",
					notify => Exec["reload-nginx"],
				}
				file { "/var/log/nginx/${name}":
					mode => 755,
					owner => root,
					group => root,
					ensure => directory,
				}
			}

			default: {
				 file { "${nginx::base::nginx_sites}-available/${name}":
					content => $content,
					mode => 644,
					owner => root,
					group => root,
					ensure => present,
					alias => "site-$name",  
					notify => Exec["reload-nginx"],
				}        
				file { "/var/log/nginx/${name}":
					mode => 755,
					owner => root,
					group => root,
					ensure => directory,
				}
			 }
		}

# now, enable it.
		exec { "/bin/ln -s ${nginx::base::nginx_sites}-available/$name ${nginx::base::nginx_sites}-enabled/$name":
			unless => "/bin/sh -c '[ -L ${nginx::base::nginx_sites}-enabled/$name ] && [ ${nginx::base::nginx_sites}-enabled/$name -ef ${nginx::base::nginx_sites}-available/$name ]'",
			notify => Exec["reload-nginx"],
			require => [ File["site-$name"], Package["nginx"]],
		}
	}

}


class nginx::php {
	package { ["spawn-fcgi", "php5-cgi"]:
		ensure => installed,
	}
# config de php cote nginx
	file { "fcgi_params":
		path => '/etc/nginx/fcgi_params',
		source => [ "puppet:///modules/nginx/fcgi_params",],
		owner => root,
		group => 0,
		mode => 0644,
	}
	file { "php.conf":
		path => '/etc/nginx/php.conf',
		source => [ "puppet:///modules/nginx/php.conf",],
		owner => root,
		group => 0,
		mode => 0644,
		require => [Package[nginx], File["fcgi_params"]],
		notify => Service[nginx],
	}
# config du daemon FastCGI et initialisation pour le demarrage.
	file { "php-fastcgi":
		path => '/usr/bin/php-fastcgi',
		source => [ "puppet:///modules/nginx/php-fastcgi",],
		owner => root,
		group => 0,
		mode => 0755,
		require => [Package["spawn-fcgi"], Package["php5-cgi"]],
	}
	file { "init-fcgi":
		path => '/etc/init.d/php-fastcgi', 
		source => [ "puppet:///modules/nginx/init-fcgi",],
		owner => root,
		group => 0,
		mode => 0755,
		require => [Package["spawn-fcgi"], Package["php5-cgi"]],
	}
	service {"php-fastcgi":
		ensure => running,
		enable => true,
		hasstatus => true,
		require => [Package["spawn-fcgi"], Package["php5-cgi"]],
	}
}
