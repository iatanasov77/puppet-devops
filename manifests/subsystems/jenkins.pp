class vs_devops::subsystems::jenkins (
    String $jenkinsCli,
	Hash $config           = {},
	
	Hash $plugins          = {},
	Hash $jobs             = {},
	Hash $credentials      = {},
	
	Hash $pluginsCli       = {},
    Hash $jobsCli          = {},
	Hash $credentialsCli   = {},
	
	Hash $libraries        = {},
) {
    ####################################################################
    # Install Jenkins - BEFORE Stage Main
    ####################################################################
    class { 'vs_devops::subsystems::jenkins::jenkinsInstall':
        config      => $config,
        
        plugins     => $plugins,
        jobs        => $jobs,
        credentials => $credentials,
        
        jenkinsCli  => "${jenkinsCli}",
        
        stage       => 'jenkins-install',
    }

    ####################################################################
    # Configure Jenkins by CLI - IN Stage Main
    ####################################################################
    class { 'vs_devops::subsystems::jenkins::jenkinsCliPlugins':
        jenkinsCli  => "${jenkinsCli}",
        plugins     => $pluginsCli,
    } ->
    Exec { 'Jenkins Service Restart After Add Plugins':
        command => 'service jenkins restart',
    }
    
    ####################################################################
    # Configure Jenkins Libraries - IN Stage Main
    ####################################################################
    class { 'vs_devops::subsystems::jenkins::globalLibrariesXml':
        libraries   => $libraries,
    } ->
    Exec { 'Jenkins Service Restart After Add Libraries':
        command => 'service jenkins restart',
    }
    
    ####################################################################
    # Configure Jenkins by CLI - AFTER Stage Main
    ####################################################################
    class { 'vs_devops::subsystems::jenkins::jenkinsCliCredentials':
        jenkinsCli      => "${jenkinsCli}",
        credentials     => $credentialsCli,
        stage           => 'jenkins-credentials-cli',
    }
    
    class { 'vs_devops::subsystems::jenkins::jenkinsCliJobs':
        jenkinsCli  => "${jenkinsCli}",
        jobs        => $jobsCli,
        stage       => 'jenkins-jobs-cli',
    }
    
    ####################################################################
    # Setup Security Model
    ####################################################################
    /*
    jenkins::user { 'admin':
        email       => "admin@${hostname}",
        password    => 'admin',
        
        stage       => 'jenkins-jobs-cli',
    }
    
    
    Exec { "Set Jenkins Security Model by CLI":
        command    => "sed -i 's/<useSecurity>true<\/useSecurity>/<useSecurity>false<\/useSecurity>/g' /var/lib/jenkins/config.xml",
    }
    */
}
