define vs_devops::subsystems::jenkins::jobXml (
    String $jobId,
    Hash $jobConfig,
) {
    notice( "PIPELINE FILE: ${jobConfig['config']['pipeline']}" )
    if $jobConfig['type']  == 'Pipeline' {
        $pipelinePath   = "${jobConfig['config']['pipeline']}"
    } else {
        fail( 'Unknown Job Type !!!' )
    }

    $config = $jobConfig['config']
    File { "/tmp/jenkins-job-${jobId}.xml":
        ensure  => file,
        content => template( "vs_devops/jenkins/jobs/${jobConfig['type']}.xml.erb" ),
    }
}
