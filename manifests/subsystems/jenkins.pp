class vs_devops::subsystems::jenkins (
	Hash $config    = {},
	Hash $plugins	= {},
) {
    $jenkinsPluginDir   = '/var/lib/jenkins/plugins'
    $jenkinsPluginUrl   = 'http://updates.jenkins-ci.org'
    
    class { 'jenkins':
        install_java      => true,
        cli_username      => "${config['jenkinsAdmin']['username']}",
        cli_password      => "${config['jenkinsAdmin']['password']}",
        
#         user_hash => {
#            'admin' => {
#                'password'  => 'admin',
#                'email'     => 'email@example.com',
#            }
#        }
    }
    
    
#    jenkins::user { 'admin':
#        email    => 'jdoe@example.com',
#        password => 'admin',
#    }

    class { 'jenkins::master':
       	version => "${config['swarmVersion']}",
    }
	
	$config['jobs'].each |String $job, Hash $jobConfig|
    {
        jenkins::job { "${jobConfig['name']}":
            config  => template("vs_devops/jenkins/jobs/${jobConfig['type']}.xml.erb"),
        }
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
                path => '/vagrant/var/log/jenkins_plugin_fails',
                line => $plugin,
            }
            'FAILED!!!'
        }
        notice( $ret )
    }
}
