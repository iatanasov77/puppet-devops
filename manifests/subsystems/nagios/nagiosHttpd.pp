/**
 * when apache_httpd is false we need to conf nagios server explicitly
 */
class vs_devops::subsystems::nagios::nagiosHttpd
{
	$apache_httpd_conf_content    = undef
	$apache_httpd_conf_source     = undef
	$apache_allowed_from          = []   # Allow access in default template
	$apache_httpd_htpasswd_source = "puppet:///modules/nagios/apache_httpd/htpasswd"

    # Set a default content template if no content/source is specified
    if $apache_httpd_conf_source == undef {
      if $apache_httpd_conf_content == undef {
        $apache_httpd_conf_content_final = template("${module_name}/nagios/apache_httpd/httpd-nagios.conf.erb")
      } else {
        $apache_httpd_conf_content_final = $apache_httpd_conf_content
      }
    }
    file { '/etc/httpd/conf.d/nagios.conf':
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $apache_httpd_conf_content_final,
      source  => $apache_httpd_conf_source,
      notify  => Service['httpd'],
      require => Package['nagios'],
    }
    if $apache_httpd_htpasswd_source != false {
      file { '/etc/nagios/.htpasswd':
        owner   => 'root',
        group   => 'apache',
        mode    => '0640',
        source  => $apache_httpd_htpasswd_source,
        require => Package['nagios'],
      }
    }
}
