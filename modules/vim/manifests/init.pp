class vim {

        $packagename = $operatingsystem ? {
                Debian  => "vim",
                RedHat  => "vim-enhanced",
        }

	package { "vim": 
		name   => "$packagename",
		ensure => present 
	}

	package { "nvi": 
		name   => "nvi",
		ensure => present 
	}

	file { "/root/.vimrc":
		owner  => root, 
		group => root, mode => 644,
		source => "puppet:///modules/vim/vimrc",
	}

}
