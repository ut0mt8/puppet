class fstab {

      file {
	"/etc/fstab":
          owner  => root, group => root, mode => 644,
          source => "puppet:///modules/fstab/$hostname/fstab",
      }

}
