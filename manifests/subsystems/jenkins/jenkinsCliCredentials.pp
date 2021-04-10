class vs_devops::subsystems::jenkins::jenkinsCliCredentials (
	Hash $credentials  = {},
	$readPrivateKeys   = undef,
) {	
	/*
	 * Tutorial: https://sharadchhetri.com/manage-jenkins-credentials/
	 */
	$credentials.each |String $id, Hash $crd|
    {
        vs_devops::subsystems::jenkins::credentialXMl { "jenkins-credential-${id}":
            crdId   => $id,
            config  => $crd,
        } ->
        Exec { "Set PrivateKey for: ${id}":
            command => "${readPrivateKeys} -i${id}",
            #require => 
        } ->
        Exec { "Add Global Credential: ${id}":
            command    => "/usr/bin/java -jar /usr/lib/jenkins/jenkins-cli.jar -s http://localhost:8080/ \
                            create-credentials-by-xml system::system::jenkins _  < /tmp/jenkins-credential-${id}.xml",
            timeout    => 1800,
            tries      => 3,
        }
    }
}
