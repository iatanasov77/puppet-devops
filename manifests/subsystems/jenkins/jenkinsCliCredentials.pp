class vs_devops::subsystems::jenkins::jenkinsCliCredentials (
    $jenkinsCli,
	Hash $credentials  = {},
) {
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
            command    => "/usr/bin/java -jar ${jenkinsCli} -s http://localhost:8080/ \
                            create-credentials-by-xml system::system::jenkins _  < /tmp/jenkins-credential-${id}.xml",
            timeout    => 1800,
            tries      => 3,
        }
    }
}
