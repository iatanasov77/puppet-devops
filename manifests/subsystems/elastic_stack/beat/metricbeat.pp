class vs_devops::subsystems::elastic_stack::beat::metricbeat (
    Hash $config,
) {
    Package { 'metricbeat':
        provider    => 'rpm',
        ensure      => installed,
        source      => "https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-${config['version']}-x86_64.rpm",
    }
    
    File { 'metricbeat_config':
        ensure  => file,
        path    => '/etc/metricbeat/metricbeat.yml',
        content => template( 'vs_devops/elk/beat/metricbeat.yml.erb' ),
        mode    => '0755',
    }
}
