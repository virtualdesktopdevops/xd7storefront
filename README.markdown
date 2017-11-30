# xd7storefront #

This modules install a fully working Citrix 7.x Storefront and a default Store. It provides puppet types configuration of additionnal stores as well as Netscaler Gateways for external access.

The following options are available for a production-grade installation :
- Sécurity : SSL configuration to secure communications with the Citrix XML service
- Sécurity : IIS SSL configuration to secure communications between Storefront and the client device. 


## Integration informations
Storefront is deployed with a default store configured during install. 

The SSL certificate provided needs to be a password protected p12/pfx certificate including the private key. IIS HTTPS binding has to be activated manuelly with the SSL certificate deployed by puppet because of a compatibility issue between xWebsite DSC ressource and Storefront SDK powershell scripts.

The SSL trust chain is checked by Storefront during HTTPS web access and callback process to Netscaler Gateway. The server certificate deployed for Storefrot (IIS HTTPS binding) and Netscaler Callback VIP have to be signed by the Certification Authority certificate deployed in this puppet module. **Client access to Storefront will fail with self signed certificates or if Storefront is not able to verify the SSL trust chain.

The module can be installed on a Standard, Datacenter version of Windows 2012R2 or Windows 2016. **Core version is not supported by Citrix for delivery Controller installation**.

## Usage
### xd7storefront
This class will install and configure IIS and Citrix Storefront. Storefront deployment is initialized after installation and a default store is created. other stores will be installed later using the xd7storefront::store type.

- **baseurl** : (string) Storefront cluster/group base url, i.e. 'https://storefront.domain.com/'.
- **svc_username** : (string) Privileged account used by Puppet for installing the software.
- **svc_password** : (string) Password of the privileged account. Should be encrypted with hiera-eyaml.
- **sourcepath** : (string) Path of a folder containing the Xendesktop 7.x installer (unarchive the ISO image in this folder).
- **xd7sitename** : (string) Name of the Xendesktop farm hosted on the Delivery Controllers to which Storefront will be linked
- **xd7farmType** : (string : XenDesktop or XenApp) The type of Citrix XenDesktop site/farm hosted on the Delivery Controllers to which Storefront will be linked
- **deliverycontrollers** : (Array of String) List of Citrix Delivery Controllers of the XenDesktop7 site ['srv-cxdc01.domain.net', 'srv-cxdc012.domain.net']
- **deliveryControllersPort** :(Int) Delivery Controllers XML service communication port. If not specified, defaults to 443.
- **deliveryControllersTransportType** : (String) Delivery Controllers XML service transport type. Valid values are: HTTP, HTTPS, SSL. If not specified, defaults to "HTTPS".
- **deliveryControllersLoadBalance** : (boolean) Round robin load balance the xml service servers. If not specified, defaults to True.
- **storefrontAuthMethods** : (Array of String) Storefront user uthentification method. Must be an array with at least one of the following values : [ 'Certificate',  'CitrixAGBasic', 'CitrixFederation', 'ExplicitForms', 'HttpBasic', 'IntegratedWindows' ] 
- **https** : (boolean) : true or false. Deploy SSL certificate on IIS and activate SSL access to Storefront ? Default : false
- **sslCertificateSourcePath** : (string) Location of the SSL certificate (p12 / PFX format with private key). Can be local folder, UNC path, HTTP URL)
- **sslCertificatePassword** : (string) Password protecting the p12/pfx SSL certificate file.
- **sslCertificateThumbprint** : (string) Thumbprint of the SSL certificate (available in the SSL certificate).
- **caCertificateSourcePath** : (string) Location of the SSL Certification Autority root certificate (PEM or CER format). Can be local folder, UNC path, HTTP URL)
- **caCertificateThumbprint** : (string) Thumbprint of the SSL Certification Autority root certificate (available in the SSL certificate).

~~~puppet
node 'storefront' {
	class{'xd7storefront':
	  baseurl => 'https://storefront.testlab.com/'
	  svc_username => 'TESTLAB\svc-puppet',
	  svc_password => 'P@ssw0rd',
	  sourcepath => '\\fileserver\xendesktop715',
	  xd7sitename => 'XD7TestSite',
	  xd7farmType => 'XenDesktop',	  
	  deliverycontrollers => ['srv-cxdc01.testlab.com', 'srv-cxdc02.testlab.com'],
	  deliveryControllersTransportType => 'HTTPS',
	  deliveryControllersPort => 443,
	  deliveryControllersLoadBalance => true,
	  storefrontAuthMethods => ['IntegratedWindows', 'ExplicitForms']
	  https => true,
	  sslCertificateSourcePath => '\\fileserver\ssl\cxdc.pfx',
	  sslCertificatePassword => 'P@ssw0rd',
	  sslCertificateThumbprint => '44cce73845feef4da4d369a37386c862eb3bd4e1',
	  caCertificateSourcePath => '\\fileserver\ssl\ca-root.pem',
	  caCertificateThumbprint => '48jise7dssdsd4da4d369a3738dsdsdeeb3sdiu3'
	}
}
~~~


###xd7storefront::store
Puppet type to configure additionnal stores to a Storefront deployment. Can be declared multiple times in a node configuation.

