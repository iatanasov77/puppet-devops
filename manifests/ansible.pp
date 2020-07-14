class devops::ansible
{
    # Install Ansible
    class { 'ansible':
        ensure  => 'present',
    }
}
