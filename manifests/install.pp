class xd7storefront::install inherits xd7storefront {
  
  	dsc_windowsfeature{'iis':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Server',
	}->
	
	dsc_windowsfeature{'Web-Scripting-Tools':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Scripting-Tools',
	}->
	
	dsc_windowsfeature{'Web-Mgmt-Console':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Mgmt-Console',
	}->
	
	dsc_windowsfeature{'Web-Common-Http':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Common-Http',
	}->
	
	dsc_windowsfeature{'Web-Default-Doc':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Default-Doc',
	}->
	
	dsc_windowsfeature{'Web-Http-Errors':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Http-Errors',
	}->
	
	dsc_windowsfeature{'Web-Static-Content':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Static-Content',
	}->
	
	dsc_windowsfeature{'Web-Http-Redirect':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Http-Redirect',
	}->
	
	dsc_windowsfeature{'Web-Http-Logging':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Http-Logging',
	}->
	
	dsc_windowsfeature{'aspnet45':
	  dsc_ensure => 'Present',
	  dsc_name   => 'Web-Asp-Net45',
	}->
	
	dsc_windowsfeature{'NET-Framework-45-ASPNET':
	  dsc_ensure => 'Present',
	  dsc_name   => 'NET-Framework-45-ASPNET',
	}->
	
	#Reste à activer...
	#            'Web-Filtering',
	#            'Web-Basic-Auth',
	#            'Web-Windows-Auth',
	#            'Web-Net-Ext45',
	#            'Web-AppInit',,
	#            'Web-ISAPI-Ext',
	#            'Web-ISAPI-Filter',
	
	dsc_xd7feature { 'XD7Storefront':
	  dsc_role => 'Storefront',
	  dsc_sourcepath => $sourcepath,
	  dsc_ensure => 'present',
		notify => Reboot['after_run']
		}

	reboot { 'after_run':
	  apply => finished,
	}

}