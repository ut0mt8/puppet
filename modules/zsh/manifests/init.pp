class zsh {

    package { zsh: ensure => present }

      file {
	"/root/.zshrc":
          owner  => root, group => root, mode => 644,
          source => "puppet:///modules/zsh/zshrc",
      }

}
