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