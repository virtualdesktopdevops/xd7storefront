#Type for Citrix Netscaler Gateway declaration in Citrix Storefront
define xd7storefront::netscalergateway (
  String $netscaler_name,
  String $netscaler_external_url,
  Enum['UsedForHDXOnly', 'Domain', 'RSA', 'DomainAndRSA', 'SMS', 'GatewayKnows', 'SmartCard', 'None'] $netscaler_authentication_method,
  String $netscaler_callback_url,
  String $netscaler_snip,
  Array[String] $sta_urls,
  Optional[String] $netscaler_smartcardfallbacklogontype = 'None',
)
{
  dsc_sfgateway{'NetscalerGateway':
    dsc_name                       => $netscaler_name,
    dsc_url                        => $netscaler_external_url,
    dsc_logontype                  => $netscaler_authentication_method,
    dsc_callbackurl                => $netscaler_callback_url,
    dsc_requesttickettwostas       => true,
    dsc_secureticketauthorityurls  => $sta_urls,
    dsc_sessionreliability         => true,
    dsc_smartcardfallbacklogontype => $netscaler_smartcardfallbacklogontype,
    #dsc_stasbypassduration => 30,
    #dsc_stasuseloadbalancing => true,
    dsc_subnetipaddress            => $netscaler_snip,
    dsc_ensure                     => 'Present'
    }
}
