class vs_devops::subsystems::nagios::nagiosPlugins
{
    if $::operatingsystem == 'centos' and $::operatingsystemmajrelease == '8' {
    
        #####################################################################
        # Workaroaund: Force enabling required repositories for CentOs 8
        #####################################################################
        Exec { "Force Enabling YumRepo epel-testing":
            command => 'dnf config-manager --set-enabled epel-testing',
        }
        $requiredPackages   = [ Package['perl-utf8-all'] ]
        
        if ! defined( Package['perl-utf8-all'] ) {
            package { 'perl-utf8-all':
                ensure  => 'present',
            }
        }
    } else {
        $requiredPackages   = []
    }
    
    package {[
        'nagios-plugins-all',
        'nagios-plugins-nrpe',
    ]:
        ensure  => installed,
        require => $requiredPackages,
        
        #require => Class['icinga2'],
        #notify  => Service['icinga2'],
    }
    
    file { '/usr/bin/check_nrpe':
        ensure => 'link',
        target => '/usr/lib64/nagios/plugins/check_nrpe',
    }
}