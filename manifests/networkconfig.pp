#Class configuring Citrix Storefront network parameters and firewall rules
class xd7storefront::networkconfig inherits xd7storefront {
  #Disable NETBIOS. Causing excepssive delay when storefront logon page is displayed
  #http://www.carlstalhood.com/storefront-3-5-tweaks/#crl
  #Disabled until publication of xNetbios bugfix in puppetlabs/dsc
  #dsc_xnetbios{'DisableNetBIOS':
  #  dsc_interfacealias => $facts['interfaces'],
  #  dsc_setting        => 'Disable'
  #}

  #Disable IPV6
  dsc_xnetadapterbinding{'DisableIPv6':
    dsc_interfacealias => $facts['interfaces'],
    dsc_componentid    => 'ms_tcpip6',
    dsc_state          => 'Disabled'
  }

  #Firewall rules
  dsc_xfirewall{'StorefrontHttpFWRule':
    dsc_name    => 'IIS-WebServerRole-HTTP-In-TCP',
    dsc_ensure  => 'Present',
    dsc_enabled => 'True'
  }

  dsc_xfirewall{'StorefrontHttpsFWRule':
    dsc_name    => 'IIS-WebServerRole-HTTPS-In-TCP',
    dsc_ensure  => 'Present',
    dsc_enabled => 'True'
  }

}
