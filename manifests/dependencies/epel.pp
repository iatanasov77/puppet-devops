class vs_devops::dependencies::epel (

) {
	case $::operatingsystem {
    	centos: {
			if ! defined( Package['epel-release'] ) {
		        Exec { 'Import RPM GPG KEYS':
		            command => 'rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY*',
		        } ->
		        Package { 'epel-release':
		            ensure   => 'present',
		            provider => 'yum',
		        }
		    }
		}
	}
}
