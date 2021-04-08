class vs_devops::subsystems::jenkins::jenkinsCli (
	Array $plugins     = [],
	Hash $credentials  = {},
	Hash $jobs         = {},
) {
    /*
     * PLUGINS
     */
	$plugins.each |String $plugin|
	{
		Exec { "Install Plugin '${plugin}' by CLI":
        	command	   => "/usr/bin/java -jar /usr/lib/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin ${plugin}",
        	timeout    => 1800,
        	tries      => 3,
        }
	}
	
	/*
	 * CREDENTIALS
	 * Tutorial: https://sharadchhetri.com/manage-jenkins-credentials/
	 */
	$credentials.each |String $id, Hash $crd|
    {
        vs_devops::subsystems::jenkins::credentialXMl { "jenkins-credential-${id}":
            crdId   => $id,
            config  => $crd,
        } ->
        Exec { "Add Global Credential: ${id}":
            command    => "/usr/bin/java -jar /usr/lib/jenkins/jenkins-cli.jar -s http://localhost:8080/ \
                            create-credentials-by-xml system::system::jenkins _  < /tmp/jenkins-credential-${id}.xml",
            timeout    => 1800,
            tries      => 3,
        }
    }
    
    $jobs.each |String $job, Hash $jobConfig|
    {
        jenkins::job { "${jobConfig['name']}":
            config  => template("vs_devops/jenkins/jobs/${jobConfig['type']}.xml.erb"),
        }
    }
}
