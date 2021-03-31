class vs_devops::subsystems::kubernetes (
	Hash $config    = {},
) {
	# REFERENCE: https://github.com/puppetlabs/puppetlabs-kubernetes
	class { 'kubernetes':
        controller => true,
    }
}
