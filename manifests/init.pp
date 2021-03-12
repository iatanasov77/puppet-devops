class vs_devops
{
	include vs_devops::dependencies::repos
	include vs_devops::packages
	
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
    	stage { 'jenkins-plugins-cli': }
    	stage { 'notify-services': }
		Stage['main'] -> Stage['jenkins-plugins-cli'] -> Stage['notify-services']

    	stage { 'jenkins-install': before => Stage['main'] }
        class { 'vs_devops::jenkins':
            stage	=> 'jenkins-install',
        }
        
        class { 'vs_devops::jenkinsCli':
            stage	=> 'jenkins-plugins-cli',
        }
        
        class { 'vs_devops::notifyServices':
            stage	=> 'notify-services',
        }
	}
    
    if ( $vsConfig['services']['gitlab'] == true )
    {
	   include vs_devops::gitlab
	}
	
	if ( $vsConfig['services']['ansible'] == true )
    {
       include vs_devops::ansible
       
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
        include vs_devops::nagiosServer
    }
    
    if ( $vsConfig['services']['icinga'] == true )
    {
        include vs_devops::webserver
        include vs_devops::icingaServer
        include vs_devops::nagiosPlugins
    }
}
