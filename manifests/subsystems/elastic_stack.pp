class vs_devops::subsystems::elastic_stack (
    Hash $config    = {},
) {
    stage { 'elastic_stack_late_install': }
    Stage['main'] -> Stage['elastic_stack_late_install']
    
    class { 'elasticsearch':
        version     => '7.12.0',
        
        api_host    => 'localhost',
        api_port    => 9200,
        config      => {
            'cluster'   => {
                'name'                  => 'VsElkCluster',
                'initial_master_nodes'  => ["devops.lh"]
            }
        }
    }
    
    class { 'kibana':
        config => {
            'server.port' => '5601',
            'server.host' => '10.3.3.3',
            'server.name' => 'devops.lh',
            
            'elasticsearch.hosts'           => ["http://localhost:9200"],
            'elasticsearch.requestTimeout'  => '180000',
        },
    }
    
    class { 'logstash':
        stage   => 'elastic_stack_late_install',
    }
    
    # You must provide a valid pipeline configuration for the service to start.
    logstash::configfile { 'logstash_config':
        content => template( "${module_name}/elk/logstash/logstash.conf.erb" ),
        stage   => 'elastic_stack_late_install',
        require => Class['logstash'],
    }
}
