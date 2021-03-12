class vs_devops::packages (
    Array $packages         = [],
    String $gitUserName     = 'undefined_user_name',
    String $gitUserEmail    = 'undefined@example.com',
) {
    $packages.each |String $value|
    {
        if ( $value == 'git' ) {
            require git
                
            git::config { 'user.name':
                value	=> $gitUserName,
                user    => 'vagrant',
            }
            git::config { 'user.email':
                value	=> $gitUserEmail,
                user	=> 'vagrant',
            }
        } elsif ( $value == 'git-ftp' ) {
        	##############################
        	# Download and Install GitFtp
        	##############################
        	exec { 'download git-ftp':
			    command => '/usr/bin/wget -P /tmp https://raw.githubusercontent.com/git-ftp/git-ftp/master/git-ftp',
			    creates => '/tmp/git-ftp',
			}
			
			file { '/bin/git-ftp':
			    source  => '/tmp/git-ftp',
			    mode    => 'a+x',
			    require => Exec['download git-ftp'],
			}
        } elsif ( $value == 'gitflow' ) {

            case $operatingsystem 
            {
                'Debian', 'Ubuntu':
                {
                    package { 'git-flow':
                        ensure => present,
                    }
                }
                'CentOS':
                {
                	if $::operatingsystemmajrelease == '8' {
						wget::fetch { "Download GitFlow Installer":
							source      => "https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh",
							destination => '/tmp/gitflow-installer.sh',
							verbose     => true,
							mode        => '0755',
							cache_dir   => '/var/cache/wget',
						} ->
						Exec { "Install GitFlow":
							command	=> '/tmp/gitflow-installer.sh',
						}
                	} else {
                		package { $value:
                            ensure => present,
                        }
                	}
                }
            }
        } else {
        	if ! defined(Package[$value]) {
	            package { $value:
	                ensure => present,
	            }
	        }
        }
    }
}
