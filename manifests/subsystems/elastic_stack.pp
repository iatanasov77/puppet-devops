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
            'cluster.name'                  => 'VsElkCluster',
            'node.name'                     => "${config['host_name']}",
            'network.host'                  => ["localhost", "${facts['host_ip']}"],
            'cluster.initial_master_nodes'  => ["${config['host_name']}"],
            
            'http.port'                     => 9200,
            'http.cors.allow-origin'        => "http://localhost:1358",
            'http.cors.enabled'             => true,
            'http.cors.allow-headers'       => 'X-Requested-With,X-Auth-Token,Content-Type,Content-Length,Authorization',
            'http.cors.allow-credentials'   => true,
        },
        
        indexes                             => $config['indexes'],
        guis                                => $config['guis'],
    }
    
    if 'logstash_port' in $config {
        class { 'vs_devops::subsystems::elastic_stack::logstash':
            config  => $config,
            stage   => 'elastic_stack_late_install',
        }
    }
    
    $config['beats'].each |String $beatKey, Hash $beatConfig| {
        class { "::vs_devops::subsystems::elastic_stack::beat::${$beatKey}":
            config  => $config,
        }
    }
}
