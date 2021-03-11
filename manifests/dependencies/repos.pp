class vs_devops::dependencies::repos (
	$repos	= {},
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
		    
		    class { 'vs_devops::dependencies::php7':
				yumrepoDefaults	=> $yumrepoDefaults,
		    }
	    }
	}
}