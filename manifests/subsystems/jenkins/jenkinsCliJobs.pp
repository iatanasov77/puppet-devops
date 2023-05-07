class vs_devops::subsystems::jenkins::jenkinsCliJobs (
    $jenkinsCli,
	Hash $jobs  = {},
) {	
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
            command    => "/usr/bin/java -jar ${jenkinsCli} -s http://localhost:8080/ \
                            create-job \"${job['name']}\"  < /tmp/jenkins-job-${id}.xml",
            timeout    => 1800,
            tries      => 3,
        }
    }
}
