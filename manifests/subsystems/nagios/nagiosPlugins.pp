class vs_devops::subsystems::nagios::nagiosPlugins
{
    if $::operatingsystem == 'centos' and $::operatingsystemmajrelease == '8' {
        $requiredPackages   = [ Package['perl-utf8-all'] ]
        
        yumrepo { 'powertools':
            descr       => 'Enable PowerTools repository for Enterprise Linux',
            require     => Package['dnf-plugins-core'],
            ensure      => 'present',
            enabled     => 1,
            gpgcheck    => 0,
        }
        
        if ! defined( Package['perl-utf8-all'] ) {
            package { 'perl-utf8-all':
                ensure  => 'present',
                require => Yumrepo["powertools"],
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