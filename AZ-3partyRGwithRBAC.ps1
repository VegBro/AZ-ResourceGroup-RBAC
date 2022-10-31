#Variable parametere
$KundeForkortelse = "tlab" #Forkortelse for kunde
$Workload = "sql"
$Region = "norwayeast"
#Contributor = b24988ac-6180-42a0-ab88-20f7382dd24c
#Owner = 8e3af657-a8ff-443c-a75c-2fe8c4bcb635
#Reader	= acdd72a7-3385-48ef-bd42-f606fba81ae7
$RBACRolle = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
#Faste parametere
$ResourceGroupForkortelse = "rg"
#Prod (p) eller Test (t) miljø
$EnvironementForkortelse = "prod"
#Sammenstilling av variabler for navngivning
$RGNavn = $KundeForkortelse + "-" + $ResourceGroupForkortelse + "-" + $Workload + "-" + $EnvironementForkortelse + "-" + $Region
$AADGrpNavn = "az-rbac-" + $RGNavn

#Opprett AZ AD grupper
$AADGroup = New-AzADGroup -DisplayName $AADGrpNavn -MailNickName "NA"

#Deployment av resurss gruppe og roller 
New-AzSubscriptionDeployment -Name BizRGDeploymentRBAC -Location $Region -TemplateFile main.bicep -resourceGroupName $RGNavn -resourceGroupLocation $Region -principalId $AADGroup.Id -roleDefinitionId $RBACRolle