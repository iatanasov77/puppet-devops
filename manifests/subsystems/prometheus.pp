class vs_devops::subsystems::prometheus (
    Hash $config       = {},
) {
    class { 'prometheus::server':
        version        => "${config['version']}",
        alerts         => {
            'groups' => [
                {
                    'name'  => 'alert.rules',
                    'rules' => [
                        {
                            'alert'       => 'InstanceDown',
                            'expr'        => 'up == 0',
                            'for'         => '5m',
                            'labels'      => {
                                'severity' => 'page',
                            },
                            'annotations' => {
                                'summary'     => 'Instance {{ $labels.instance }} down',
                                'description' => '{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes.'
                            }
                        },
                    ],
                },
            ],
        },
        scrape_configs => [
        /*
            {
                'job_name'        => 'prometheus-localhost',
                'scrape_interval' => '10s',
                'scrape_timeout'  => '10s',
                'static_configs'  => [
                    {
                        'targets' => [ 'localhost:9090' ],
                        'labels'  => {
                            'alias' => 'Prometheus',
                        }
                    }
                ],
            },
        */
        ],
        
        alertmanagers_config     => [
            {
                'static_configs' => [{'targets' => ['localhost:9093']}],
            },
        ],
    }
    
    if ( $config['alertmanager']['enabled'] ) {
        class { 'prometheus::alertmanager':
            version   => "${config['alertmanager']['version']}",
            route     => {
                'group_by'        => ['alertname', 'cluster', 'service'],
                'group_wait'      => '30s',
                'group_interval'  => '5m',
                'repeat_interval' => '3h',
                'receiver'        => 'slack',
            },
            receivers => [
                {
                    'name'          => 'slack',
                    'slack_configs' => [
                        {
                            'api_url'       => 'https://hooks.slack.com/services/ABCDEFG123456',
                            'channel'       => '#channel',
                            'send_resolved' => true,
                            'username'      => 'username'
                        },
                    ],
                },
            ],
        }
    }
    
    if ( $config['blackbox_exporter']['enabled'] ) {
        class { 'prometheus::blackbox_exporter':
            version   => "${config['blackbox_exporter']['version']}",
            
            /* Class[Prometheus::Blackbox_exporter]: has no parameter named 'scrape_configs' */
            /*
            scrape_configs => [
                {
                    'job_name'        => 'blackbox',
                    'scrape_interval' => '10s',
                    'scrape_timeout'  => '10s',
                    'metrics_path'  => '/probe',
                    'static_configs'  => [
                        {
                            'targets' => [ 'http://vankosoft.org' ],
                            'labels'  => {
                                'alias' => 'VankoSOft.Org',
                            }
                        }
                    ],
                },
            ],
            */
        }
    }
}
