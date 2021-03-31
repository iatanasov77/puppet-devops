class vs_devops::subsystems::elastic_stack (
    Hash $config    = {},
) {

    class { 'elasticsearch':
        version => '7.9.3'
    }
    
    class { 'logstash':
        version => '6.0.0',
    }
    
    # You must provide a valid pipeline configuration for the service to start.
    /*
    logstash::configfile { 'my_ls_config':
        content => template('path/to/config.file'),
    }
    */
    
    class { 'kibana':
        config => {
            'server.port' => '8090',
        }
    }
}
