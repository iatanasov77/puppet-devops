############################################################
# Using this module: https://forge.puppet.com/thias/nagios
############################################################
class vs_devops::icingaServer
{
    Exec{ 'Icinga-Require-Epel':
        command => '/bin/yum -y install epel-release',
    } ->
    #Exec{ 'Icinga-Require-Optional-Rpms':
    #    command => 'subscription-manager repos --enable rhel-7-server-optional-rpms',
    #} ->
    Exec{ 'Icinga-Rpm':
        command => '/bin/yum -y install https://packages.icinga.com/epel/icinga-rpm-release-7-latest.noarch.rpm',
    } ->
    class { '::icinga2':
        manage_repo     => false,
        manage_package  => true,
    }
    include vs_devops::icingaServerConfig
    
    # Icinga Web Interface
    ##############################
    mysql::db { 'icingaweb2':
        user     => 'icinga',
        password => 'icinga',
        host     => 'localhost',
        grant    => [ 'ALL' ],
    } ->
    
    class{ '::icinga2::feature::idomysql':
        user            => "icinga",
        password        => "icinga",
        database        => "icingaweb2",
        import_schema   => true,
        require         => Mysql::Db['icingaweb2'],
    } ->

    class {'icingaweb2':
        #theme           => 'nordlicht/nordlicht',
        theme           => 'company/default',
        manage_repo     => false,
        import_schema   => true,
        db_type         => 'mysql',
        db_host         => 'localhost',
        db_port         => 3306,
        db_username     => 'icinga',
        db_password     => 'icinga',
        config_backend  => 'db',
        #extra_packages  => [ 'git' ],
        require         => Mysql::Db['icingaweb2'],
        notify          => Service['httpd'],
    } ->
    class {'icingaweb2::module::monitoring':
        ido_type        => 'mysql',
        ido_host        => 'localhost',
        ido_db_name     => 'icingaweb2',
        ido_db_username => 'icinga',
        ido_db_password => 'icinga',
        commandtransports => {
            icinga2 => {
                transport => 'api',
                username  => 'icinga',
                password  => 'icinga',
            }
        }
    } ->
    exec { 'Add apche to the group icingaweb2':
        command => '/sbin/usermod -aG icingaweb2 apache',
        require => User['apache'],
        notify  => Service['rh-php73-php-fpm'],
    }
    
    #########################################
    # Install Themes
    #########################################
    icingaweb2::module { 'nordlicht':
        git_repository  => 'https://github.com/sysadmama/icingaweb2-theme-nordlicht.git',
    }
    icingaweb2::module { 'company':
        git_repository  => 'https://github.com/Icinga/icingaweb2-theme-company.git',
    }
    
}
