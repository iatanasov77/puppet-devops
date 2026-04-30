class vs_devops::subsystems::jenkins::jenkinsCliPlugins (
    $jenkinsCli,
    String $hostAddress,
	Hash $plugins  = {},
) {
    /*
    $jenkinsHost = "127.0.0.1"
    $jenkinsHost = "localhost"
    $jenkinsHost = "${hostAddress}"
    $jenkinsHost = "${facts['hostname']}"
    */
    $jenkinsHost = "${facts['hostname']}"
    
	$plugins.each |String $pluginId, Hash $config|
	{
		Exec { "Install Plugin '${pluginId}' by CLI":
        	command	       => "/usr/bin/java -jar ${jenkinsCli} -s http://${jenkinsHost}:8080/ install-plugin ${pluginId}",
        	
        	environment    => [ "JENKINS_URL=http://${jenkinsHost}:8080/" ],
        	timeout        => 1800,
        	tries          => 3,
        }
	}
}
