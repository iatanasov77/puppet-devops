class vs_devops::subsystems (
    Hash $subsystems    = {},
) {
	$subsystems.each |String $subsysKey, Hash $subsys| {
     
        case $subsysKey
        {
            'icinga':
            {
                if ( $subsys['enabled'] ) {
                    class { 'vs_devops::subsystems::icinga':
                        config    => $subsys,
                    }
                    
                    # Icinga Web Interface
                    ##############################
                    class{ 'vs_devops::subsystems::icinga::icingaWebInterface':
                        require => [Class['vs_devops::lamp'], Class['vs_devops::subsystems::icinga']],
                    }
                }
            }
            
            'jenkins':
            {
            	if ( $subsys['enabled'] ) {
			        class { 'vs_devops::subsystems::jenkins':
			        	config          => $subsys,
			        	
			        	plugins	        => $vsConfig['jenkinsPlugins'],
			        	jobs            => $vsConfig['jenkinsJobs'],
			        	credentials     => $vsConfig['jenkinsCredentials'],
			            
                        pluginsCli      => $vsConfig['jenkinsPluginsCli'],
                        jobsCli         => $vsConfig['jenkinsJobsCli'],
                        credentialsCli  => $vsConfig['jenkinsCredentialsCli'],
                        
                        libraries       => $vsConfig['jenkinsLibraries'],
			        }
                }
            }
            
            default:
            {
                if ( $subsys['enabled'] ) {
                    class { "::vs_devops::subsystems::${$subsysKey}":
                    	config	=> $subsys,
                    }
                }
      
            }
        }
    }
}
