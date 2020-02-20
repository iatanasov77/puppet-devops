class devops::packages
{
    $vsConfig['packages'].each |Integer $index, String $value|
    {
        if ( $value == 'git' ) {
            require git
                
            git::config { 'user.name':
                value => $vsConfig['git']['userName'],
                user    => 'vagrant',
            }
            git::config { 'user.email':
                value => $vsConfig['git']['userEmail'],
                user    => 'vagrant',
            }
        } elsif ( $value == 'gitflow' and $operatingsystem == 'Ubuntu' ) {
            package { 'git-flow':
                ensure => present,
            }
        } else {
            package { $value:
                ensure => present,
            }
        }
    }
}
