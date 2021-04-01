class vs_devops::subsystems::elastic_stack (
    Hash $config    = {},
) {

    class { 'elasticsearch':
        version => '7.12.0',
    } ->
    
    class { 'logstash':
        
    } ->
    
    class { 'kibana':
        ensure => '7.12.0',
        config => {
            'server.port' => '8090',
        },
        require => Class['elastic_stack::repo'],
    }
    
    # You must provide a valid pipeline configuration for the service to start.
    /*
    logstash::configfile { 'my_ls_config':
        content => template('path/to/config.file'),
    }
    */
}
