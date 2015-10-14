# This is a Powershell script that create a VM

# change execute policy
#powershell -ExecutionPolicy ByPass -File CreateVM.ps1

'Progress ... Create VM using PowerShell'

#Add Azure Subscription
Add-AzureAccount

# Set VM Image
# $VMImage = (Get-AzureVMImage | Where { $_.Label –like '*Windows 10*' } | Select-Object Label,LogicalSizeInGB,ImageName | Sort-Object LogicalSizeInGB)[-1].ImageName
$VMImage = (Get-AzureVMImage | Where { $_.Label –like '*Windows 10*' } | Sort-Object LogicalSizeInGB)[-1].ImageName
'Set VMImage = ' + $VMImage

# Set VM Size/Role
#$VMSize = (Get-AzureRoleSize | Where { $_.MaxDataDiskCount –ge 3 } | Sort-Object InstanceSize)[-1].InstanceSize
$VMSize = 'Basic_A0'
'Set VMSize = ' + $VMSize

# Set VM Name
# $VMName = $args[0]
$VMName = 'TestingVirtualMachine'
'Set VMName = ' + $VMName

# 1
'Creating config'
$VMConfig = New-AzureVMConfig -Name $VMName -InstanceSize $VMSize -ImageName $VMImage

# Administrator Username and PAssword
$username = 'VMAdmin'
$password = Convertto-Securestring –asplaintext 'StrongP@ssw0rd' -force

'Provisioning'
# 2- Provision it
$VMProvision = $VMconfig | Add-AzureProvisioningConfig –windows –AdminUserName $AdminUserName –password $AdminPassword 

$AzureSubName = (Get-AzureSubscription | Where {$_.IsDefault -eq 'True'}).SubscriptionName
'Set Azure Subscription Name = ' + $AzureSubName

#Link Storage with Subscription:
Set-AzureSubscription -SubscriptionName $AzureSubName -CurrentStorageAccountName (Get-AzureStorageAccount).Label -PassThru

# Get Azure cloud service name
$AzureService = (Get-AzureService).Label
'Set Azure Cloud Service = ' + $AzureService

'Creating the VM, Please wait'
# 3-Create it 
$VM_Result = $VMProvision | New-AzureVM -ServiceName $AzureService -WaitForBoot

'VM Created under name : ' + $VMName

pause