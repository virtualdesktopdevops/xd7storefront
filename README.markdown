# Citrix XenDesktop 7 Storefront puppet module #

This modules install a fully working Citrix XenDesktop 7.x Storefront and a default Store. It provides puppet types configuration of additionnal stores as well as Netscaler Gateways for external access.

The following options are available for a production-grade installation :
- Security : SSL configuration to secure communications with the Citrix XML service
- Security : IIS SSL configuration to secure communications between Storefront and the client device.

## Requirements ##

The minimum Windows Management Framework (PowerShell) version required is 5.0 or higher, which ships with Windows 10 or Windows Server 2016, but can also be installed on Windows 7 SP1, Windows 8.1, Windows Server 2008 R2 SP1, Windows Server 2012 and Windows Server 2012 R2.

This module requires a custom version of the puppetlabs-dsc module compiled with [XenDesktop7](https://github.com/VirtualEngine/XenDesktop7) and [Storefront](https://github.com/VirtualEngine/Storefront/) Powershell DSC resources as a dependency. Ready to use virtualdesktopdevops/dsc v1.5.0 puppet module provided on [Puppet Forge](https://forge.puppet.com/virtualdesktopdevops/dsc).

## Change log ##

A full list of changes in each version can be found in the [change log](CHANGELOG.md).


## Integration informations ##
Storefront is deployed with a default store configured during install.

The SSL certificate provided needs to be a password protected p12/pfx certificate including the private key.

The SSL trust chain is checked by Storefront during HTTPS web access and callback process to Netscaler Gateway. The server certificate deployed for Storefront (IIS HTTPS binding) and Netscaler Callback VIP have to be signed by the Certification Authority certificate deployed in this puppet module. **Client access to Storefront will fail with self signed certificates or if Storefront is not able to verify the SSL trust chain.**

The module can be installed on a Standard, Datacenter version of Windows 2012R2 or Windows 2016.

## Usage ##
### xd7storefront ###
This class will install and configure IIS and Citrix Storefront. Storefront deployment is initialized after IIS installation and a default store is created. Additionnal stores can be configured later using the xd7storefront::store puppet type.

- **`[String]` baseurl** _(Required)_: Storefront cluster/group base url, i.e. 'https://storefront.domain.com/'.
- **`[String]` svc_username** _(Required)_: Privileged account used by Puppet for installing IIS and Citrix Storefront.
- **`[String]` svc_password** _(Required)_: Password of the privileged account. Should be encrypted with hiera-eyaml.
- **`[String]` sourcepath** _(Required)_: Path of a folder containing the Citrix Xendesktop 7.x installer (unarchive the ISO image in this folder).
- **`[String]` xd7sitename** _(Required)_: Name of the Xendesktop 7 farm hosted on the Delivery Controllers to which Storefront will be linked
- **`[String Array]` deliverycontrollers** _(Required)_: List of Citrix Delivery Controllers of the XenDesktop 7 site ['srv-cxdc01.domain.net', 'srv-cxdc012.domain.net']
- **`[Uint32]` deliverycontrollersport** _(Optional, default is 443)_: Delivery Controllers XML service communication port. If not specified, defaults to 443.
- **`[String]` deliverycontrollerstransporttype** _(Optional, default is HTTPS)_: Delivery Controllers XML service transport type. Valid values are: HTTP, HTTPS, SSL. If not specified, defaults to "HTTPS".
- **`[Boolean]` deliverycontrollersloadbalance** _(Optional, default is true)_: Round robin load balance the xml service servers. If not specified, defaults to True.
- **`[String]` xd7farmtype** _(Optional `[XenDesktop|XenApp]`, default is XenDesktop)_: The type of Citrix XenDesktop site/farm hosted on the Delivery Controllers to which Storefront will be linked
- **`[String Array]` storefrontauthmethods** _(Optional, default is `['ExplicitForms','IntegratedWindows']`)_: Storefront user authentification method. Must be an array with at least one of the following values : `[ 'Certificate',  'CitrixAGBasic', 'CitrixFederation', 'ExplicitForms', 'HttpBasic', 'IntegratedWindows' ]`
- **`[Boolean]`https** _(Optional, default is false)_: Deploy SSL certificate on IIS and activate SSL access to Storefront ? Default : false
- **`[String]` sslcertificatesourcepath** _(Required if https = true)_: Location of the SSL certificate (p12 / PFX format with private key). Can be local folder, UNC path, HTTP URL)
- **`[String]` sslcertificatepassword** _(Required if https = true)_: Password protecting the p12/pfx SSL certificate file.
- **`[String]` sslcertificatethumbprint** _(Required if https = true)_: Thumbprint of the SSL certificate (available in the SSL certificate).
- **`[String]` cacertificatesourcepath** _(Required if https = true)_: Location of the SSL Certification Autority root certificate (PEM or CER format). Can be local folder, UNC path, HTTP URL)
- **`[String]` cacertificatethumbprint** _(Required if https = true)_: Thumbprint of the SSL Certification Autority root certificate (available in the SSL certificate).

