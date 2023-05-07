#!/usr/bin/php
<?php
/**
 * Used In Class 'vs_devops::subsystems::jenkins::jenkinsCliCredentials'
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
$xmlFile    = '/tmp/jenkins-credential-' . $options['i'] . '.xml';
$xml    = new SimpleXMLElement( file_get_contents( $xmlFile ) );

if ( $xml->privateKeySource ) {
    $xml->privateKeySource->privateKey[0] = file_get_contents( trim( $xml->privateKeySource->privateKey[0] ) ) . "\n";
    file_put_contents( $xmlFile, $xml->asXML() );
}
