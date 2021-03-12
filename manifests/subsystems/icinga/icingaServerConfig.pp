##################################################################################
#  USED MANUALS
# --------------
# https://icinga.com/2017/06/12/how-to-monitor-your-mysql-servers-with-icinga-2/
# https://redmine.sberg.net/projects/open-sberg-wiki/wiki/Icinga2_NRPE
##################################################################################
class vs_devops::subsystems::icinga::icingaServerConfig
{
    # Commands
    $icingaConfig['commands'].each |String $index, Hash $command| {
        icinga2::object::checkcommand { "${index}":
            template    => $command['template'],
            import      => $command['import'],
            command     => if $command['command'] { $command['command'] } else { undef },
            vars        => if $command['vars'] { $command['vars'] } else { undef },
            arguments   => if $command['arguments'] { $command['arguments'] } else { undef },
            target      => '/etc/icinga2/conf.d/my-commands.conf',
        }
    }
    
    # Hosts
    $icingaConfig['hosts'].each |Integer $index, Hash $host| {
        icinga2::object::host { $host['name']:
            display_name    => $host['name'],
            address         => $host['address'],
            groups          => if $host['groups'] { $host['groups'] } else { undef },
            check_command   => 'hostalive',
            target          => "/etc/icinga2/conf.d/${host['name']}.conf",
        }
        
        # Host Services
        $host['services'].each |String $serviceName, Hash $service| {
            icinga2::object::service { "${serviceName}":
                host_name       => "${host['name']}",
                display_name    => "${service['serviceDescription']}",
                check_command   => "${service['serviceCommand']}",
                target          => "/etc/icinga2/conf.d/${serviceName}.conf",
                
                vars            => if $service['vars'] { $service['vars'] } else { undef },
            }
        }
    }

    # Hostgroups
    $icingaConfig['hostGroups'].each |String $group, String $name| {
        icinga2::object::hostgroup { "${group}":
            display_name    => "${name}",
            target          => "/etc/icinga2/conf.d/my-hostgroups.conf",
        }
    }
}
