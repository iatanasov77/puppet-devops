class vs_devops::subsystems::terraform (
	Hash $config    = {},
) {
	class { hashicorp::terraform:
        version   => $config['version'],
    }
}
