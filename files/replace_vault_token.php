#!/usr/bin/php
<?php
/**
 * Used In Class 'vs_devops::subsystems::jenkins::vaultPluginSetup'
 */

/*
 * Init Options
 */
$shortopts  = "i:";
$longopts   = ["index:"];
$options    = getopt( $shortopts, $longopts );


/*
 * Main Script
 */
$vaultKeys  = json_decode( file_get_contents( '/vagrant/gui/var/vault.json' ), true );

$xmlFile    = '/tmp/jenkins-credential-' . $options['i'] . '.xml';
$xml        = new SimpleXMLElement( file_get_contents( $xmlFile ) );

if ( $xml->token ) {
    $xml->token[0] = $vaultKeys['root_token'];
    file_put_contents( $xmlFile, $xml->asXML() );
}
