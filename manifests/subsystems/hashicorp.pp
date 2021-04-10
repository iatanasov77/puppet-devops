class vs_devops::subsystems::hashicorp (
	Hash $config       = {},
	String $vaultPort  = '8200',
) {
    if $config['packer'] {
        class { hashicorp::packer:
            version   => $config['packer'],
        }
    }
    
    if $config['terraform'] {
    	class { hashicorp::terraform:
            version   => $config['terraform'],
        }
    }
    
    if $config['vault'] {
        class { hashicorp::vault:
            version   => $config['vault'],
        } ->
        vs_devops::subsystems::hashicorp::vaultService { 'vault':
            vaultPort   => $vaultPort,
        }
    }
}
