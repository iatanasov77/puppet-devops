class vs_devops::subsystems::jenkins::jenkinsInstall (
    Hash $config        = {},
    Hash $plugins       = {},
    Hash $jobs          = {},
    Hash $credentials   = {},
) {
    class { 'jenkins':
        version         => "${config['version']}",
        install_java    => false,
        cli_username    => "${config['jenkinsAdmin']['username']}",
        cli_password    => "${config['jenkinsAdmin']['password']}",
    }
    
    class { 'jenkins::master':
        version => "${config['swarmVersion']}",
    }
    
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
                path => '/vagrant/tmp/jenkins_plugin_fails',
                line => $plugin,
            }
            'FAILED!!!'
        }
        notice( $ret )
    }

    $jobs.each |String $job, Hash $jobConfig|
    {
        jenkins::job { "${jobConfig['name']}":
            config  => template("vs_devops/jenkins/jobs/${jobConfig['type']}.xml.erb"),
        }
    }
    
    $credentials.each |String $id, Hash $params|
    {
        jenkins::credentials { "${id}":
            password    => $params['password'],
        }
    }
}
