class vs_devops::subsystems::gitlab (
	Hash $config    = {},
) {
    #notice( "SERVICE GITLAB VALUE: ${$vsConfig['services']['gitlab']}" )
    class { 'gitlab':
        external_url => 'http://devops.lh',
        unicorn => {
            'worker_timeout'    => 300,
            'port'              => 8081
        },
    }
}
