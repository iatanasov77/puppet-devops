class vs_devops::dependencies::packages (
    String $gitUserName     = 'undefined_user_name',
    String $gitUserEmail    = 'undefined@example.com',
) {
    require git
    git::config { 'user.name':
        value => $gitUserName,
        user    => 'vagrant',
    }
    git::config { 'user.email':
        value => $gitUserEmail,
        user    => 'vagrant',
    }
    
    if ! defined(Package['wget']) {
        Package { 'wget':
            ensure => present,
        }
    }
    
    if ! defined(Package['unzip']) {
        Package { 'unzip':
            ensure => present,
        }
    }
}
