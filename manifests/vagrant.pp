################################################################################
# This Install vagrant Needed For Hashicorp Packer To Build Vagrant Boxes
################################################################################
class vs_devops::vagrant (
    Hash $data
) {
    /**
     * Install Virtual Box
     */
    wget::fetch { "Setup VirtualBox Repo":
        source      => "http://download.virtualbox.org/virtualbox/rpm/rhel/virtualbox.repo",
        destination => '/etc/yum.repos.d/virtualbox.repo',
        verbose     => true,
        mode        => '0644',
        cache_dir   => '/var/cache/wget',
    } ->
    Package { "VirtualBox-${data['virtualboxVersion']}":
        ensure  => present,
    } ->
    
    /**
     * Install Vagrant
     */
    Package { 'vagrant':
        ensure   => 'present',
        name     => 'vagrant',
        provider => 'rpm',
        source   => "${data['vagrantRpm']}",
    }
}
