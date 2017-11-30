# Class: xd7storefront
#
# This module manages xd7storefront
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class xd7storefront (
	$baseurl, # http(s)://FQDN of the required Storefront URL. In case of cluster, use cluster URL
	$setup_svc_username,
	$setup_svc_password,
	$sourcepath,
	$xd7sitename,
	$xd7farmType = "XenDesktop", # XenDesktop or XenApp
	$deliverycontrollers, # List of XML servers (FQDN)
	$deliveryControllersPort = 443, # XML port
	$deliveryControllersTransportType = "HTTPS", # XML transport type
  $deliveryControllersLoadBalance = true,
  $storefrontAuthMethods = ['ExplicitForms'],
	$https = false,
	$sslCertificateSourcePath = '',
	$sslCertificatePassword = '',
	$sslCertificateThumbprint = '',
  $caCertificateSourcePath = '',
  $caCertificateThumbprint = ''
)

{
  contain xd7storefront::install
  contain xd7storefront::config
  contain xd7storefront::sslconfig
  #contain xd7storefront::service
  
  Class['::xd7storefront::install'] ->
  Class['::xd7storefront::config'] ->
  Class['::xd7storefront::sslconfig']
  #Class['::xd7storefront::service']
  
 
}
