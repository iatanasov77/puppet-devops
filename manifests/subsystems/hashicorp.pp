class vs_devops::subsystems::hashicorp (
	Hash $config       = {},
) {
    include hashi_stack::repo
    
    if $config['packer'] {
        class { vs_devops::subsystems::hashicorp::packer:
            version => $config['packer']['version'],
        }
        
        ######################################################################
        # Install Vagrant Binary
        ######################################################################
        class { vs_devops::vagrant:
            data    => $config['packer']['vagrant'],
            stage   => 'packer-setup',
        }
    }
    
    if $config['terraform'] {
    	class { vs_devops::subsystems::hashicorp::terraform:
            version => $config['terraform']['version'],
            config  => $config['terraform']['config'],
        }
    }
    
    if $config['vault'] {
        class { vs_devops::subsystems::hashicorp::vault:
            version => $config['vault']['version'],
            config  => $config['vault']['config'],
        }
        
        ####################################################################
        # Setup Credentials
        # ------------------
        # https://learn.hashicorp.com/tutorials/vault/static-secrets
        ####################################################################
        class { '::vs_devops::subsystems::hashicorp::vaultSetup':
            port    => "${config['vault']['config']['port']}",
            secrets => "${config['vault']['config']['secrets']}",
            stage   => 'vault-setup',
        }
    }
}
