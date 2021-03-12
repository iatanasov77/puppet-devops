class vs_devops::subsystems::nagios::nagiosPlugins
{   
    package {[
        'nagios-plugins-all',
        'nagios-plugins-nrpe',
    ]:
        ensure => installed,
        #notify  => Service['icinga2'],
        #require => Class['icinga2'],
    }
    
    file { '/usr/bin/check_nrpe':
        ensure => 'link',
        target => '/usr/lib64/nagios/plugins/check_nrpe',
    }
}