class vs_devops::subsystems::ansible (
	Hash $config    = {},
) {
    # Install Ansible
    class { 'ansible':
        ensure  => 'present',
    }
    
    /*
    if ( $ansibleConfig['rolesUpdate'] == true )
    {
        $ansibleConfig['galaxyRoles'].each |String $role|
        {
            exec{ "Fetch Role ${role}":
                command => "/usr/bin/ansible-galaxy install ${role} -p ${ansibleConfig['pathRoles']} --ignore-errors",
                require => Class['ansible'],
                onlyif  => '/usr/bin/test -e /usr/bin/ansible-galaxy',
            }
        }
        
        $ansibleConfig['ansibleRoles'].each |String $role, String $url|
        {
            $file_path      = "${ansibleConfig['pathRoles']}/${role}"
            $file_exists    = find_file( $file_path )
            if ( $file_exists ) {
                exec{ "Fetch Role ${role}":
                    command => "/usr/bin/git pull",
                    cwd     => "${ansibleConfig['pathRoles']}/${role}",
                    user    => 'vagrant',
                }
            } else {
                exec{ "Fetch Role ${role}":
                    command => "/usr/bin/git clone ${url} ${ansibleConfig['pathRoles']}/${role}",
                    user    => 'vagrant',
                }
            }
        }
    }
    */
}
