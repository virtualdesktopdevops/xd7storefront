#Class configuring Citrix Storefront SSL access
class xd7storefront::sslconfig inherits xd7storefront {
  if $xd7storefront::https {
    if ($xd7storefront::cacertificatesourcepath != '') {
      #Import and install CA certificate in LocalMachine Root store
      dsc_file{ 'CACert':
        dsc_sourcepath      => $xd7storefront::cacertificatesourcepath,
        dsc_destinationpath => 'c:\SSL\ca.pem',
        dsc_type            => 'File'
      }

      dsc_xcertificateimport{ 'ImportCACert':
        dsc_thumbprint => $xd7storefront::cacertificatethumbprint,
        dsc_path       => 'c:\SSL\ca.pem',
        dsc_location   => 'LocalMachine',
        dsc_store      => 'Root',
        require        => Dsc_file['CACert']
      }
    }

    #Import and install server certificate
    dsc_file{ 'SSLCert':
      dsc_sourcepath      => $xd7storefront::sslcertificatesourcepath,
      dsc_destinationpath => 'c:\SSL\cert.pfx',
      dsc_type            => 'File'
    }

    dsc_xpfximport{ 'ImportSSLCert':
      dsc_thumbprint => $xd7storefront::sslcertificatethumbprint,
      dsc_path       => 'c:\SSL\cert.pfx',
      dsc_location   => 'LocalMachine',
      dsc_store      => 'WebHosting',
      dsc_credential => {'user' => 'cert', 'password' => $xd7storefront::sslcertificatepassword },
      require        => Dsc_file['SSLCert']
    }

    #---- WARNING ----
    #BREAKS STOREFRONT POWERSHELL SDK AND CONSOLE
    #---- WARNING ----
    #dsc_xwebsite{ 'DefaultWebSiteSSL':
    #  dsc_name => 'Default Web Site',
    #  dsc_bindinginfo => [
    #    { protocol => 'HTTPS', port => '443', certificatethumbprint => $sslCertificateThumbprint, certificatestorename => 'WebHosting' }
    #    ],
    #  require => Dsc_xpfximport['ImportSSLCert']
    #}

  }
  #else {
    #---- WARNING ----
    #BREAKS STOREFRONT POWERSHELL SDK AND CONSOLE
    #---- WARNING ----
    #	dsc_xwebsite{ 'DefaultWebSite':
    #		dsc_name => 'Default Web Site',
    #		#dsc_physicalpath => '%SystemDrive%\inetpub\wwwroot',
    #		dsc_bindinginfo => [
    #		 { protocol => 'HTTP', port => '80'}
    #		 ],
    #  }
    #}
}
