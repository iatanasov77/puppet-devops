class vs_devops::subsystems (
    Hash $subsystems    = {},
) {
	$subsystems.each |String $subsysKey, Hash $subsys| {
     
        case $subsysKey
        {
            'jenkins':
            {
            	if ( $subsys['enabled'] ) {
            		stage { 'jenkins-plugins-cli': }
            		stage { 'jenkins-jobs': }
			    	stage { 'notify-services': }
					Stage['main'] -> Stage['jenkins-plugins-cli'] -> Stage['jenkins-jobs'] -> Stage['notify-services']
			
			    	stage { 'jenkins-install': before => Stage['main'] }
			        class { 'vs_devops::subsystems::jenkins':
			        	config	=> $subsys,
			        	plugins	=> $vsConfig['jenkinsPlugins'],
			            stage	=> 'jenkins-install',
			        }
			        
			        class { 'vs_devops::subsystems::jenkins::jenkinsCli':
                        plugins     => $subsys['jenkinsPluginsCli'],
                        credentials => $subsys['jenkinsCredentialsCli'],
                        stage       => 'jenkins-plugins-cli',
			        }
			        
			        class { 'vs_devops::subsystems::jenkins::jenkinsJobs':
                        jobs    => $subsys['jobs'],
                        stage   => 'jenkins-jobs',
                    }
			        
			        class { 'vs_devops::notifyServices':
			            stage	=> 'notify-services',
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
