define xd7storefront::netscalergateway (
  $netscaler_name,
  $netscaler_external_url = 'http://ext.domain.net',
  $netscaler_authentication_method = 'SmartCard',
  $netscaler_smartcardfallbacklogontype = 'None',
  $netscaler_callback_url = 'http://callback.domain.net',
  $netscaler_snip = '192.168.1.200',
  $sta_urls = ['http://srv-cxdc01.domain.net/scripts/ctxsta.dll'],
)
{  
  dsc_sfgateway{'NetscalerGateway':
    dsc_name => $netscaler_name,
    dsc_url => $netscaler_external_url,
    dsc_logontype => $netscaler_authentication_method,
    dsc_callbackurl => $netscaler_callback_url,
    dsc_requesttickettwostas => true,
    dsc_secureticketauthorityurls => $sta_urls,
    dsc_sessionreliability => true,
    dsc_smartcardfallbacklogontype => $netscaler_smartcardfallbacklogontype,
    #dsc_stasbypassduration => 30,
    #dsc_stasuseloadbalancing => true,
    dsc_subnetipaddress => $netscaler_snip,
    dsc_ensure => 'Present'
    }
}