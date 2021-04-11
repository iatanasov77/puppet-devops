define vs_devops::subsystems::jenkins::jobXml (
    String $jobId,
    Hash $config,
) {
    if ( $config['createXml'] ) {
        $xmlConfig  = to_json( $config['config'] )
        Exec { "Create Job Xml /tmp/jenkins-job-${jobId}.xml":
            command => "${config['createXml']} -t '${config['type']}' -i '${jobId}' -c '${xmlConfig}'"
        }
    } else {
        if $config['type']  == 'Pipeline' {
            $fetchPipelineCommand   = "/usr/bin/cat ${config['pipeline']}"
        }
    
        File { "/tmp/jenkins-job-${jobId}.xml":
            ensure  => file,
            content => template( "vs_devops/jenkins/jobs/${config['type']}.xml.erb" ),
        }
    }
}
