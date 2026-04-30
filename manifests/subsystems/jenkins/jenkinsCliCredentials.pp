class vs_devops::subsystems::jenkins::jenkinsCliCredentials (
    $jenkinsCli,
    String $hostAddress,
	Hash $credentials  = {},
) {
    /*
    $jenkinsHost = "127.0.0.1"
    $jenkinsHost = "localhost"
    $jenkinsHost = "${hostAddress}"
    $jenkinsHost = "${facts['hostname']}"
    */
    $jenkinsHost = "${facts['hostname']}"
    
	/*
	 * Tutorial: https://sharadchhetri.com/manage-jenkins-credentials/
	 */
	$credentials.each |String $id, Hash $crd|
    {
        vs_devops::subsystems::jenkins::credentialXml { "jenkins-credential-${id}":
            crdId   => $id,
            config  => $crd,
        } ->
        Exec { "Set PrivateKey for: ${id}":
            command => "/usr/bin/php /opt/vs_devops/replace_private_key.php -i${id}",
        } ->
        Exec { "Add Global Credential: ${id}":
            command         => "/usr/bin/java -jar ${jenkinsCli} -s http://${jenkinsHost}:8080/ \
                            create-credentials-by-xml system::system::jenkins _  < /tmp/jenkins-credential-${id}.xml",
            
            environment     => [ "JENKINS_URL=http://${jenkinsHost}:8080/" ],
            timeout         => 1800,
            tries           => 3,
        }
    }
}
