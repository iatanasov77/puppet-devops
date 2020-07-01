class devops::jenkins
{
    $jenkinsPluginDir   = '/var/lib/jenkins/plugins'
    $jenkinsPluginUrl   = 'http://updates.jenkins-ci.org'
    
    class { 'jenkins':
        install_java      => true,
        cli_remoting_free => true,
        cli_username      => $cli_username,
        cli_password      => $cli_password,
        
        /*
        user_hash => {
            'admin' => {
                'password'  => 'admin',
                'email'     => 'admin@devops.lh',
            }
        },
        */
    }

    class { 'jenkins::security':
        security_model  => 'full_control',
    }

    $vsConfig['services']['jenkinsPlugins'].each |String $plugin, Hash $attributes|
    {
        if ( $plugin == 'credentials-binding' ) {
            $version = sprintf( "%.2f", $attributes['version'] )
        } else {
            $version    = $attributes['version']
        }


        if ( $vsConfig['services']['jenkinsWorkaround'] == true )
        {
            ##############################################
            # WORKAROUND
            ##############################################   
            wget::fetch { "${jenkinsPluginUrl}/download/plugins/${plugin}/${version}/${plugin}.hpi":
                destination => "${jenkinsPluginDir}/",
                timeout     => 0,
                verbose     => true,
            }
        } else {
            $ret = try() || {
                notice( "Installing ${attributes['description']} ..." )
                jenkins::plugin { $plugin:
                    version => $version,
                    require => Class['jenkins']
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
    
    if ( $vsConfig['services']['jenkinsWorkaround'] == true )
    {
        $jenkinsPlugins  = parseyaml( $facts['jenkins_plugin_deps'] )
        $jenkinsPlugins['dependencies'].each |String $plugin, Hash $attributes|
        {
            wget::fetch { "${jenkinsPluginUrl}/download/plugins/${plugin}/${attributes['version']}/${plugin}.hpi":
                destination => "${jenkinsPluginDir}/",
                timeout     => 0,
                verbose     => true,
            }
        }
    }
}
