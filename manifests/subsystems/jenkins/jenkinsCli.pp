class vs_devops::subsystems::jenkins::jenkinsCli (
	Array $plugins     = [],
	Hash $credentials  = {},
) {
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
	 */
	$credentials.each |String $id, String $crd|
    {
        Exec { "Install Plugin '${plugin}' by CLI":
            command    => "echo '<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
<scope>GLOBAL</scope>
  <id>${id}</id>
  <description></description>
  <username>${crd['username']}</username>
  <password>${crd['password']}</password>
</com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>'\
 | /usr/bin/java -jar /usr/lib/jenkins/jenkins-cli.jar -s http://localhost:8080/ \
   create-credentials-by-xml system::system::jenkins _",
            timeout    => 1800,
            tries      => 3,
        }
    } 
}