- **storeName** : (string) Name of the storefront store. Will be used as a Friendly name and as a base for store URL construction.
- **xd7sitename** : (string) Name of the Xendesktop farm hosted on the Delivery Controllers to which Storefront will be linked
- **xd7farmType** : (string : XenDesktop or XenApp) The type of Citrix XenDesktop site/farm hosted on the Delivery Controllers to which Storefront will be linked
- **deliverycontrollers** : (Array of String) List of Citrix Delivery Controllers of the XenDesktop7 site ['srv-cxdc01.domain.net', 'srv-cxdc012.domain.net']
- **deliveryControllersPort** :(Int) Delivery Controllers XML service communication port. If not specified, defaults to 443.
- **deliveryControllersTransportType** : (String) Delivery Controllers XML service transport type. Valid values are: HTTP, HTTPS, SSL. If not specified, defaults to "HTTPS".
- **deliveryControllersLoadBalance** : (boolean) Round robin load balance the xml service servers. If not specified, defaults to True.
- **storefrontAuthMethods** : (Array of String) Storefront user uthentification method. Must be an array with at least one of the following values : [ 'Certificate',  'CitrixAGBasic', 'CitrixFederation', 'ExplicitForms', 'HttpBasic', 'IntegratedWindows' ] 


~~~puppet
node 'storefront' {
	class{'xd7storefront':
	  baseurl => 'https://storefront.testlab.com/'
	  svc_username => 'TESTLAB\svc-puppet',
	  svc_password => 'P@ssw0rd',
	  sourcepath => '\\fileserver\xendesktop715',
	  xd7sitename => 'XD7TestSite',
	  xd7farmType => 'XenDesktop',	  
	  deliverycontrollers => ['srv-cxdc01.testlab.com', 'srv-cxdc02.testlab.com'],
	  deliveryControllersTransportType => 'HTTPS',
	  deliveryControllersPort => 443,
	  deliveryControllersLoadBalance => true,
	  storefrontAuthMethods => ['IntegratedWindows', 'ExplicitForms']
	  https => true,
	  sslCertificateSourcePath => '\\fileserver\ssl\cxdc.pfx',
	  sslCertificatePassword => 'P@ssw0rd',
	  sslCertificateThumbprint => '44cce73845feef4da4d369a37386c862eb3bd4e1',
	  caCertificateSourcePath => '\\fileserver\ssl\ca-root.pem',
	  caCertificateThumbprint => '48jise7dssdsd4da4d369a3738dsdsdeeb3sdiu3'  
	}->
	
	xd7storefront::store{'CustomStore01':
	  storeName => 'CustomStore01',
	  xd7sitename => 'XD7TestSite',
	  xd7farmType => 'XenDesktop',
	  deliverycontrollers => ['srv-cxdc01.testlab.com', 'srv-cxdc02.testlab.com'],
	  deliveryControllersTransportType => 'HTTPS',
	  deliveryControllersPort => 443,
	  deliveryControllersLoadBalance => true,
	  storefrontAuthMethods => ['IntegratedWindows', 'ExplicitForms']
	}
	
	xd7storefront::store{'CustomStore02':
	  storeName => 'CustomStore02',
	  xd7sitename => 'XD7DevelopmentSite',
	  xd7farmType => 'XenDesktop',
	  deliverycontrollers => ['srv-cxdc03.testlab.com', 'srv-cxdc04.testlab.com'],
	  deliveryControllersTransportType => 'HTTPS',
	  deliveryControllersPort => 443,
	  deliveryControllersLoadBalance => true,
	  storefrontAuthMethods => ['CitrixFederation']
	}
}
~~~


###Configure netscaler gateway
Puppet type to declare Netscaler Gateway in a Storefront deployment. Can be declared multiple times in a node configuation.
Declaration of a Netscaler Gateway will create an associated external beacon for external access.

**In this first version of the xd7storefront module, Netscaler Gateway has to be manually linked to a store to enable external access.**

- **netscaler_external_url** : NetScaler gateway external URL for Storefront access.
- **netscaler_authentication_method** : (String) Login type required and supported by the Gateway. Valid values are: UsedForHDXOnly, Domain, RSA, DomainAndRSA, SMS, GatewayKnows, SmartCard, None.
- **netscaler_smartcardfallbacklogontype** : (String) Login type to use when SmartCard fails. Valid values are: UsedForHDXOnly, Domain, RSA, DomainAndRSA, SMS, GatewayKnows, SmartCard, None.
- **netscaler_callback_url** : NetScaler gateway authentication NetScaler call-back Url.
- **netscaler_snip** : NetScaler subnet IP address used to contact Storefront.
- **sta_urls** : (String Array) Array containing XD7 Secure Ticket Authority server URLs at format ['http://srv-cxdc01.domain.net/scripts/ctxsta.dll', 'http://srv-cxdc02.domain.net/scripts/ctxsta.dll'] 


~~~puppet
node 'storefront' {
	xd7storefront::netscalergateway {'ExternalAccess':
	  netscaler_external_url => 'http://ext.domain.net',
	  netscaler_authentication_method => 'SmartCard',
	  netscaler_smartcardfallbacklogontype => 'None',
	  netscaler_callback_url => 'http://callback.domain.net',
	  netscaler_snip => '192.168.1.200',
	  sta_urls => ['http://srv-cxdc01.domain.net/scripts/ctxsta.dll']
	}
}
~~~

