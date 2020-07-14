###########################################################
# This WebServer is especialy created for IcingaWeb 2
###########################################################
class devops::webserver
{
    #############################################################
    # 1. Installing MySql
    #############################################################
    
    class { 'mysql::server':
        #service_name        => 'mysqld',
        create_root_user    => true,
        root_password       => 'vagrant',
        override_options => {
            mysqld => {
                bind-address    => '*',
                log-error => '/var/log/mariadb/mariadb.log',
            },
            mysqld_safe => {
                log-error => '/var/log/mariadb/mariadb.log',
                pid-file  => '/var/run/mariadb/mariadb.pid',
            },
        },
    }
    
    class { 'mysql::server::monitor':
        mysql_monitor_username  => 'nagios',
        mysql_monitor_password  => 'nagios',
        mysql_monitor_hostname  => "${vsConfig['hostAddress']}"
    }
    
    #############################################################
    # 2. Installing PHP
    #############################################################
    
    $phpPackages    = [
        'centos-release-scl',
        'rh-php73-php-json',
        'rh-php73-php-pgsql',
        'rh-php73-php-xml',
        'rh-php73-php-intl',
        'rh-php73-php-common',
        'rh-php73-php-pdo',
        'rh-php73-php-mysqlnd',
        'rh-php73-php-cli',
        'rh-php73-php-mbstring',
        'rh-php73-php-fpm',
        'rh-php73-php-gd',
        'rh-php73-php-zip',
        'rh-php73-php-ldap',
        'rh-php73-php-imagick'
    ]
    $phpPackages.each |String $value| {
        package { $value:
            ensure => present,
        }
    }
    
    file { '/usr/bin/php':
        ensure => 'link',
        target => '/opt/rh/rh-php73/root/usr/bin/php',
    }
    
    # Start Php-Fpm service
    service { 'rh-php73-php-fpm':
        ensure => running,
        enable => true,
    }
    
    #############################################################
    # 3. Installing Apache
    #############################################################
    
    class { 'apache':
        default_vhost   => false,
        default_mods    => false,
        mpm_module      => 'prefork',
    }
    
    # Apache modules
    $apacheModules    = [
        'alias',
        'vhost_alias',
        'version',
        'dir',
        'env',
        'rewrite',
        'setenvif',
        'proxy',
        'proxy_fcgi',
        'proxy_http',
        'proxy_html',
    ]
    $apacheModules.each |Integer $index, String $value| {
        notice( "APACHE MODULE: ${value}" )
        class { "apache::mod::${value}": }
    }
    
    class { 'phpmyadmin': }
    
    # Setup default main virtual host
    apache::vhost { "devops.lh":
        port        => '80',
        docroot     => '/vagrant/public',
        override    => 'all',
        
        aliases     => [
            {
                alias => '/phpmyadmin',
                path  => '/usr/share/phpMyAdmin'
            }
        ],
        
        directories => [
            {
                'path'              => '/vagrant/web',
                'allow_override'    => ['All'],
                'Require'           => 'all granted',
            },
            {
                'path'              => '/usr/share/phpMyAdmin',
                'allow_override'    => ['All'],
                'Require'           => 'all granted',
            }
        ],
        
        custom_fragment    => "
            <FilesMatch \.php$>
                SetHandler proxy:fcgi://127.0.0.1:9000
            </FilesMatch>
        "
    }
}
