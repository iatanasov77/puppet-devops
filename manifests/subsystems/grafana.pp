class vs_devops::subsystems::grafana (
    Hash $config       = {},
) {
    class { 'grafana':
        install_method  => 'package',
    }
}
