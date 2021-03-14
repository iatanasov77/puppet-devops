class vs_devops::subsystems::docker (
	Hash $config    = {},
) {
	class { 'docker':
        ensure          => 'present',
        version         => 'latest',
        docker_users    => $config['docker_users'],
    }
}
