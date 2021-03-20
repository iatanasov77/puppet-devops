class vs_devops::notifyServices
{
	Exec { 'Jenkins Service Restart':
    	command	=> 'service jenkins restart',
    }
}
