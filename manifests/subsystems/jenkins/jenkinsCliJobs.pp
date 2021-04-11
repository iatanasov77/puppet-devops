class vs_devops::subsystems::jenkins::jenkinsCliJobs (
	Hash $jobs  = {},
) {	
	$jobs.each |String $id, Hash $job|
    {
        vs_devops::subsystems::jenkins::jobXml { "jenkins-job-${id}":
            jobId   => $id,
            config  => $job,
        } ->
        Exec { "Add Global Credential: ${id}":
            command    => "/usr/bin/java -jar /usr/lib/jenkins/jenkins-cli.jar -s http://localhost:8080/ \
                            create-job \"${job['name']}\"  < /tmp/jenkins-job-${id}.xml",
            timeout    => 1800,
            tries      => 3,
        }
    }
}
