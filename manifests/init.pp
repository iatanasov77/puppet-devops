class devops
{
    include epel
    include stdlib
    include devops::packages
    
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
