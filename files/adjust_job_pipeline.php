#!/usr/bin/php
<?php
/**
 * Used In Class 'vs_devops::subsystems::jenkins::jenkinsCliJobs'
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
$xmlFile    = '/tmp/jenkins-job-' . $options['i'] . '.xml';
$xml        = new SimpleXMLElement( file_get_contents( $xmlFile ) );

if ( $xml->definition && $xml->definition->script ) {
    $pipelinePath   = $xml->definition->script[0];
    $pipeline       = file_get_contents( $pipelinePath );
    
    //$xml->definition->script[0] = htmlentities( $pipeline, ENT_QUOTES | ENT_XML1, "UTF-8" );
    $xml->definition->script[0] = $pipeline;
    file_put_contents( $xmlFile, $xml->asXML() );
}

