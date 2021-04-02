class vs_devops::subsystems::elastic_stack::logstash (
    Hash $config,
) {
    # Config template vars
    $beatsPort  = $config['logstash_port']
    $elkPort    = $config['elasticsearch_port']
    
    class { 'logstash':
        
    }
    
    # You must provide a valid pipeline configuration for the service to start.
    logstash::configfile { 'logstash_config':
        content => template( "${module_name}/elk/logstash/logstash.conf.erb" ),
    }
}
