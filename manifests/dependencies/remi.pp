class vs_devops::dependencies::remi (
	$yumrepoDefaults
) {
	case $::operatingsystem {
    	centos: {
		    if $::operatingsystemmajrelease == '7' {
		    	$remiReleaseRpm		= 'https://rpms.remirepo.net/enterprise/remi-release-7.rpm'
		    	$remiSafeMirrors	= 'http://cdn.remirepo.net/enterprise/7/safe/mirror'
		    	$requiredPackages	= [ Package['epel-release'], Package['yum-plugin-priorities'] ]
		    } elsif $::operatingsystemmajrelease == '8' {
		    	$remiReleaseRpm		= 'https://rpms.remirepo.net/enterprise/remi-release-8.rpm'
		    	$remiSafeMirrors	= 'http://cdn.remirepo.net/enterprise/8/safe/x86_64/mirror'
		    	$requiredPackages	= [ Package['epel-release'] ]
		    }
		    
		    if ! defined( Package['remi-release'] ) {
		        Package { 'remi-release':
		            ensure   => 'present',
		            name     => 'remi-release',
		            provider => 'rpm',
		            source   => $remiReleaseRpm,
		            require  => $requiredPackages,
		        }
		    }
		    
		    yumrepo { 'remi-safe':
		        descr      	=> 'Safe Remi RPM repository for Enterprise Linux',
		        mirrorlist	=> $remiSafeMirrors,
		        require  	=> $requiredPackages,
		        *          	=> $yumrepoDefaults,
		    }
		}
	}
}
