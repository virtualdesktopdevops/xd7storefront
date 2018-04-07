#Class configuring Citrix Storefront first store
class xd7storefront::config inherits xd7storefront {

  #Initialize Storefront, deploy Storefront IIS config
  dsc_sfcluster{'StorefrontGroup':
    dsc_baseurl => $xd7storefront::baseurl,
    dsc_siteid  => 1,
  }

  #Create first store
->dsc_sfauthenticationservice{ 'DefaultAuthenticationService':
    dsc_virtualpath => '/Citrix/Authentication',
  }

  #Configures authentication methods available on an existing Citrix StoreFront Authentication Service
  #string Array [ 'Certificate',  'CitrixAGBasic', 'CitrixFederation', 'ExplicitForms', 'HttpBasic', 'IntegratedWindows' ]
->dsc_sfauthenticationservicemethod{ 'DefaultStoreAuthenticationMethods':
    dsc_virtualpath           => '/Citrix/Authentication',
    dsc_authenticationmethods => $xd7storefront::storefrontauthmethods,
  }

  #Exclude CitrixFederation method
->dsc_sfauthenticationservicemethod{ 'ExcludeCitrixFederation':
    dsc_virtualpath                  => '/Citrix/Authentication',
    dsc_excludeauthenticationmethods => ['CitrixFederation'],
  }

  #Create the store
->dsc_sfstore{'DefaultStore':
    dsc_friendlyname                     => 'DefaultStore',
    dsc_virtualpath                      => '/Citrix/Store',
    dsc_authenticationservicevirtualpath => '/Citrix/Authentication',
  }

  #Create the Store web interface
->dsc_sfstorewebreceiver{ 'DefaultStoreWebReceiver':
    dsc_storevirtualpath => '/Citrix/Store',
    dsc_virtualpath      => '/Citrix/StoreWeb',
    require              => Dsc_sfstore['DefaultStore']
  }

  #Make sure that Storefront web receiver authentication methods are the same than Store authentication methods
->dsc_xd7storefrontreceiverauthenticationmethod{ 'XD7StoreFrontReceiverWebAuthenticationMethods':
    dsc_virtualpath          => '/Citrix/StoreWeb',
    dsc_siteid               => 1,
    dsc_authenticationmethod => $xd7storefront::storefrontauthmethods,
    require                  => Dsc_sfstorewebreceiver['DefaultStoreWebReceiver']
  }

  #Link store to XenDesktop site
->dsc_sfstorefarm{ 'DefaultStoreFarm':
    dsc_storevirtualpath => '/Citrix/Store',
    dsc_farmname         => $xd7storefront::xd7sitename,
    dsc_farmtype         => $xd7storefront::xd7farmtype,
    dsc_servers          => $xd7storefront::deliverycontrollers,
    dsc_transporttype    => $xd7storefront::deliverycontrollerstransporttype,
    dsc_loadbalance      => $xd7storefront::deliverycontrollersloadbalance,
    #dsc_port => $deliveryControllersPort,
    require              => Dsc_sfstore['DefaultStore']
  }

  #Disable CRL checking. Causing excepssive delay when storefront logon page is displayed
  #http://www.carlstalhood.com/storefront-3-5-tweaks/#crl
  dsc_script{ 'DisableCRLChecking':
    dsc_getscript  => 'Return @{ Result = $false) }',
    dsc_testscript => 'Return $false',
    dsc_setscript  => 'Add-PSSnapin Citrix.DeliveryServices.Framework.Commands
      Set-DSAssemblyVerification $false'
    }

  #Disable Customer Experience Improvement Program (CEIP)
  #(HKLM:\SOFTWARE\Citrix\Telemetry\CEIP -Name 'Enabled' -Value "0x00000000") and restart CitrixTelemetryService
  #http://www.carlstalhood.com/storefront-3-5-basic-configuration/#ceip
  service{'CitrixTelemetryService':
    ensure => 'running',
    enable => true
  }

  registry_value { 'HKLM\SOFTWARE\Citrix\Telemetry\CEIP':
    ensure => present,
    path   =>'HKLM\SOFTWARE\Citrix\Telemetry\CEIP',
    type   => 'dword',
    data   => '0',
    notify => Service['CitrixTelemetryService']
  }

  #Redirect from default IIS page to default store
  file{'c:/inetpub/wwwroot/index.html':
    ensure  => file,
    content => template('xd7storefront/index.erb'),
    require => Dsc_sfstorewebreceiver['DefaultStoreWebReceiver']
  }
}
