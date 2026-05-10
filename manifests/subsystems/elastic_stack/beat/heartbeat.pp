class vs_devops::subsystems::elastic_stack::beat::heartbeat (
    Hash $config,
) {
    Package { 'heartbeat':
        provider    => 'rpm',
        ensure      => installed,
        source      => "https://artifacts.elastic.co/downloads/beats/heartbeat/heartbeat-${config['version']}-x86_64.rpm",
    }
    
    File { 'heartbeat_config':
        ensure  => file,
        path    => '/etc/heartbeat/heartbeat.yml',
        content => template( 'vs_devops/elk/beat/heartbeat.yml.erb' ),
        mode    => '0755',
    }
}
