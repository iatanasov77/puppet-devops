class vs_devops::subsystems::maven (
	Hash $config    = {},
) {
	# Install Maven
    class { "maven::maven":
        #version => "3.2.5", # version to install
        # you can get Maven tarball from a Maven repository instead than from Apache servers, optionally with a user/password
        repo => {
            #url => "http://repo.maven.apache.org/maven2",
            #username => "",
            #password => "",
        }
    }
}
