Add-AzureAccount
Select-AzureSubscription -SubscriptionName 'YOUR_SUBSCRIPTION_NAME'

# variables
$serverName = 'YOUR_SERVER_NAME'
$dbName = 'YOUR_DB_NAME'

$pwd = ConvertTo-SecureString 'YOUR_PWD' -AsPlainText -Force;
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList 'YOUR_USERNAME', $pwd

$con = New-AzureSqlDatabaseServerContext -ServerName $serverName -Credential $cred
New-AzureSqlDatabase $con –DatabaseName $dbName
