<?php
/*
 * Init Options
 */
$shortopts  = "p:d:";
$longopts   = ["port:","data:"];
$options    = getopt( $shortopts, $longopts );

/*
 * Fetch Passed Options
 */
$vaultPort  = $options['p'];
if ( isset( $options['d'] ) ) {
    $secrets    = json_decode( file_get_contents( $options['d'] ), true );
}

/*
 * Main Script
 */
$strVaultKeys   = shell_exec( "curl --request POST --data '{\"secret_shares\": 1, \"secret_threshold\": 1}' http://127.0.0.1:{$vaultPort}/v1/sys/init" );
$vaultKeys      = json_decode( $strVaultKeys, true );

file_put_contents( "/etc/profile.d/vault.sh", "export VAULT_ADDR='http://0.0.0.0:{$vaultPort}'\nexport VAULT_TOKEN='{$vaultKeys['root_token']}'" );

putenv( "VAULT_TOKEN='{$vaultKeys['root_token']}'" );
$unsealOut  = shell_exec( "curl --request POST --data '{\"key\": \"{$vaultKeys['keys_base64'][0]}\"}' http://127.0.0.1:{$vaultPort}/v1/sys/unseal" );

/*
 * Dev servers have version 2 of KV secrets engine mounted by default, so will
 * need these paths to grant permissions
 * READ HOWTO SETUP POLICIES: 
 */
$policyOut      = shell_exec( "curl --header \"X-Vault-Token: {$vaultKeys['root_token']}\" --request PUT --data '{\"policy\":\"path \\\"secret/data/*\\\" {capabilities = [\\\"create\\\", \\\"update\\\"]}\"}' http://127.0.0.1:{$vaultPort}/v1/sys/policies/acl/my-policy" );
$mountSecretOut = shell_exec( "curl --header \"X-Vault-Token: {$vaultKeys['root_token']}\" --request POST --data '{\"type\":\"kv-v2\" }' http://127.0.0.1:{$vaultPort}/v1/sys/mounts/secret" );
if ( isset( $options['d'] ) ) {
    foreach ( $secrets as $key => $val ) {
        $data   = '{ "data":  ' . json_encode( $val ) . ' }';
        
        $postSecretsCommand = "curl --header \"X-Vault-Token: {$vaultKeys['root_token']}\" --request POST --data '{$data}' http://127.0.0.1:{$vaultPort}/v1/secret/data/{$key}";
        $postSecretsOut     = "{$postSecretsCommand}\n-------------------------------------------------------------------------------------------------------------------------------------\n";
        $postSecretsOut     .= shell_exec( $postSecretsCommand );
    }
    
} else {
    $postSecretsOut = '';
}
/*
 * vault kv put secret/demo secret1=Password1 secret2=Password2
 * curl --header "X-Vault-Token: $VAULT_TOKEN" --request POST --data '{ "data": { "foo": "bar", "zip": "zap" } }' http://127.0.0.1:{$vaultPort}/v1/secret/data/my_projects | jq
 * curl --header "X-Vault-Token: $VAULT_TOKEN" --request LIST http://127.0.0.1:{$vaultPort}/v1/secret/data/my_projects?version=1 | jq
 */

/*
 * Write Log
 */
file_put_contents( '/tmp/vault_setup.log', "{$strVaultKeys}\n\n\n\n{$unsealOut}\n\n\n\n{$policyOut}\n\n\n\n{$mountSecretOut}\n\n\n\n{$postSecretsOut}\n\n\n\n{$options['d']}" );

/*
 * Write Unseal Keys For GUI
 */
file_put_contents( "/vagrant/gui/var/vault.json", json_encode( $vaultKeys, JSON_PRETTY_PRINT ) );
