#######################################
# Creating All Needed Scipts
#######################################
class vs_devops::scripts
{
    #######################################
    # Creating Directory For Scipts
    #######################################
    file { '/opt/vs_devops':
        ensure  => 'directory',
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
    }
    
    ###################################################
    # Jenkins Credentials Replace Private Key Script
    ###################################################
    -> file { '/opt/vs_devops/replace_private_key.php':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
        source  => 'puppet:///modules/vs_devops/replace_private_key.php',
    }
    
    ###################################################
    # Jenkins Adjust Job Pipeline Script
    ###################################################
    -> file { '/opt/vs_devops/adjust_job_pipeline.php':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
        source  => 'puppet:///modules/vs_devops/adjust_job_pipeline.php',
    }
    
    ###################################################
    # Nagios Check Docker Container Script
    ###################################################
    -> file { '/opt/vs_devops/check_docker_container.sh':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0777',
        source  => 'puppet:///modules/vs_devops/check_docker_container.sh',
    }
}