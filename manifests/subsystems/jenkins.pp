class vs_devops::subsystems::jenkins (
	Hash $config    = {},
	Hash $plugins	= {},
) {
    $jenkinsPluginDir   = '/var/lib/jenkins/plugins'
    $jenkinsPluginUrl   = 'http://updates.jenkins-ci.org'
    
    class { 'jenkins':
        install_java      => true,
#        cli_username      => 'admin',
#        cli_password      => 'admin',
        
#         user_hash => {
#            'admin' => {
#                'password'  => 'admin',
#                'email'     => 'i.atanasov77@gmail.com',
#            }
#        }
    }
    
    class { 'jenkins::master':
       	
    }
	
#    class { 'jenkins::security':
#        security_model  => 'full_control',
#    }

    $plugins.each |String $plugin, Hash $attributes|
    {
        if ( $plugin == 'credentials-binding' ) {
            $version = sprintf( "%.2f", $attributes['version'] )
        } else {
            $version    = $attributes['version']
        }
        
        $ret = try() || {
            notice( "Installing ${attributes['description']} ..." )
            jenkins::plugin { $plugin:
                version => $version,
                #require => Class['jenkins']
            }
            'SUCCESS!!!'
        
        # Only catch certain exceptions:    }.catch('ArgumentError', 'RuntimeError') |$exception| {
        }.catch |$exception| {
            file_line { 'jenkins_plugin_failed':
                path => '/vagrant/var/log/jenkins_plugin_fails',
                line => $plugin,
            }
            'FAILED!!!'
        }
        notice( $ret )
    }
}
