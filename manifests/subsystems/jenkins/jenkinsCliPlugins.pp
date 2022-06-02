class vs_devops::subsystems::jenkins::jenkinsCliPlugins (
    $jenkinsCli,
	Hash $plugins  = {},
) {
	$plugins.each |String $pluginId, Hash $config|
	{
		Exec { "Install Plugin '${pluginId}' by CLI":
        	command	   => "/usr/bin/java -jar ${jenkinsCli} -s http://127.0.0.1:8080/ install-plugin ${pluginId}",
        	timeout    => 1800,
        	tries      => 3,
        }
	}
}
