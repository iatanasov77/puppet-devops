class vs_devops::lamp (
	String $defaultHost,
    String $defaultDocumentRoot,

	Array $apacheModules        = [],
    
    String $mysqllRootPassword	= 'vagrant',
	$mySqlProvider				= false,
	
	String $phpVersion			= '7.2',
    Hash $phpModules            = {},
    Boolean $phpunit            = false,
    
    Hash $phpSettings           = {},
    
    Hash $phpMyAdmin			= {},
    Hash $databases				= {},
    
    Boolean $forcePhp7Repo      = false,
) {
	class { 'vs_lamp':
        phpVersion                  => $phpVersion,
        apacheModules               => $apacheModules,
        
        mysqllRootPassword          => $mysqllRootPassword,
        mySqlProvider				=> $mySqlProvider,

        phpModules                  => $phpModules,
        phpSettings                 => $phpSettings,
        phpunit                     => $phpunit,
        phpManageRepos              => !$forcePhp7Repo,
        
        phpMyAdmin					=> $phpMyAdmin,
        databases					=> $databases,
    } ->
    
    ##################################################
    # Create Vhost for GUI
    ##################################################
    vs_lamp::apache_vhost{ "${defaultHost}":
        hostName        => $defaultHost,
        documentRoot    => $defaultDocumentRoot,
        aliases         => [
            {
                alias => '/phpmyadmin',
                path  => '/usr/share/phpMyAdmin'
            }
        ],
        directories     => [
            {
                'path'              => '/usr/share/phpMyAdmin',
                'allow_override'    => ['All'],
                'Require'           => 'all granted',
            }
        ],
    }
    
    vs_lamp::apache_vhost{ "api.${defaultHost}":
        hostName        => "api.${defaultHost}",
        documentRoot    => '/vagrant/gui/public',
    }
}
