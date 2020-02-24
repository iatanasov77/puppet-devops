class devops::jenkins
{
    class{ 'jenkins':
        config_hash => {
            'JENKINS_PORT'  => { 'value' => "${vsConfig['services']['jenkinsPort']}" },
        }
    }
    
    $vsConfig['services']['jenkinsPlugins'].each |Integer $index, String $value|
    {
        jenkins::plugin { $value:
        
        }
    }
}
