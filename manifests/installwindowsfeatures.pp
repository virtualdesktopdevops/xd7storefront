#Class installing IIS windows features
class xd7storefront::installwindowsfeatures inherits xd7storefront {
  dsc_windowsfeature{'iis':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Server',
  }

->dsc_windowsfeature{'Web-Scripting-Tools':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Scripting-Tools',
  }

->dsc_windowsfeature{'Web-Mgmt-Console':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Mgmt-Console',
  }

->dsc_windowsfeature{'Web-Common-Http':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Common-Http',
  }

->dsc_windowsfeature{'Web-Default-Doc':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Default-Doc',
  }

->dsc_windowsfeature{'Web-Http-Errors':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Http-Errors',
  }

->dsc_windowsfeature{'Web-Static-Content':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Static-Content',
  }

->dsc_windowsfeature{'Web-Http-Redirect':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Http-Redirect',
  }

->dsc_windowsfeature{'Web-Http-Logging':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Http-Logging',
  }

->dsc_windowsfeature{'aspnet45':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Asp-Net45',
  }

->dsc_windowsfeature{'NET-Framework-45-ASPNET':
    dsc_ensure => 'Present',
    dsc_name   => 'NET-Framework-45-ASPNET',
  }

->dsc_windowsfeature{'Web-Basic-Auth':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Basic-Auth',
  }

->dsc_windowsfeature{'Web-Windows-Auth':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-Windows-Auth',
  }

->dsc_windowsfeature{'Web-AppInit':
    dsc_ensure => 'Present',
    dsc_name   => 'Web-AppInit',
  }

  if ($facts['osfamily'] == 'windows') and ($facts['os']['release']['full']== '2012 R2') {
    dsc_windowsfeature{'Web-Asp-Net45':
      dsc_ensure => 'Present',
      dsc_name   => 'Web-Asp-Net45',
    }

  ->dsc_windowsfeature{'Net-Wcf-Tcp-PortSharing45':
      dsc_ensure => 'Present',
      dsc_name   => 'Net-Wcf-Tcp-PortSharing45',
    }
  }
}
