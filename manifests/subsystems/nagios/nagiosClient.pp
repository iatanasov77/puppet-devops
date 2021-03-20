class vs_devops::subsystems::nagios::nagiosClient
{
    class { '::nagios::client':
        nrpe_allowed_hosts      => '127.0.0.1,192.168.99.100',
        nrpe_dont_blame_nrpe    => '1',
    }
    
    file_line { 'command-check-docker-container':
        line    => 'command[check-docker-container]=/vagrant/bin/check_docker_container.sh $ARG1$',
        path    => '/etc/nagios/nrpe.cfg',
        notify  => Service['nrpe'],
        require => Package['nrpe']
    }
}