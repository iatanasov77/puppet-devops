class devops::jenkins
{
    class{ 'jenkins':
        config_hash => {
            'JENKINS_PORT'  => { 'value' => '8080' },
        }
    }
    
    jenkins::plugin { 'git':
        version => '1.1.11',
    }
    
    jenkins::plugin { 'ftppublisher':
    
    }
    
    jenkins::plugin { 'publish-over':
    
    }
    jenkins::plugin { 'publish-over-ftp':
    
    }
    
    jenkins::plugin { 'jobConfigHistory':
    
    }
    
    jenkins::plugin { 'phing':
    
    }
    
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
