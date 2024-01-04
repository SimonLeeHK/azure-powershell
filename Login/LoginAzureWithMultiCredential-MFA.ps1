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