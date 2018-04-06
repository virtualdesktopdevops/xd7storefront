#Type for Citrix Storefront store creation
define xd7storefront::store (
  $storename,
  $xd7sitename,
  $xd7farmtype,
  $deliverycontrollers,
  $deliverycontrollerstransporttype = 'HTTPS',
  $deliverycontrollersport          = 443,
  $deliverycontrollersloadbalance   = true,
  $storefrontauthmethods            = ['ExplicitForms','IntegratedWindows']
)
{
  #Adds an authentication service to Storefront group/cluster.
  dsc_sfauthenticationservice{ "${storename}Auth":
    dsc_virtualpath => "/Citrix/${storename}Auth"
  }

  #Configures authentication methods available on an existing Citrix StoreFront Authentication Service
  #string Array [ 'Certificate',  'CitrixAGBasic', 'CitrixFederation', 'ExplicitForms', 'HttpBasic', 'IntegratedWindows' ]
->dsc_sfauthenticationservicemethod{ "${storename}AuthMethod":
    dsc_virtualpath           => "/Citrix/${storename}Auth",
    dsc_authenticationmethods => $storefrontauthmethods,
  }

  #Store creation and mapping to the authentication service
->dsc_sfstore{"${storename}Store":
    dsc_friendlyname                     => $storename,
    dsc_virtualpath                      => "/Citrix/${storename}",
    dsc_authenticationservicevirtualpath => "/Citrix/${storename}Auth"
  }

  #Adds a Web Receiver site to the store.
->dsc_sfstorewebreceiver{ "${storename}Receiver":
    dsc_storevirtualpath => "/Citrix/${storename}",
    dsc_virtualpath      => "/Citrix/${storename}Web"
  }

->dsc_xd7storefrontreceiverauthenticationmethod{ "${storename}ReceiverWebAuthenticationMethods":
    dsc_virtualpath          => '/Citrix/StoreWeb',
    dsc_siteid               => 1,
    dsc_authenticationmethod => $storefrontauthmethods,
  }

  #Adds a XenApp/XenDesktop farm/site to the store.
->dsc_sfstorefarm{ "${storename}Farm":
    dsc_storevirtualpath => "/Citrix/${storename}",
    dsc_farmname         => $xd7sitename,
    dsc_farmtype         => $xd7farmtype,
    dsc_servers          => $deliverycontrollers,
    dsc_transporttype    => $deliverycontrollerstransporttype,
    dsc_loadbalance      => $deliverycontrollersloadbalance,
    #dsc_serviceport     => $deliverycontrollersport,
  }
}
