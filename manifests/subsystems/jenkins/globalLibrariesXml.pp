class vs_devops::subsystems::jenkins::globalLibrariesXml (
    Hash $libraries  = {},
) {
    File { '/var/lib/jenkins/org.jenkinsci.plugins.workflow.libs.GlobalLibraries.xml':
        ensure  => file,
        content => template( 'vs_devops/jenkins/libraries/GlobalLibraries.xml.erb' ),
        mode    => '0644',
        owner   => 'jenkins',
        group   => 'jenkins',
    }
}
