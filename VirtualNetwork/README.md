# Virtual Network
This folder provide the powershell script for Azure virtual network.

## Login To Azure
To login to Azure environment, you can run the cmdlet from here.
Or, for automation tasks without user interaction, you can reference from here.

```powershell
# Define Tenant ID
$TenantID = "<Tenant ID>"
$SubscriptionID = "<Subscription ID>"

# Define user credential, this can be skip if you want a user interation interface
$User = "<User Account UPN>"
$PW = ConvertTo-SecureString -String "<Password>" -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User,$PW

# Login to Azure (Without user interaction)
Connect-AzAccount -Tenant $TenantID -Subscription $SubscriptionID -Credential $Credential

# Login to Azure (With user interaction)
Connect-AzAccount -Tenant $TenantID -Subscription $SubscriptionID
```

## Learn More
For more official documentation for Azure virtual network, you can visit [here][AzureVirtualNetworkDocument].



[AzureVirtualNetworkDocument]: https://learn.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview
