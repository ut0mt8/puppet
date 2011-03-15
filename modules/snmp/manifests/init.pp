# Class: snmp

# Requires:
# $snmpSyslocation must be set in site manifest
# $contactEmail must be set in site manifest
#
class snmp {

    $packagename = $operatingsystem ? {
        Debian  => "snmpd",
        RedHat  => "net-snmp",
    }

    package { "snmpd": 
	name   => "$packagename",
        ensure => present,
    }

    file { "/etc/snmp/snmpd.conf":
	owner   => root,
        group   => root,
        mode    => 600,
        content => template("snmp/snmpd.conf.erb"),
        notify => Service["snmpd"],
        require => Package["snmpd"],
    } 

    file { "/etc/default/snmpd":
	owner   => root,
        group   => root,
        mode    => 644,
	source  => "puppet:///modules/snmp/snmpd",
        notify => Service["snmpd"],
        require => Package["snmpd"],
    } 

    service { "snmpd":
        enable => true,
        ensure => running,
        require => Package["snmpd"],
    }

}
