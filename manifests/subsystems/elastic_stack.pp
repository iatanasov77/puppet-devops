class vs_devops::subsystems::elastic_stack (
    Hash $config    = {},
) {

    class { 'elasticsearch':
        version => '7.12.0'
    }
    
    class { 'logstash':
        #version => '7.12.0',
        ensure  => '7.12.0',
    }
    
    # You must provide a valid pipeline configuration for the service to start.
    /*
    logstash::configfile { 'my_ls_config':
        content => template('path/to/config.file'),
    }
    */
    
    class { 'kibana':
        ensure => '7.12.0',
        config => {
            'server.port' => '8090',
        }
    }
}
