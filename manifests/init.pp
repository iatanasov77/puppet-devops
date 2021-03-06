class vs_devops (
	String $defaultHost,
    String $defaultDocumentRoot	= '/vagrant/gui_symfony/public',
    
	Hash $subsystems			= {},
	
	Array $packages             = [],
    String $gitUserName         = 'undefined_user_name',
    String $gitUserEmail        = 'undefined@example.com',
    
    /* LAMP SERVER */
	Array $apacheModules        = [],
    
    String $mysqllRootPassword	= 'vagrant',
	$mySqlProvider				= false,
	
	String $phpVersion			= '7.2',
    Hash $phpModules            = {},
    Boolean $phpunit            = false,
    
    Hash $phpSettings           = {},
    
    Hash $phpMyAdmin			= {},
    Hash $databases				= {},
    
    Boolean $forcePhp7Repo      = true,
    
    Hash $vstools               = {},
    String $vaultPort           = '8200',
) {
    stage { 'dependencies-install': before => Stage['main'] }
    
	class { '::vs_devops::dependencies::repos':
		forcePhp7Repo => $forcePhp7Repo,
		phpVersion    => $phpVersion,
		mySqlProvider => $mySqlProvider,
		stage         => 'dependencies-install',
	} ->
    class { 'vs_devops::dependencies::packages':
        stage   => 'dependencies-install',
    }
	
	class { '::vs_devops::vstools':
        vstools => $vstools,
    }
    
	class { '::vs_devops::packages':
        packages        => $packages,
        gitUserName     => $gitUserName,
        gitUserEmail    => $gitUserEmail,
        #stage           => 'dependencies-install',
    } ->
    
    class { '::vs_devops::lamp':
    	defaultHost					=> $defaultHost,
    	defaultDocumentRoot			=> $defaultDocumentRoot,
    	
    	forcePhp7Repo              	=> $forcePhp7Repo,
        phpVersion                  => $phpVersion,
        apacheModules               => $apacheModules,
        
        mysqllRootPassword          => $mysqllRootPassword,
        mySqlProvider				=> $mySqlProvider,

        phpModules                  => $phpModules,
        phpSettings                 => $phpSettings,
        phpunit                     => $phpunit,
        
        phpMyAdmin					=> $phpMyAdmin,
        databases					=> $databases,
    } ->
    
	class { '::vs_devops::subsystems':
        subsystems      => $subsystems,
        vaultPort       => $vaultPort,
    }
    
    file { "${defaultDocumentRoot}/../var/subsystems.json":
		ensure  => file,
		content => to_json_pretty( $subsystems ),
	}
}
