class vs_devops::subsystems::rabbit_mq (
    Hash $config       = {},
) {
    class { 'rabbitmq':
        service_manage    => false,
        port              => $config['port'],
        delete_guest_user => true,
    }
}