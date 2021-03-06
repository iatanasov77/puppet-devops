############################################################
# Using this module: https://forge.puppet.com/thias/nagios
############################################################
class vs_devops::subsystems::nagios (
	Hash $config    = {},
) {
	#########################################################################
	#	$nagiosConfig is defined in default manifest as global variable
	#########################################################################
	
    include vs_devops::subsystems::nagios::nagiosServerConfig
    
    class { '::nagios::server':
        apache_httpd_ssl                                => false,
        apache_httpd									=> $config['apache_httpd'],
        php												=> $config['apache_httpd'],
        
        cgi_authorized_for_system_information           => '*',
        cgi_authorized_for_configuration_information    => '*',
        cgi_authorized_for_system_commands              => '*',
        cgi_authorized_for_all_services                 => '*',
        cgi_authorized_for_all_hosts                    => '*',
        cgi_authorized_for_all_service_commands         => '*',
        cgi_authorized_for_all_host_commands            => '*',
        cgi_default_statusmap_layout                    => '3',
        
        cfg_dir                                         => [
            '/etc/nagios/objects/my_objects',
        ],
        
        # I kak se advat nikoi ne znae :(
        hosts       => {},
        services    => {},
    }
    
    package { [
        'perl-DBI',
        'perl-DBD-MySQL',
        'perl-GD',
        'nagios-plugins*',
    ]:
        ensure => installed,
        notify  => Service['nagios'],
        require => Package['nagios'],
    }
  
  	archive { '/tmp/vautour_style.zip':
		ensure        	=> present,
		source        	=> "${nagiosConfig['theme']['src']}",
		extract       	=> true,
		extract_path  	=> '/usr/share/nagios/html',
		cleanup       	=> true,
		require 		=> Package['nagios'],
	}
	
	if ! $config['apache_httpd'] {
		class { 'vs_devops::subsystems::nagios::nagiosHttpd':
			require	=> [Class['vs_lamp::apache'], Package['nagios']]
		}
	}
}
