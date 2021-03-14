class vs_devops::dependencies::repos (
	$repos					= {},
	Boolean $forcePhp7Repo  = true,
	String $phpVersion		= '7.2',
) {
    case $::operatingsystem {
    	centos: {
		    if $::operatingsystemmajrelease == '7' {
		    	if ! defined( Package['yum-plugin-priorities'] ) {
		            Package { 'yum-plugin-priorities':
		                ensure => 'present',
		            }
		        }
		    } elsif $::operatingsystemmajrelease == '8' {
		    	if ! defined( Package['dnf-plugins-core'] ) {
			    	Package { 'dnf-plugins-core':
				        ensure => present,
				    }
				}
				
				include vs_devops::dependencies::powertools
		    } else {
		    	fail("CentOS support only tested on major version 7 or 8, you are running version '${::operatingsystemmajrelease}'")
		    }

	        $yumrepoDefaults = {
	            'ensure'   => 'present',
	            'enabled'  => true,
	            'gpgcheck' => false,
	            'priority' => 50,
	        }
	        
			include vs_devops::dependencies::epel
			
			class { 'vs_devops::dependencies::remi':
				yumrepoDefaults	=> $yumrepoDefaults,
		    }
		    
		    if ( $forcePhp7Repo ) {
			    class { 'vs_devops::dependencies::php7':
			    	phpVersion		=> $phpVersion,
					yumrepoDefaults	=> $yumrepoDefaults,
			    }
			}
	    }
	}
}