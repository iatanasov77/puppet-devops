class vs_devops::nagiosServerConfig
{    
    file { [ '/etc/nagios/conf.d', '/etc/nagios/objects/my_objects' ]:
        ensure => 'directory',
        require => Package['nagios'],
    }
    
    $templates = $nagiosConfig['serviceTemplates']
    file { [ "/etc/nagios/objects/my_objects/service-templates.cfg" ]:
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('vs_devops/service-template.cfg.erb'),
        require => Package['nagios'],
    }
    
    $commands = $nagiosConfig['commands']
    file { [ "/etc/nagios/objects/my_objects/commands.cfg" ]:
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('vs_devops/commands.cfg.erb'),
        require => Package['nagios'],
    }
    
    # HostGroups config
    $hostGroups = $nagiosConfig['hostGroups']
    file { [ "/etc/nagios/objects/my_objects/hostgroups.cfg" ]:
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('vs_devops/hostgroups.cfg.erb'),
        require => Package['nagios'],
    }
    
    $nagiosConfig['hosts'].each | Hash $host | {
        $hostName       = $host[name]
        $hostAddress    = $host[address]
        $services       = $host[services]
        file { [ "/etc/nagios/objects/my_objects/host-${hostName}.cfg" ]:
            owner   => 'root',
            group   => 'root',
            mode    => '0644',
            content => template('vs_devops/host.cfg.erb'),
            require => Package['nagios'],
        }
    }
}
