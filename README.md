# ![AzureIcon] ![PowershellIcon] Microsoft Azure PowerShell

This repositry is used to store PowerShell script for Azure resource development, deployment, administrative work.

## PowerShell Module
For the PowerShell Module used in this repositry, see [Azure PowerShell Modules][AzurePowerShellModules].


### Installation
To install the PowerShell Module, run below command with administrative permission in a PowerShell session.
```powershell
Install-Module -Name Az -Repository PSGallery -Force
```
If you would like to install only specific module in the list, you can run as below.
```powershell
##Install Az Network Module
Install-Module -Name Az.Network -Repository PSGallery -Force

##Install Az Compute Module
Install-Module -Name Az.Compute -Repository PSGallery -Force
```

## Login to Azure
To connect to Azure with PowerShell, `Connect-AzAccount` cmdlet can be used.
```powershell
# A browser will be open to log in to the Azure account.
Connect-AzAccount

# Log in to Azure with Windows build in prompt.
$Credential = Get-Credential
Connect-AzAccount -Credential $Credential -TenantId "<Tenant ID>"
```
For more information, see [here][ConnectAzAccount].

### Login Automation
For different types of automation for login process, see [here].


## Reference
* [Azure PowerShell Github][AzurePowerShellGithub]
* [Microsoft Azure Documentation][AzurePowerShellGithub]
* [AzurePowerShellGithub][PowerShellDocumentation]



<!-- References -->


<!-- Local -->
[AzureIcon]: documentation/image/Microsoft_Azure_32px.png
[PowerShellIcon]: documentation/image/PowerShell_Core_6.0_32px.png

<!-- External -->
[AzurePowerShellModules]: https://github.com/Azure/azure-powershell/blob/main/documentation/azure-powershell-modules.md
[ConnectAzAccount]: https://learn.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount?view=azps-11.1.0
[AzurePowerShellGithub]: https://github.com/Azure/azure-powershell/blob/main/README.md
[MicrosoftAzureDocumentaion]: https://learn.microsoft.com/azure/
[PowerShellDocumentation]: https://learn.microsoft.com/powershell/
