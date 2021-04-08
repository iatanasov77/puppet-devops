class vs_devops::subsystems::jenkins::jenkinsJobs (
    Hash $jobs         = {},
) {
    $jobs.each |String $job, Hash $jobConfig|
    {
        jenkins::job { "${jobConfig['name']}":
            config  => template("vs_devops/jenkins/jobs/${jobConfig['type']}.xml.erb"),
        }
    }
}
