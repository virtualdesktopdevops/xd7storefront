define xd7storefront::store (
  $storeName,
  $xd7sitename,
  $xd7farmType,
  $deliverycontrollers,
  $deliveryControllersTransportType = 'HTTPS',
  $deliveryControllersPort = 443,
  $deliveryControllersLoadBalance = true,
  $storefrontAuthMethods = ['ExplicitForms','IntegratedWindows']
) 
{  
  #Adds an authentication service to Storefront group/cluster. 
  dsc_sfauthenticationservice{ "${storeName}Auth":
   dsc_virtualpath => "/Citrix/${storeName}Auth"
  }->
  
  #Configures authentication methods available on an existing Citrix StoreFront Authentication Service
  #string Array [ 'Certificate',  'CitrixAGBasic', 'CitrixFederation', 'ExplicitForms', 'HttpBasic', 'IntegratedWindows' ]
  dsc_sfauthenticationservicemethod{ "${storeName}AuthMethod":
    dsc_virtualpath => "/Citrix/${storeName}Auth",
    dsc_authenticationmethods => $storefrontAuthMethods,
  }->
  
  #Store creation and mapping to the authentication service
  dsc_sfstore{"${storeName}":
   dsc_friendlyname => $storeName,
   dsc_virtualpath => "/Citrix/${storeName}",
   dsc_authenticationservicevirtualpath => "/Citrix/${storeName}Auth"
  }->
  
  #Adds a Web Receiver site to the store.
  dsc_sfstorewebreceiver{ "${storeName}Receiver":
   dsc_storevirtualpath => "/Citrix/${storeName}",
   dsc_virtualpath => "/Citrix/${storeName}Web"
  }->
  
  dsc_xd7storefrontreceiverauthenticationmethod{ "${storeName}ReceiverWebAuthenticationMethods":
   dsc_virtualpath => '/Citrix/StoreWeb',
   dsc_siteid => 1,
   dsc_authenticationmethod => $storefrontAuthMethods,
 }->
  
  #Adds a XenApp/XenDesktop farm/site to the store.
  dsc_sfstorefarm{ "${storeName}Farm":
   dsc_storevirtualpath => "/Citrix/${storeName}",
   dsc_farmname => $xd7sitename,
   dsc_farmtype => $xd7farmType,
   dsc_servers => $deliverycontrollers,
   dsc_transporttype => $deliveryControllersTransportType,
   dsc_loadbalance => $deliveryControllersLoadBalance,
   #dsc_serviceport => $deliveryControllersPort,
  }
	
}
