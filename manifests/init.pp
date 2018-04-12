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
  String $baseurl, # http(s)://FQDN of the required Storefront URL. In case of cluster, use cluster URL
  String $setup_svc_username,
  String $setup_svc_password,
  String $sourcepath,
  String $xd7sitename,
  Array[String] $deliverycontrollers, # List of XML servers (FQDN)
  Optional[Integer] $deliverycontrollersport         = 443,
  Optional[String] $deliverycontrollerstransporttype = 'https',
  Optional[Boolean] $deliverycontrollersloadbalance  = true,
  Enum['XenDesktop', 'XenApp'] $xd7farmtype          = 'XenDesktop',
  Array[String] $storefrontauthmethods               = ['ExplicitForms','IntegratedWindows'],
  Optional[Boolean] $https                           = false,
  Optional[String] $sslcertificatesourcepath         = '',
  Optional[String] $sslcertificatepassword           = '',
  Optional[String] $sslcertificatethumbprint         = '',
  Optional[String] $cacertificatesourcepath          = '',
  Optional[String] $cacertificatethumbprint          = ''
)

{
  contain xd7storefront::installwindowsfeatures
  contain xd7storefront::installstorefront
  contain xd7storefront::config
  contain xd7storefront::networkconfig
  contain xd7storefront::sslconfig
  #contain xd7storefront::service

  Class['::xd7storefront::installwindowsfeatures']
->Class['::xd7storefront::installstorefront']
->Class['::xd7storefront::config']
->Class['::xd7storefront::networkconfig']
->Class['::xd7storefront::sslconfig']
#->Class['::xd7storefront::service']

}
