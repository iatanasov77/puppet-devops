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
                    if find_file( '/usr/lib/jenkins/jenkins-cli.jar' ) {
                        $jenkinsCli = '/usr/lib/jenkins/jenkins-cli.jar'
                    } else {
                        $jenkinsCli = '/usr/share/java/jenkins-cli.jar'
                    }
                    
			        class { 'vs_devops::subsystems::jenkins':
                        jenkinsCli      => $jenkinsCli,
			        	config          => $subsys,
			        	
			        	plugins	        => $vsConfig['jenkinsPlugins'],
			        	jobs            => $vsConfig['jenkinsJobs'],
			        	credentials     => $vsConfig['jenkinsCredentials'],
			            
                        pluginsCli      => $vsConfig['jenkinsPluginsCli'],
                        jobsCli         => $vsConfig['jenkinsJobsCli'],
                        credentialsCli  => $vsConfig['jenkinsCredentialsCli'],
                        
                        libraries       => $vsConfig['jenkinsLibraries'],
			        }
			        
			        if (
                        ( 'hashicorp-vault-plugin' in $vsConfig['jenkinsPluginsCli'] ) and
                        $subsystems['hashicorp']['enabled'] and
                        ( 'vault' in $subsystems['hashicorp'] )
                    ) {
                        class { 'vs_devops::subsystems::jenkins::vaultPluginSetup':
                            jenkinsCli      => $jenkinsCli,
                            config          => {
                                'vaultPort' => $subsystems['hashicorp']['vault']['config']['port'],
                            },
                            
                            stage           => 'jenkins-credentials-cli'
                        }
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
