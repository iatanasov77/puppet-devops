class vs_devops::ansible
{
    # Install Ansible
    class { 'ansible':
        ensure  => 'present',
    }
}
