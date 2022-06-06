class vs_devops::subsystems::kubernetes (
	Hash $config    = {},
) {
	# REFERENCE: https://github.com/puppetlabs/puppetlabs-kubernetes
	class { 'kubernetes':
        manage_kernel_modules   => false,
        manage_docker           => false,
        controller              => false,
        
        api_server_count        => 1,
        token                   => 'abc123.qwertyui12345678',
        discovery_token_hash    => 'NOT_DEFINED',
    }
}
