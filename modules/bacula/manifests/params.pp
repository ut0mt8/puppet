class bacula::params  {

    # General configuration
    $source    = "puppet:///modules/bacula/"
    $conf_base = "/etc/bacula"
    $data_base = "/data/bacula"

    # Catalog configuration
    $catalog_fqdn   = "localhost"
    $catalog_user   = "bacula"
    $catalog_passwd = "XXX"
    $catalog_dbname = "bacula"
    
    # Storage configuration
    $sd_fqdn   = "backup.corp.priv"
    $sd_passwd = "XXX"

    $sd_packagename = $operatingsystem ? {
        Debian  => "bacula-sd-mysql",
        default => "bacula-sd-mysql",
    }

    $sd_servicename = $operatingsystem ? {
        default => "bacula-sd",
    }

    $sd_workingdir = $operatingsystem ? {
        Debian  => "/var/lib/bacula",
        RedHat  => "/var/spool/bacula",
        default => "/var/lib/bacula",
    }

    $sd_piddir = $operatingsystem ? {
        Debian  => "/var/run/bacula",
        RedHat  => "/var/run",
        default => "/var/run/bacula",
    }

    # Director configuration
    $dir_fqdn   = "backup.corp.priv"
    $dir_passwd = "XXX"
    $mailto     = "root@backup.corp"

    $dir_packagename = $operatingsystem ? {
        Debian  => "bacula-director-mysql",
        default => "bacula-director-mysql",
    }

    $dir_servicename = $operatingsystem ? {
        default => "bacula-director",
    }

    $dir_workingdir = $operatingsystem ? {
        Debian  => "/var/lib/bacula",
        RedHat  => "/var/spool/bacula",
        default => "/var/lib/bacula",
    }

    $dir_piddir = $operatingsystem ? {
        Debian  => "/var/run/bacula",
        RedHat  => "/var/run",
        default => "/var/run/bacula",
    }

    # Client configuration
    $fd_packagename = $operatingsystem ? {
        Debian  => "bacula-fd",
        RedHat  => "bacula-client",
        default => "bacula-fd",
    }

    $fd_servicename = $operatingsystem ? {
        default => "bacula-fd",
    }

    $fd_workingdir = $operatingsystem ? {
        Debian  => "/var/lib/bacula",
        RedHat  => "/var/spool/bacula",
        default => "/var/lib/bacula",
    }

    $fd_piddir = $operatingsystem ? {
        Debian  => "/var/run/bacula",
        RedHat  => "/var/run",
        default => "/var/run/bacula",
    }

}
