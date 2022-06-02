class vs_devops::subsystems::hashicorp (
	Hash $config       = {},
) {
    include hashi_stack::repo
    
    if $config['packer'] {
        class { vs_devops::subsystems::hashicorp::packer:
            version   => $config['packer'],
        }
    }
    
    if $config['terraform'] {
    	class { vs_devops::subsystems::hashicorp::terraform:
            version   => $config['terraform'],
        }
    }
    
    if $config['vault'] {
        class { vs_devops::subsystems::hashicorp::vault:
            version     => $config['vault'],
            vaultPort   => "${config['vaultPort']}",
        }
    }
}
