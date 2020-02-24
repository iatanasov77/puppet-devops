class devops
{
    include epel
    include stdlib
    include devops::packages
    
    if ( $vsConfig['services']['maven'] == true )
    {
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
    
    if ( $vsConfig['services']['jenkins'] == true )
    {
        include devops::php
        include devops::jenkins
	}
    
    if ( $vsConfig['services']['gitlab'] == true )
    {
	   include devops::gitlab
	}
}
