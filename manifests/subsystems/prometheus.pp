class vs_devops::subsystems::prometheus (
    Hash $config       = {},
) {
    class { 'prometheus::server':
        version        => '2.4.3',
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
          {
            'job_name'        => 'prometheus',
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
        ],
    }
}
