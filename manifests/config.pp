class xd7storefront::config inherits xd7storefront {

	#Initialize Storefront, deploy Storefront IIS config
	dsc_sfcluster{'StorefrontGroup':
	 dsc_baseurl => $baseurl,
	 dsc_siteid => 1,
  }->

  #Create first store	
  dsc_sfauthenticationservice{ 'DefaultAuthenticationService':
    dsc_virtualpath => '/Citrix/Authentication',
  }->

  #Configures authentication methods available on an existing Citrix StoreFront Authentication Service
  #string Array [ 'Certificate',  'CitrixAGBasic', 'CitrixFederation', 'ExplicitForms', 'HttpBasic', 'IntegratedWindows' ]
  dsc_sfauthenticationservicemethod{ 'DefaultStoreAuthenticationMethods':
    dsc_virtualpath => '/Citrix/Authentication',
    dsc_authenticationmethods => $storefrontAuthMethods,
  }->

  #Exclude CitrixFederation method
  dsc_sfauthenticationservicemethod{ 'ExcludeCitrixFederation':
    dsc_virtualpath => '/Citrix/Authentication',
    dsc_excludeauthenticationmethods => ['CitrixFederation'],
  }->
  
  #Create the store
  dsc_sfstore{'DefaultStore':
    dsc_friendlyname => 'DefaultStore',
    dsc_virtualpath => '/Citrix/Store',
    dsc_authenticationservicevirtualpath => '/Citrix/Authentication',
  }->

  #Create the Store web interface
  dsc_sfstorewebreceiver{ 'DefaultStoreWebReceiver':
    dsc_storevirtualpath => '/Citrix/Store',
    dsc_virtualpath => '/Citrix/StoreWeb',
    require => Dsc_sfstore['DefaultStore']
  }->
  
  #Make sure that Storefront web receiver authentication methods are the same than Store authentication methods
  dsc_xd7storefrontreceiverauthenticationmethod{ 'XD7StoreFrontReceiverWebAuthenticationMethods':
    dsc_virtualpath => '/Citrix/StoreWeb',
    dsc_siteid => 1,
    dsc_authenticationmethod => $storefrontAuthMethods,
    require => Dsc_sfstorewebreceiver['DefaultStoreWebReceiver']
  }
	
	#Link store to XenDesktop site
  dsc_sfstorefarm{ 'DefaultStoreFarm':
    dsc_storevirtualpath => '/Citrix/Store',
    dsc_farmname => $xd7sitename,
    dsc_farmtype => $xd7farmType,
    dsc_servers => $deliverycontrollers,
    dsc_transporttype => $deliveryControllersTransportType,
    dsc_loadbalance => $deliveryControllersLoadBalance,
    #dsc_port => $deliveryControllersPort,
    require => Dsc_sfstore['DefaultStore']
  }

  
}
