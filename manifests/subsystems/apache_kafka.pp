class vs_devops::subsystems::apache_kafka (
    Hash $config       = {},
) {

    # We first install the binary package with:
    class { 'kafka':
        version         => '1.1.0',
        scala_version   => '2.12'
    }
    
    # Then we set a minimal Kafka broker configuration with:
    class { 'kafka::broker':
        config => {
            'broker.id'         => '0',
            'zookeeper.connect' => 'localhost:2181'
        }
    }
}