class vs_devops::subsystems::jenkins::jenkinsCliJobs (
    $jenkinsCli,
    String $hostAddress,
	Hash $jobs  = {},
) {
    /*
    $jenkinsHost = "127.0.0.1"
    $jenkinsHost = "localhost"
    $jenkinsHost = "${hostAddress}"
    $jenkinsHost = "${facts['hostname']}"
    */
    $jenkinsHost = "${facts['hostname']}"
    
	$jobs.each |String $id, Hash $job|
    {
        vs_devops::subsystems::jenkins::jobXml { "jenkins-job-${id}":
            jobId       => $id,
            jobConfig   => $job,
        } ->
        Exec { "Adjust Pipeline for Job Id: '${id}'":
            command => "/usr/bin/php /opt/vs_devops/adjust_job_pipeline.php -i${id}",
        } ->
        Exec { "Add Job: ${id}":
            command         => "/usr/bin/java -jar ${jenkinsCli} -s http://${jenkinsHost}:8080/ \
                            create-job \"${job['name']}\"  < /tmp/jenkins-job-${id}.xml",
                            
            environment     => [ "JENKINS_URL=http://${jenkinsHost}:8080/" ],
            timeout         => 1800,
            tries           => 3,
        }
    }
}
