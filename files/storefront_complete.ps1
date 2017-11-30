# Citrix Parameters
param (
    [string]$HostBaseURL = "https://sf-01.ctxlab.aws",
    [string]$Farmname = "CTXLAB",
    [string]$Port = "443",
    [string]$TransportType = "HTTPS",
    #[string]$sslRelayPort = "443",
    [array]$Servers = @("dc-01.ctxlab.aws"; "dc-02.ctxlab.aws"),
    #[switch]$LoadBalance = $true,
    [string]$FarmType = "XenDesktop" # XenDesktop or XenApp
 
    #$InternalBeacon = "https://sf-01.ctxlab.aws"
    #[Array]$ExternalBeacons = @("http://www.citrix.com","http://www.google.com")
)
 
# Import Storefront modules
#==========================
 
. "C:\Program Files\Citrix\Receiver StoreFront\Scripts\ImportModules.ps1" 
 
# Setup Initial Configuration
#============================
 
Set-DSInitialConfiguration -hostBaseUrl $HostBaseURL -farmName $Farmname -port $port -transportType $TransportType -sslRelayPort "443" -servers $Servers -loadBalance $true -farmType $FarmType
 
# Config Internal Beacon
#========================
 
#Set-DSGlobalInternalBeacon -BeaconAddress $InternalBeacon 
 
# Config External Beacon
#=======================
 
#Set-DSGlobalExternalBeacons -Beacons $ExternalBeacons[0],$ExternalBeacons[1]
 
# Disable check publisher's certificate revocation (to speed up console start-up)
#================================================================================
 
#set-ItemProperty -path "REGISTRY::\HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\WinTrust\Trust Providers\Software Publishing\" -name State -value 146944