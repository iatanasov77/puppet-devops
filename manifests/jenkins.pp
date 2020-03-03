class devops::jenkins
{
    class{ 'jenkins':
        config_hash => {
            'JENKINS_PORT'  => { 'value' => "${vsConfig['services']['jenkinsPort']}" },
        }
    }
    
    $vsConfig['services']['jenkinsPlugins'].each |String $plugin, Hash $attributes|
    {
    	if $plugin == 'credentials-binding' {
    		jenkins::plugin { $plugin:
        		version => sprintf( "%.2f", $attributes['version'] ),
        	}
    	} else {
    		jenkins::plugin { $plugin:
        		version => $attributes['version'],
        	}
        }
    }
}
