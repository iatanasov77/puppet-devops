class vs_devops::subsystems::docker (
	Hash $config    = {},
) {
    class { 'vs_core::docker':
        config  => $config,
    }
}
