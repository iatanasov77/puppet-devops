class vs_devops::subsystems::ansible (
	Hash $config    = {},
) {
    case $::operatingsystem {
        'AlmaLinux': {
            if Integer( $::operatingsystemmajrelease ) == 8 {
                package { 'ansible':
                    ensure => present,
                }
            }
        }
        default: {
            if ! defined( Package["${config['python']}"] ) {
                # Install Python
                package { "${config['python']}":
                    ensure => present,
                }
            }
            
            # Update Python PIP
            exec{ "Update Python PIP":
                command => "/usr/bin/python3 -m pip install --upgrade pip",
                require => Package["${config['python']}"],
            }
            
            # Install Ansible
            exec{ "Install Ansible":
                command => "/usr/bin/python3 -m pip install ansible",
                require => Exec['Update Python PIP'],
            }
        }
    }
}
