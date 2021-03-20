class vs_devops::subsystems::ansible (
	Hash $config    = {},
) {
    # Install Ansible
    class { 'ansible':
        ensure  => 'present',
    }
    
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
