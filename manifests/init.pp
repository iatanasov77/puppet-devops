class devops
{
    include epel
    include stdlib
    include devops::packages
    
    if ( $vsConfig['services']['maven'] == true )
    {
        # Install Maven
        class { "maven::maven":
            #version => "3.2.5", # version to install
            # you can get Maven tarball from a Maven repository instead than from Apache servers, optionally with a user/password
            repo => {
                #url => "http://repo.maven.apache.org/maven2",
                #username => "",
                #password => "",
            }
        }
    }
    
    if ( $vsConfig['services']['jenkins'] == true )
    {
        include devenv::php
        include devenv::phpextensions
        include devenv::frontendtools
        
        class { 'devops::jenkins':
            notify => Service[jenkins]
        }
	}
    
    if ( $vsConfig['services']['gitlab'] == true )
    {
	   include devops::gitlab
	}
	
	#########################
	# Setup Apache Server
	#########################
	include devenv::apache
	apache::vhost { "${hostname}":
		port    	=> '80',
		docroot 	=> '/vagrant/public', 
		override	=> 'all',
		#php_values 		=> ['memory_limit 1024M'],
		
		directories => [
			{
				'path'		        => '/vagrant/public',
				'allow_override'    => ['All'],
				'Require'           => 'all granted',
			}
		],
	}
}
