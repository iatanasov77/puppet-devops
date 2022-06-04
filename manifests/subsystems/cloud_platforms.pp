class vs_devops::subsystems::cloud_platforms (
    Hash $config       = {},
) {
    if $config['azure'] {
        case $facts['os']['family'] {
            'RedHat': {
              yumrepo { 'AzureCli':
                descr         => 'Microsoft Azure package repository.',
                baseurl       => "https://packages.microsoft.com/yumrepos/azure-cli",
                gpgcheck      => 1,
                gpgkey        => 'https://packages.microsoft.com/keys/microsoft.asc',
                repo_gpgcheck => 0,
                enabled       => 1,
                /*priority    => 50,*/
              }
            }
            default: {
                fail("\"${module_name}\" provides no repository information for OSfamily \"${facts['os']['family']}\"")
            }
        }
        
        package { "azure-cli":
            ensure  => installed,
            require => Yumrepo['AzureCli'],
        }
    }
    
    if $config['aws'] {
        # CentOs 7 and CentOs 8
        package { "awscli":
            ensure  => installed,
        }
    }
}
