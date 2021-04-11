define vs_devops::subsystems::jenkins::jobXml (
    String $jobId,
    Hash $config,
) {
    if $config['type']  == 'Pipeline' {
        $fetchPipelineCommand   = "/usr/bin/cat ${config['pipeline']}"
    }
    
    File { "/tmp/jenkins-job-${jobId}.xml":
        ensure  => file,
        content => template( "vs_devops/jenkins/jobs/${config['type']}.xml.erb" ),
    }
}
