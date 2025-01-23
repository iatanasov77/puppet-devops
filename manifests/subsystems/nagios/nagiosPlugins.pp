class vs_devops::subsystems::nagios::nagiosPlugins
{
    if (
        ( $::operatingsystem == 'centos' or $::operatingsystem == 'AlmaLinux' ) and
        $::operatingsystemmajrelease == '8'
    ) {
    
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
    
    if ! defined(Package['nagios-plugins-all']) {
        Package { 'nagios-plugins-all':
            ensure  => installed,
            require => $requiredPackages,
        }
    }
    
    if ! defined(Package['nagios-plugins-nrpe']) {
        Package { 'nagios-plugins-nrpe':
            ensure  => installed,
            require => $requiredPackages,
        }
    }
    
    file { '/usr/bin/check_nrpe':
        ensure => 'link',
        target => '/usr/lib64/nagios/plugins/check_nrpe',
    }
}