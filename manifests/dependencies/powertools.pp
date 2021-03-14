class vs_devops::dependencies::powertools (

) {
	case $::operatingsystem {
    	centos: {
    		if $::operatingsystemmajrelease == '8' {
				yumrepo { 'PowerTools':
					ensure      => 'present',
					mirrorlist 	=> 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=PowerTools&infra=$infra',
					enabled     => 1,
					gpgcheck 	=> 0,
					require		=> Package['dnf-plugins-core'],
				}
			}
		}
	}
}
