class vs_devops::subsystems::jenkins::jenkinsCliCredentials (
	Hash $credentials          = {},
	String $readPrivateKeys    = undef,
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
        Exec { "Add Global Credential: ${id}":
            command    => "/usr/bin/java -jar /usr/lib/jenkins/jenkins-cli.jar -s http://localhost:8080/ \
                            create-credentials-by-xml system::system::jenkins _  < /tmp/jenkins-credential-${id}.xml",
            timeout    => 1800,
            tries      => 3,
        }
        
        notify { "JENKINS CREDENTIALS TYPE: '${crd['type']}'":
            withpath => false,
        }
        notify { "JENKINS CREDENTIALS XML REPLACE SCRIPT: '${readPrivateKeys}'":
            withpath => false,
        }
        if $crd['type'] == 'SSHUserPrivateKey' and $readPrivateKeys {
            Exec { "Set PrivateKey for: ${id}":
                command => "${readPrivateKeys} -i${id}",
                #require => 
            }
        }
    }
}
