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

foreach($Credential in $CsvLoginCredential){
    #Create User Credential
    $User = $CsvLoginCredential.UPN
    $PW = $CsvLoginCredential.Password | ConvertTo-SecureString -AsPlainText -Force
    $Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User,$PW

    #Define Tenant ID and Subscription ID
    $TenantID = $CsvLoginCredential.TenantID
    $SubscriptionID = $CsvLoginCredential.SubscriptionID

    #SignIn to Azure with provided credential
    #MFA must not be configure
    Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID -Credential $Credential

    ## Your automation task ... #
    # .
    # .
    # .
}
```
***Please note that, if the user account or targeted tenant require MFA, the above login will return error.*** </br>

To avoid the scenariothat some of the account require MFA, we can use [LoginAzureWithMultiCredential-MFA.ps1][LoginAzureWithMultiCredential-MFA] to cater it. This also work while the provided credential face login error.
```powershell
#Set error action perference to Stop
$ErrorActionPreference = "Stop"

# Import CSV
$CsvLoginCredential = Import-csv ".\AzLoginCredential.csv"

foreach($Credential in $CsvLoginCredential){
    #Create User Credential
    $User = $CsvLoginCredential.UPN
    $PW = $CsvLoginCredential.Password | ConvertTo-SecureString -AsPlainText -Force
    $Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $User,$PW

    #Define Tenant ID and Subscription ID
    $TenantID = $CsvLoginCredential.TenantID
    $SubscriptionID = $CsvLoginCredential.SubscriptionID

    try{
        #SignIn to Azure with provided credential
        Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID -Credential $Credential
    }catch{
        #SignIn to Azure with user prompt when any error
        Connect-AzAccount -Tenant $TenantID -SubscriptionId $SubscriptionID
    }

    ## Your automation task ... #
    # .
    # .
    # .
}
```

## Use in other scipt
The login scipt if self only provide the authentication part, it will be a foundation in the other automation script. In this case, we can separate the login credential file and the resource configuration file. The script can be download from [here][LoginAzureWithMultiCredential-Automation].
* [AzConfiguration.csv][AzConfigurationCSV] : This CSV file used to store the configuration of the resources, include tenant ID and subscription ID.

![AzConfigurationScreenCapture]

```powershell
#Set error action perference to Stop
$ErrorActionPreference = "Stop"

# Import CSV for credential and configuration
$CsvLoginCredential = Import-csv ".\AzLoginCredential.csv"
$CsvConfiguration = Import-csv ".\AzConfiguration.csv"

# Filter the configuration file to list out the unique tenant and subscption
$UniqueTenantSubscription = $CsvConfiguration | Select-Object "TenantID","SubscriptionID" -Unique

# Loop through the unique tenant and subscription, login with credential match from credential CSV
foreach($TenantSubscription in $UniqueTenantSubscription){
    # Filter the credential with specific tenant and subscription
    $LoginCredential = $CsvLoginCredential | Where-Object {($_.TenantID -eq $TenantSubscription.TenantID) -and ($_.SubscriptionID -eq $TenantSubscription.SubscriptionID)}
    
    #Create User Credential
    $PW = $LoginCredential.Password | ConvertTo-SecureString -AsPlainText -Force
    $Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $LoginCredential.UPN,$PW

    try{
        #SignIn to Azure with provided credential
        Connect-AzAccount -Tenant $LoginCredential.TenantID -SubscriptionId $LoginCredential.SubscriptionID -Credential $Credential
    }catch{
        #SignIn to Azure with user prompt when any error
        Connect-AzAccount -Tenant $LoginCredential.TenantID -SubscriptionId $LoginCredential.SubscriptionID
    }
    
    ## Your automation task ... #
    # .
    # .
    # .
}
```

The script above seperate 2 CSV file for credential and configuration. The idea here is first sort and fiter to check how many unique subscription we need to login, so that we can lookup the correct credential and run the login process with minimum time.

## Reference
* [Az Accounts Module][Az.Accounts]
* [Azure App Registration][AppRegistration]




<!-- References -->


<!-- Local -->
[LoginAzureWithMultiCredential]: LoginAzureWithMultiCredential.ps1
[AzLoginCredentialScreenCapture]: image/AzLoginCredential%20-%20ScreenCapture.png
[LoginAzureWithMultiCredential-MFA]: LoginAzureWithMultiCredential-MFA.ps1
[LoginAzureWithMultiCredential-Automation]: LoginAzureWithMultiCredential-Automation.ps1
[AzConfigurationScreenCapture]: image/AzConfiguration%20-%20ScreenCapture.png
[AzConfigurationCSV]: AzConfiguration.csv

<!-- External -->
[Az.Accounts]: https://learn.microsoft.com/en-us/powershell/module/az.accounts/?view=azps-11.1.0
[Connect-AzAccount]: https://learn.microsoft.com/en-us/powershell/module/az.accounts/connect-azaccount?view=azps-11.1.0
[AppRegistration]: https://learn.microsoft.com/en-us/power-apps/developer/data-platform/walkthrough-register-app-azure-active-directory