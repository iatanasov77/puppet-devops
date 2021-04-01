class vs_devops::subsystems::elastic_stack (
    Hash $config    = {},
) {

    stage { 'elastic_stack_late_install': }
    Stage['main'] -> Stage['elastic_stack_late_install']
    class { 'elasticsearch':
        version => '7.12.0',
    }
    
    class { 'logstash':
        stage   => 'elastic_stack_late_install',
    }
    
    class { 'kibana':
        #stage   => 'elastic_stack_late_install',
        config => {
            'server.port' => '8090',
        },
    }
    
    # You must provide a valid pipeline configuration for the service to start.
    /*
    logstash::configfile { 'my_ls_config':
        content => template('path/to/config.file'),
    }
    */
}
