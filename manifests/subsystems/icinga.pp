############################################################
# Using this module: https://forge.puppet.com/thias/nagios
############################################################
class vs_devops::subsystems::icinga (
	Hash $config    = {},
) {
	case $::operatingsystem {
    	#centos: {
    	'RedHat', 'CentOS', 'OracleLinux', 'Fedora', 'AlmaLinux': {
            if Integer( $::operatingsystemmajrelease ) < 9 {
        		$centosVersion	= $::operatingsystemmajrelease
        		
        		#include vs_devops::webserver
    		    Exec{ 'Icinga-Rpm':
    		        command => "/bin/yum -y install https://packages.icinga.com/epel/icinga-rpm-release-${centosVersion}-latest.noarch.rpm",
    		        require	=> [ Package['epel-release'] ]
    		    } ->
    		    class { '::icinga2':
    		        manage_repos    => false,
    		        manage_package  => true,
    		    }
            } else {
                /*
                 * Not Work For CentOs 9
                 */
                class { '::icinga::repos':
                    stage       => 'icinga-install',
                    manage_epel => false,
                    manage_crb  => false,
                }
                
                class { '::icinga2':
                    manage_repos    => false,
                }
            }
    	}
    }
    
    if (
        ( $::operatingsystem == 'centos' or $::operatingsystem == 'AlmaLinux' ) and
        $::operatingsystemmajrelease == '8'
    ) {
        #$nagiosPluginsRequire   = [ Class['vs_core::dependencies::powertools']]
        $nagiosPluginsRequire   = []
    } else {
        $nagiosPluginsRequire   = []
    }
    class{ 'vs_devops::subsystems::nagios::nagiosPlugins':
        require => $nagiosPluginsRequire,
    }
    
    include vs_devops::subsystems::icinga::icingaServerConfig
}
