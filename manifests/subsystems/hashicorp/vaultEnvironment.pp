class vs_devops::subsystems::hashicorp::vaultEnvironment (
    Hash $vaultKeys,
    String $vaultPort   = '8200',
) {
    $vaultToken = $vaultKeys['root_token']
    File { "vault_profile.sh":
        ensure  => file,
        path    => "/etc/profile.d/vault.sh",
        content => template( 'vs_devops/hashicorp/vault_profile.sh.erb' ),
        mode    => '0755',
    }
    
    Exec { 'Unseal Vault':
        environment => ["VAULT_TOKEN='${vaultToken}'"],
        command => "curl --request POST --data '{\"key\": \"${vaultKeys['keys_base64'][0]}\"}' http://127.0.0.1:${vaultPort}/v1/sys/unseal > /tmp/vault_unseal.json",
        user    => 'vagrant',
    }
}
