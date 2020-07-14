class devops
{
    if ( $vsConfig['services']['maven'] == true )
    {
        # Install Maven
        class { "maven::maven":
            #version => "3.2.5", # version to install
            # you can get Maven tarball from a Maven repository instead than from Apache servers, optionally with a user/password
            repo => {
                #url => "http://repo.maven.apache.org/maven2",
                #username => "",
                #password => "",
            }
        }
    }
    
    if ( $vsConfig['services']['jenkins'] == true )
    {
        class { 'devops::jenkins':
            notify => Service[jenkins]
        }
	}
    
    if ( $vsConfig['services']['gitlab'] == true )
    {
	   include devops::gitlab
	}
	
	if ( $vsConfig['services']['ansible'] == true )
    {
       include devops::ansible
       
       if ( $ansibleConfig['galaxyRolesUpdate'] == true )
        {
            $ansibleConfig['galaxyRoles'].each |String $role|
            {
                exec{ "Fetch Role ${role}":
                    command => "/usr/bin/ansible-galaxy install ${role} -p ${ansibleConfig['pathRoles']} --ignore-errors",
                    require => Class['ansible'],
                    onlyif  => '/usr/bin/test -e /usr/bin/ansible-galaxy',
                }
            }
    
        }
    }
    
    if ( $vsConfig['services']['nagios'] == true )
    {
        include devops::nagiosServer
    }
    
    if ( $vsConfig['services']['icinga'] == true )
    {
        include devops::webserver
        include devops::icingaServer
        include devops::nagiosPlugins
    }
}
