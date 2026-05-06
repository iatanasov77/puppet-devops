class vs_devops::subsystems::elastic_stack (
    Hash $config    = {},
) {
    class { 'vs_core::elasticsearch':
        version     => $config['version'],
        yumRepo     => $config['yumRepo'],
        
        apiProtocol => "${config['scheme']}",
        apiHost     => "${config['elasticsearch_host']}",
        apiPort     => $config['elasticsearch_port'],
        apiUsername => "${config['user']}",
        apiPassword => "${config['pass']}",
        
        apiConfig   => {
            'cluster'   => {
                'name'                  => "${config['elasticsearch_cluster']}",
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
            
            'elasticsearch.hosts'           => ["${config['scheme']}://${config['elasticsearch_host']}:${config['elasticsearch_port']}"],
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
