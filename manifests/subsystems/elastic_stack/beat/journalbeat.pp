class vs_devops::subsystems::elastic_stack::beat::journalbeat (
    Hash $config,
) {
    Package { 'journalbeat':
        provider    => 'rpm',
        ensure      => installed,
        source      => "https://artifacts.elastic.co/downloads/beats/journalbeat/journalbeat-${config['version']}-x86_64.rpm",
    }
    
    File { 'journalbeat_config':
        ensure  => file,
        path    => '/etc/journalbeat/journalbeat.yml',
        content => template( 'vs_devops/elk/beat/journalbeat.yml.erb' ),
        mode    => '0755',
    }
}