~~~puppet
node 'storefront' {
	class{'xd7storefront':
	  baseurl => 'https://storefront.testlab.com/'
	  svc_username => 'TESTLAB\svc-puppet',
	  svc_password => 'P@ssw0rd',
	  sourcepath => '\\\\fileserver\xendesktop715',
	  xd7sitename => 'XD7TestSite',
	  xd7farmtype => 'XenDesktop',	  
	  deliverycontrollers => ['srv-cxdc01.testlab.com', 'srv-cxdc02.testlab.com'],
	  deliverycontrollerstransporttype => 'HTTPS',
	  deliverycontrollersport => 443,
	  deliverycontrollersloadbalance => true,
	  storefrontauthmethods => ['IntegratedWindows', 'ExplicitForms']
	  https => true,
	  sslcertificatesourcepath => '\\\\fileserver\ssl\cxdc.pfx',
	  sslcertificatepassword => 'P@ssw0rd',
	  sslcertificatethumbprint => '44cce73845feef4da4d369a37386c862eb3bd4e1',
	  cacertificatesourcepath => '\\\\fileserver\ssl\ca-root.pem',
	  cacertificatethumbprint => '48jise7dssdsd4da4d369a3738dsdsdeeb3sdiu3'
	}
}
~~~


### xd7storefront::store ###
Puppet type to configure additionnal stores to a Citrix Storefront deployment. Can be declared multiple times in a node configuation.

- **`[String]` storeName** _(Required)_: Name of the storefront store. Will be used as a Friendly name and as a base for store URL construction.
- **`[String]` xd7sitename** _(Required)_: Name of the Xendesktop farm hosted on the Delivery Controllers to which Storefront will be linked
- **`[String Array]` deliverycontrollers** _(Required)_: List of Citrix Delivery Controllers of the XenDesktop 7 site `['srv-cxdc01.domain.net', 'srv-cxdc012.domain.net']`
- **`[UInt32]` deliverycontrollersport** _(Optional, default is 443)_: Delivery Controllers XML service communication port. If not specified, defaults to 443.
- **`[String]` deliverycontrollerstransporttype** _(Optional, default is HTTPS)_: Delivery Controllers XML service transport type. Valid values are: HTTP, HTTPS, SSL. If not specified, defaults to "HTTPS".
- **`[Boolean]` deliverycontrollersloadbalance** _(Optional, default is true)_: Round robin load balance the xml service servers. If not specified, defaults to True.
- **`[String]` xd7farmType** _(Optional `[XenDesktop|XenApp]`, default is XenDesktop)_: The type of Citrix XenDesktop site/farm hosted on the Delivery Controllers to which Storefront will be linked.
- **`[String Array]` storefrontauthmethods** _(Optional, default is `['ExplicitForms','IntegratedWindows']`)_: Storefront user uthentification method. Must be an array with at least one of the following values : `[ 'Certificate',  'CitrixAGBasic', 'CitrixFederation', 'ExplicitForms', 'HttpBasic', 'IntegratedWindows' ]`


