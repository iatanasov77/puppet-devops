class vs_devops::subsystems::jenkins (
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
        
        stage       => 'jenkins-install',
    }

    ####################################################################
    # Configure Jenkins by CLI - IN Stage Main
    ####################################################################
    if find_file( '/usr/lib/jenkins/jenkins-cli.jar' ) {
        $jenkinsCli = '/usr/lib/jenkins/jenkins-cli.jar'
    } else {
        $jenkinsCli = '/usr/share/java/jenkins-cli.jar'
    }
    
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
    Exec { "Set Jenkins Security Model by CLI":
        command    => "sed -i 's/<useSecurity>true<\/useSecurity>/<useSecurity>false<\/useSecurity>/g' /var/lib/jenkins/config.xml",
    }
    */
}
