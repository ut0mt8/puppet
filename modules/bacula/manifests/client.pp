#
# Class: bacula::client
#
# Manages bacula client side.
# Include it to install and run bacula on client
# Usage:
# include bacula::client
# or
# class bacula::client ( #params to overide )
#
class bacula::client ( 
    $client_name     = $hostname, 
    $client_ip       = $ipaddress, 
    $admin_net       = "", 
    $runbefore       = "",
    $exported        = true,
    $source          = $bacula::params::source,
    $conf_base       = $bacula::params::conf_base,
    $data_base       = $bacula::params::data_base,
    $sd_fqdn         = $bacula::params::sd_fqdn,
    $sd_admin_fqdn   = $bacula::params::sd_admin_fqdn,
    $sd_passwd       = $bacula::params::sd_passwd,
    $sd_packagename  = $bacula::params::sd_packagename,
    $sd_servicename  = $bacula::params::sd_servicename,
    $dir_fqdn        = $bacula::params::dir_fqdn,
    $dir_passwd      = $bacula::params::dir_passwd,
    $dir_packagename = $bacula::params::dir_packagename,
    $dir_servicename = $bacula::params::dir_servicename,
    $fd_packagename  = $bacula::params::fd_packagename,
    $fd_servicename  = $bacula::params::fd_servicename,
    $fd_workingdir   = $bacula::params::fd_workingdir,
    $fd_piddir       = $bacula::params::fd_piddir
    ) inherits bacula::params {

    # File Daemon
    package { "bacula-fd":
        name   => "${fd_packagename}",
        ensure => present,
    }

    service { "bacula-fd":
        name       => "${fd_servicename}",
        ensure     => running,
        enable     => true,
        hasrestart => true,
        require    => Package["bacula-fd"],
    }

    file { "bacula-fd.conf":
        path    => "${conf_base}/bacula-fd.conf",
        mode    => '0640',
        owner   => 'root',
        group   => 'bacula',
        ensure  => present,
        require => Package["bacula-fd"],
        notify  => Service["bacula-fd"],
        content => template("bacula/bacula-fd.conf.erb"),
    }

    # exported stored configs
    if ($exported) {

        @@file { "exported_client_${client_name}.conf":
            path    => "${conf_base}/clients/${client_name}.conf",
            mode    => '0440',
            owner   => 'root',
            group   => 'bacula',
            ensure  => present,
            require => Package["bacula-dir"],
            notify  => Service["bacula-dir"],
            content => template("bacula/client.erb"),
        }

        @@file { "exported_fileset_${client_name}.conf":
            path    => "${conf_base}/filesets/${client_name}.conf",
            source  => "${source}/filesets/${client_name}.conf",
            mode    => '0440',
            owner   => 'root',
            group   => 'bacula',
            ensure  => present,
            require => Package["bacula-dir"],
            notify  => Service["bacula-dir"],
        }

        @@file { "exported_device_${client_name}.conf":
            path    => "${conf_base}/devices/${client_name}.conf",
            mode    => '0440',
            owner   => 'root',
            group   => 'bacula',
            ensure  => present,
            require => Package["bacula-sd"],
            notify  => Service["bacula-sd"],
            content => template("bacula/device.erb"),
        }

        @@file { "exported_device_dir_${client_name}":
            path    => "${data_base}/Device-${client_name}",
            mode    => '0644',
            owner   => 'bacula',
            group   => 'bacula',
            ensure  => directory,
        }
    }
}
