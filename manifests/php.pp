
class devops::php
{
    # PHP Modules
    $modules = {}
    $vsConfig['phpModules'].each |Integer $index, String $value| {
        $modules = merge( $modules, {
            "${value}"  => {}
        })
    }

    class { '::php':
        ensure       => latest,
        manage_repos => true,
        fpm          => true,
        dev          => true,
        composer     => true,
        pear         => true,
        phpunit      => true,
        
        #package_prefix => 'php72-php-',
        
        settings   => {
            'PHP/memory_limit'        => '-1',
            'Date/date.timezone'      => 'Europe/Sofia',
        },
        extensions => $modules
    }
    
    ########################################
    # Php Build Tool PHING
    ########################################
    exec { "pearUpgrade":
        command => "/usr/bin/pear upgrade-all",
        require => Package["php-pear"]
    }
    exec { "phing":
        command => "/usr/bin/pear channel-discover pear.phing.info; /usr/bin/pear install phing/phing; /usr/bin/pear install HTTP_Request2",
        unless => "/usr/bin/pear info phing/phing",
        require => Exec["pearUpgrade"]
    }
}
