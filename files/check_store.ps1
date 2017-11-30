. "C:\Program Files\Citrix\Receiver StoreFront\Scripts\ImportModules.ps1"
 
if ((Get-STFStoreService | Select-String 'store').count -gt 0) { 
    exit 1 
    }