# Login

This repositry is used to store PowerShell script for cerdential login to Azure environment.

## PowerShell Module
The Powershell Module used in this repositry listed as below:
* [`Az.Accounts`][Az.Accounts]


## Interactive authentication
Initially, if we run [`Connect-AzAccount`][Connect-AzAccount], it will require us to input the user name and password in the prompted browser.
```powershell
# A browser will be open to log in to the Azure account.
Connect-AzAccount
```
If we would like to use the build in credential prompt windows, we can use below.
```powershell
# Log in to Azure with Windows build in prompt.
$Credential = Get-Credential
Connect-AzAccount -Credential $Credential -TenantId "<Tenant ID>"
```
Those method will require user input and interaction to finish the login process.

## Noninteractive authentication
However, in some scenario, for example automation and scheduled tasks, user interaction might not be an option.</br>
This reposity provide some automation apparoch for the Azure login.<br />

### Login with Service Principal
If an [app registrtion][AppRegistration] is created, we can login to Azure with the application ID and the secret.
```powershell
# Define App registration information
$ApplicationID = "<Application ID>"
$ApplicationSecret = "<Application Secret>" | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationID, $ApplicationSecret

# Define Tenant and Subscription Information
$TenantID = "<Tenant ID>"
$SubscriptionID = "<Subscription ID>"

# Log in to Azure with app registration
Connect-AzAccount -ServicePrincipal -Credential $Credential -TenantId $TenantID -SubscriptionId $SubscriptionID
```

### Login with multiple user credential
The script [LoginAzureWithMultiCredential.ps1][LoginAzureWithMultiCredential] provide the sample script to run the login when there are multiple credential, for example, when the automation include multiple tenant.</br>
Before we run the script, we will need to create a CSV to record the credential. ***Please keep the credential csv well to prevent the security harm.***

![AzLoginCredentialScreenCapture]

Place the script and csv file in the same location, Now we can run it.
```powershell
# Import CSV
$CsvLoginCredential = Import-csv ".\AzLoginCredential.csv"

foreach
```

## Reference
* [Azure PowerShell Github][AzurePowerShellGithub]




<!-- References -->


<!-- Local -->
[LoginAzureWithMultiCredential]: LoginAzureWithMultiCredential.ps1
[AzLoginCredentialScreenCapture]: image/AzLoginCredential%20-%20ScreenCapture.png

<!-- External -->
[Az.Accounts]: https://learn.microsoft.com/en-us/powershell/module/az.accounts/?view=azps-11.1.0
[Connect-AzAccount]: https://learn.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount?view=azps-11.1.0
[AppRegistration]: https://learn.microsoft.com/en-us/power-apps/developer/data-platform/walkthrough-register-app-azure-active-directory