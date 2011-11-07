#
# Class: bacula::server
#
# Manages bacula server side.
# Include it to install and run bacula server part
# Note : bacula director and storage are handled together
# for simplicity purpose
#
# Usage:
# include bacula::server ( #params to overide )
#
class bacula::server (
    $source          = $bacula::params::source,
    $conf_base       = $bacula::params::conf_base,
    $data_base       = $bacula::params::data_base,
    $mailto          = $bacula::params::mailto,
    $sd_fqdn         = $bacula::params::sd_fqdn,
    $sd_passwd       = $bacula::params::sd_passwd,
    $sd_workingdir   = $bacula::params::sd_workingdir,
    $sd_piddir       = $bacula::params::sd_piddir,
    $sd_packagename  = $bacula::params::sd_packagename,
    $sd_servicename  = $bacula::params::sd_servicename,
    $dir_fqdn        = $bacula::params::dir_fqdn,
    $dir_passwd      = $bacula::params::dir_passwd,
    $dir_workingdir  = $bacula::params::dir_workingdir,
    $dir_piddir      = $bacula::params::dir_piddir,
    $dir_packagename = $bacula::params::dir_packagename,
    $dir_servicename = $bacula::params::dir_servicename,
    $catalog_fqdn    = $bacula::params::catalog_fqdn,
    $catalog_user    = $bacula::params::catalog_user,
    $catalog_passwd  = $bacula::params::catalog_passwd,
    $catalog_dbname  = $bacula::params::catalog_dbname
    ) inherits bacula::params {

    package { "bacula-sd":
        name   => "${sd_packagename}",
        ensure => present,
    }

    service { "bacula-sd":
        name       => "${sd_servicename}",
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package["bacula-sd"],
    }

    file { "bacula-sd.conf":
        path    => "${conf_base}/bacula-sd.conf",
        mode    => '0640',
        owner   => 'root',
        group   => 'bacula',
        ensure  => present,
        require => Package["bacula-sd"],
        notify  => Service["bacula-sd"],
        content => template("bacula/bacula-sd.conf.erb"),
    }

    file { "devices":
        path    => "${conf_base}/devices",
        alias   => "devices",
        mode    => '0640',
        owner   => 'root',
        group   => 'bacula',
        ensure  => directory,
    }

    # Director Daemon basics
    package { "bacula-dir":
        name   => "${dir_packagename}",
        ensure => present,
    }

    service { "bacula-dir":
        name       => "${dir_servicename}",
        ensure     => running,
        enable     => true,
        hasrestart => true,
        hasstatus  => true,
        require    => Package["bacula-dir"],
    }

    file { "bacula-dir.conf":
        path    => "${conf_base}/bacula-dir.conf",
        mode    => '0640',
        owner   => 'root',
        group   => 'bacula',
        ensure  => present,
        require => Package["bacula-dir"],
        notify  => Service["bacula-dir"],
        content => template("bacula/bacula-dir.conf.erb"),
    }

    file { "bconsole.conf":
        path    => "${conf_base}/bconsole.conf",
        mode    => '0640',
        owner   => 'root',
        group   => 'bacula',
        ensure  => present,
        require => Package["bacula-dir"],
        notify  => Service["bacula-dir"],
        content => template("bacula/bconsole.conf.erb"),
    }

    file { "messages.conf":
        path    => "${conf_base}/messages.conf",
        mode    => '0640',
        owner   => 'root',
        group   => 'bacula',
        ensure  => present,
        require => Package["bacula-dir"],
        notify  => Service["bacula-dir"],
        content => template("bacula/messages.conf.erb"),
    }

    # Some usefull scripts
    file { "scripts":
        path    => "${conf_base}/scripts",
        mode    => '0750',
        owner   => 'root',
        group   => 'bacula',
        ensure  => directory,
        recurse => true,
    }

    # Monitoring script
    file { "check_mk_bacula":
        path    => "/usr/lib/check_mk_agent/plugins/bacula",
        source  => "${source}/scripts/check_mk_bacula",
        mode    => '0755',
        owner   => 'root',
        group   => 'bacula',
        ensure  => present,
        require => Package["bacula-dir"],
    }

    # Directories for clients configurations
    file { "clients":
        path    => "${conf_base}/clients",
        mode    => '0640',
        owner   => 'root',
        group   => 'bacula',
        ensure  => directory,
    }

    file { "filesets":
        path    => "${conf_base}/filesets",
        mode    => '0640',
        owner   => 'root',
        group   => 'bacula',
        ensure  => directory,
    }

    # Method for adding specific clients (no puppet client) 
    # mandatory args are client_name and client_ip
    define client ( 
        $client_name   = $name,  
        $client_ip     = "", 
        $admin_net     = "", 
        $runbefore     = "",
        $source        = $bacula::params::source,
        $conf_base     = $bacula::params::conf_base,
        $data_base     = $bacula::params::data_base,
        $sd_fqdn       = $bacula::params::sd_fqdn,
        $sd_admin_fqdn = $bacula::params::sd_admin_fqdn,
        $sd_passwd     = $bacula::params::sd_passwd,
        $dir_fqdn      = $bacula::params::dir_fqdn,
        $dir_passwd    = $bacula::params::dir_passwd ) {

        file { "client_${client_name}.conf":
            path    => "${conf_base}/clients/${client_name}.conf",
            mode    => '0440',
            owner   => 'root',
            group   => 'bacula',
            ensure  => present,
            require => Package["bacula-dir"],
            notify  => Service["bacula-dir"],
            content => template("bacula/client.erb"),
        }

        file { "fileset_${client_name}.conf":
            path    => "${conf_base}/filesets/${client_name}.conf",
            source  => "${source}/filesets/${client_name}.conf",
            mode    => '0440',
            owner   => 'root',
            group   => 'bacula',
            ensure  => present,
            require => Package["bacula-dir"],
            notify  => Service["bacula-dir"],
        }

        file { "device_${client_name}.conf":
            path    => "${conf_base}/devices/${client_name}.conf",
            mode    => '0440',
            owner   => 'root',
            group   => 'bacula',
            ensure  => present,
            require => Package["bacula-sd"],
            notify  => Service["bacula-sd"],
            content => template("bacula/device.erb"),
        }

        file { "device_dir_${client_name}":
            path    => "${data_base}/Device-${client_name}",
            mode    => '0644',
            owner   => 'bacula',
            group   => 'bacula',
            ensure  => directory,
        }
    }

    # create all stored clients configurations files
    File <<| tag == "bacula" |>> 

}

