class vs_devops::nrpeClient
{
    class { 'nrpe':
      allowed_hosts     => ['127.0.0.1', '192.168.98.100'],
      dont_blame_nrpe   => true,
    }

    file_line { 'command-check-docker-container':
        line    => 'command[check-docker-container]=/vagrant/bin/check_docker_container.sh $ARG1$',
        path    => '/etc/nagios/nrpe.cfg',
        notify  => Service['nrpe'],
        require => Package['nrpe']
    }
}