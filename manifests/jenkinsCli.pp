class vs_devops::jenkinsCli
{
	$vsConfig['services']['jenkinsPluginsCli'].each |String $plugin|
	{
		Exec { "Install Plugin '${plugin}' by CLI":
        	command	=> "/usr/bin/java -jar /usr/lib/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ install-plugin ${plugin}",
        }
	}
}
