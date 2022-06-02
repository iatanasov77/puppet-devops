############################################################
# Using this module: https://forge.puppet.com/thias/nagios
############################################################
class vs_devops::subsystems::icinga (
	Hash $config    = {},
) {
	case $::operatingsystem {
    	centos: {
    		$centosVersion	= $::operatingsystemmajrelease
    		
    		#include vs_devops::webserver
		    Exec{ 'Icinga-Rpm':
		        command => "/bin/yum -y install https://packages.icinga.com/epel/icinga-rpm-release-${centosVersion}-latest.noarch.rpm",
		        require	=> [ Package['epel-release'] ]
		    } ->
		    class { '::icinga2':
		        manage_repo     => false,
		        manage_package  => true,
		    }
    	}
    }
    
    if $::operatingsystem == 'centos' and $::operatingsystemmajrelease == '8' {
        $nagiosPluginsRequire   = [ Class['vs_core::dependencies::powertools']]
    } else {
        $nagiosPluginsRequire   = []
    }
    class{ 'vs_devops::subsystems::nagios::nagiosPlugins':
        require => $nagiosPluginsRequire,
    }
    
    include vs_devops::subsystems::icinga::icingaServerConfig
}
