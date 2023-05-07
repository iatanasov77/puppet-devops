class vs_devops::subsystems::elastic_stack (
    Hash $config    = {},
) {
    class { 'elasticsearch':
        version     => $config['version'],
        
        api_host    => 'localhost',
        api_port    => $config['elasticsearch_port'],
        config      => {
            'cluster'   => {
                'name'                  => 'VsElkCluster',
                'initial_master_nodes'  => ["${config['host_name']}"]
            }
        }
    }
    
    class { 'kibana':
        ensure => "${config['version']}",
        
        config => {
            'server.port' => $config['kibana_port'],
            'server.host' => $config['kibana_host'],
            'server.name' => $config['host_name'],
            
            'elasticsearch.hosts'           => ["http://localhost:${config['elasticsearch_port']}"],
            'elasticsearch.requestTimeout'  => '180000',
        },
    }
    
    if 'logstash_port' in $config {
        class { 'vs_devops::subsystems::elastic_stack::logstash':
            config  => $config,
            stage   => 'elastic_stack_late_install',
        }
    }
    
    class { 'vs_devops::subsystems::elastic_stack::beat::metricbeat':
        config  => $config,
        stage   => 'elastic_stack_late_install',
    }
}
