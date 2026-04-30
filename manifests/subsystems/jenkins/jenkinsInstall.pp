class vs_devops::subsystems::jenkins::jenkinsInstall (
    String $hostAddress,
    Hash $config        = {},
    Hash $plugins       = {},
    Hash $jobs          = {},
    Hash $credentials   = {},
    $jenkinsCli,
) {
    /*
    $jenkinsHost = "127.0.0.1"
    $jenkinsHost = "localhost"
    $jenkinsHost = "${hostAddress}"
    $jenkinsHost = "${facts['hostname']}"
    */
    $jenkinsHost = "${facts['hostname']}"
    
    Exec { 'Jenkins Import GPG Key':
        command => "rpm --import ${config['gpgKey']}",
    } ->
    
    /*
    wget::fetch { "Jenkins Repo":
        source      => "${config['repo']}",
        destination => '/etc/yum.repos.d/jenkins.repo',
        verbose     => true,
        mode        => '0666',
        cache_dir   => '/var/cache/wget',
    } ->
    */
    
    class { 'jenkins':
        version         => "${config['version']}",
        #repo            => false,
        install_java    => false,
        cli_username    => "${config['jenkinsAdmin']['username']}",
        cli_password    => "${config['jenkinsAdmin']['password']}",
        
        #proxy_host      => 'devops-jenkins.lh',
        #proxy_port      => 8080,
    }
    
    file { '/var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml':
        ensure  => present,
        owner   => 'jenkins',
        group   => 'jenkins',
        mode    => '0644',
        content => template( 'vs_devops/jenkins/JenkinsLocationConfiguration.xml.erb' ),
        #require => Class['jenkins'],
        notify  => Service['jenkins'],
    }
    
    $swarmVersion   = sprintf( "%.2f", $config['swarmVersion'] )
    class { 'jenkins::master':
        version => $swarmVersion,
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
