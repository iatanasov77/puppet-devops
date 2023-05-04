class vs_devops (
    Hash $dependencies          = {},
    
	String $defaultHost,
    String $defaultDocumentRoot	= '/vagrant/gui_symfony/public',
    
	Hash $subsystems			= {},
	
	Array $packages             = [],
    String $gitUserName         = 'undefined_user_name',
    String $gitUserEmail        = 'undefined@example.com',
    Array $gitCredentials       = [],
    
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
    Hash $frontendtools         = {},
) {
    ######################################################################
    # Stages After Main
    ######################################################################
    stage { 'git-setup': }
    stage { 'jenkins-plugins-cli': }
    stage { 'jenkins-jobs': }
    stage { 'icinga_web_interface': }
    stage { 'jenkins-credentials-cli': }
    stage { 'jenkins-jobs-cli': }
    stage { 'notify-services': }
    Stage['main']   -> Stage['git-setup'] -> Stage['jenkins-jobs'] -> Stage['icinga_web_interface']
                    -> Stage['jenkins-plugins-cli'] -> Stage['jenkins-credentials-cli'] -> Stage['jenkins-jobs-cli']
                    -> Stage['notify-services']
    
    ######################################################################
    # Stages Before Main
    ######################################################################
    stage { 'dependencies-install': before => Stage['main'] }
    stage { 'jenkins-install': before => Stage['main'] }
    stage { 'icinga-install': before => Stage['main'] }
    

    ######################################################################
    # Start Configuration
    ######################################################################
	class { '::vs_core::dependencies::repos':
        dependencies  => $dependencies,
		forcePhp7Repo => $forcePhp7Repo,
		phpVersion    => $phpVersion,
		mySqlProvider => $mySqlProvider,
		stage         => 'dependencies-install',
	} ->
    class { 'vs_core::dependencies::packages':
        stage           => 'dependencies-install',
        gitUserName     => $gitUserName,
        gitUserEmail    => $gitUserEmail,
    }
	
	class { 'vs_core::dependencies::git_setup':
        stage           => 'git-setup',
        gitUserName     => $gitUserName,
        gitUserEmail    => $gitUserEmail,
        gitCredentials  => $gitCredentials,
    }
    
	class { '::vs_core::vstools':
        vstools => $vstools,
    }
    
	class { '::vs_core::packages':
        packages        => $packages,
        gitUserName     => $gitUserName,
        gitUserEmail    => $gitUserEmail,
    }
    
    class { '::vs_core::frontendtools':
        frontendtools   => $frontendtools,
    }
    
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
        stage                       => 'main',
    }
    
	class { '::vs_devops::subsystems':
        subsystems      => $subsystems,
    }
    
    file { "${defaultDocumentRoot}/../var/subsystems.json":
		ensure  => file,
		content => to_json_pretty( $subsystems ),
	}
}
