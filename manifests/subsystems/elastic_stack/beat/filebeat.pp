class vs_devops::subsystems::elastic_stack::beat::filebeat (
    Hash $config,
) {
    Package { 'filebeat':
        provider    => 'rpm',
        ensure      => installed,
        source      => "https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${config['version']}-x86_64.rpm",
    }
    
    File { 'filebeat_config':
        ensure  => file,
        path    => '/etc/filebeat/filebeat.yml',
        content => template( 'vs_devops/elk/beat/filebeat.yml.erb' ),
        mode    => '0755',
    }
}
