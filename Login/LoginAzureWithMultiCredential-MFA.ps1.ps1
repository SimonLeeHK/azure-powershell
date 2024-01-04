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