~~~puppet
node 'storefront' {
	class{'xd7storefront':
	  baseurl => 'https://storefront.testlab.com/'
	  svc_username => 'TESTLAB\svc-puppet',
	  svc_password => 'P@ssw0rd',
	  sourcepath => '\\\\fileserver\xendesktop715',
	  xd7sitename => 'XD7TestSite',
	  xd7farmtype => 'xendesktop',	  
	  deliverycontrollers => ['srv-cxdc01.testlab.com', 'srv-cxdc02.testlab.com'],
	  deliverycontrollerstransporttype => 'HTTPS',
	  deliverycontrollersport => 443,
	  deliverycontrollersloadbalance => true,
	  storefrontauthmethods => ['IntegratedWindows', 'ExplicitForms']
	  https => true,
	  sslcertificatesourcepath => '\\\\fileserver\ssl\cxdc.pfx',
	  sslcertificatepassword => 'P@ssw0rd',
	  sslcertificatethumbprint => '44cce73845feef4da4d369a37386c862eb3bd4e1',
	  cacertificatesourcepath => '\\\\fileserver\ssl\ca-root.pem',
	  cacertificatethumbprint => '48jise7dssdsd4da4d369a3738dsdsdeeb3sdiu3'  
	}->

	xd7storefront::store{'CustomStore01':
	  storename => 'CustomStore01',
	  xd7sitename => 'XD7TestSite',
	  xd7farmtype => 'XenDesktop',
	  deliverycontrollers => ['srv-cxdc01.testlab.com', 'srv-cxdc02.testlab.com'],
	  deliverycontrollerstransporttype => 'HTTPS',
	  deliverycontrollersport => 443,
	  deliverycontrollersloadbalance => true,
	  storefrontauthmethods => ['IntegratedWindows', 'ExplicitForms']
	}

	xd7storefront::store{'CustomStore02':
	  storename => 'CustomStore02',
	  xd7sitename => 'XD7DevelopmentSite',
	  xd7farmtype => 'XenDesktop',
	  deliverycontrollers => ['srv-cxdc03.testlab.com', 'srv-cxdc04.testlab.com'],
	  deliverycontrollerstransporttype => 'HTTPS',
	  deliverycontrollersport => 443,
	  deliverycontrollersloadbalance => true,
	  storefrontauthmethods => ['CitrixFederation']
	}
}
~~~


### xd7storefront::netscalergateway - Configure netscaler gateway ###
Puppet type to declare a Netscaler Gateway in a Citrix Storefront deployment. Can be declared multiple times in a node configuation.
Declaration of a Netscaler Gateway will create an associated external beacon in Storefront for external access.

**In this first version of the xd7storefront module, Netscaler Gateway has to be manually linked to a store to enable external access.**

- **`[String]` netscaler_name** _(Required)_: Name of the Netscaler Gateway object which will be registered in Storefront,
- **`[String]` netscaler_external_url** _(Required)_: NetScaler gateway external URL for Storefront access.
- **`[String]` netscaler_authentication_method** _(Required, ValueMap{"UsedForHDXOnly", "Domain", "RSA", "DomainAndRSA", "SMS", "GatewayKnows", "SmartCard", "None"})_: Login type required and supported by the Gateway. Valid values are: UsedForHDXOnly, Domain, RSA, DomainAndRSA, SMS, GatewayKnows, SmartCard, None.
- **`[String]` netscaler_callback_url** _(Required)_: NetScaler gateway authentication NetScaler call-back Url.
- **`[String]` netscaler_snip** _(Required)_: NetScaler subnet IP address used to contact Storefront.
- **`[String Array]` sta_urls** _(Required)_: (String Array) Array containing XD7 Secure Ticket Authority server URLs at format `['http://srv-cxdc01.domain.net/scripts/ctxsta.dll', 'http://srv-cxdc02.domain.net/scripts/ctxsta.dll']`
- **`[String]` netscaler_smartcardfallbacklogontype** _(Optional, default is none)_: Login type to use when SmartCard fails. Valid values are: UsedForHDXOnly, Domain, RSA, DomainAndRSA, SMS, GatewayKnows, SmartCard, None.


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
