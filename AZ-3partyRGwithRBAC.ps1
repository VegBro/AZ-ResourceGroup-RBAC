#Venteanimasjon brukt for å vente på replikering av AAD grupper
function venteanimasjon {

    [CmdletBinding()]
    param
    (
        [Parameter(Position=1)][int]$sekunder=30,
        [Parameter(Position=2)][string]$tekst="Venter på at grupper skal replikere "
    )
        $blank = "`b" * ($tekst.length+11)
        $clear = " " * ($tekst.length+11)
        $anim=@("0o.......o","o0o.......",".o0o......","..o0o.....","...o0o....","....o0o...",".....o0o..","......o0o.",".......o0o","o.......o0") # Animasjonssekvens
        while ($sekunder -gt 0) {
            $anim | % {
                Write-Host "$blank$tekst $_" -NoNewline -ForegroundColor Green 
                Start-Sleep -m 100
            }
            $sekunder --
          }
        Write-Host "$blank$clear$blank" -NoNewline
    }

    function bekreftelse {
        $input = read-host "Vennligst bekreft med skrive ja eller nei og trykk så enter"
        switch ($input) {
        'ja' {
            write-host 'Du bekreftet, oppretter nå ressursgruppen' -ForegroundColor Green
        }

        'nei' {
            Write-Host "Avslutter script..." -ForegroundColor Red
		    exit
        }

        default {
            write-host 'Du kan bare svare ja eller nei, vennligst forsøk igjen.' -ForegroundColor Yellow
            Bekreftelse
        }
    }
}



#Variable parametere
$KundeForkortelse = Read-Host "Angi forkortelsen til kunde (f.eks: mm eller nk)" 
$Workload = Read-Host "Angi ett kort navn for workload som opprettes (f.eks: sql eller visma)"
$Region = Read-Host "Angi region der ressursgruppa skal opprettes (f.eks: norwayeast eller westeurope)"
#Lister de mest brukte built-in rollene under, kopier ID inn i RBACRolle variabel
#Contributor = b24988ac-6180-42a0-ab88-20f7382dd24c
#Owner = 8e3af657-a8ff-443c-a75c-2fe8c4bcb635
#Reader	= acdd72a7-3385-48ef-bd42-f606fba81ae7
$RBACOwner = '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
$RBACContributor = 'b24988ac-6180-42a0-ab88-20f7382dd24c'
$RBACReader = 'acdd72a7-3385-48ef-bd42-f606fba81ae7'
#Faste parametere
$ResourceGroupForkortelse = "rg"
#Prod (p) eller Test (t) miljø
$EnvironementForkortelse = "prod"
#Sammenstilling av variabler for navngivning
$RGNavn = $KundeForkortelse + "-" + $ResourceGroupForkortelse + "-" + $Workload + "-" + $EnvironementForkortelse + "-" + $Region
$AADGrpNavnOwner = "az-rbac-owner-" + $RGNavn
$AADGrpNavnContributor = "az-rbac-contributor-" + $RGNavn
$AADGrpNavnReader = "az-rbac-reader-" + $RGNavn

Write-Host "Ressursgruppe navn blir da: $RGNavn" -ForegroundColor Green

bekreftelse

#Opprett AZ AD grupper
$AADGroupOwner = New-AzADGroup -DisplayName $AADGrpNavnOwner -MailNickName "NA"
$AADGroupContributor = New-AzADGroup -DisplayName $AADGrpNavnContributor -MailNickName "NA"
$AADGroupReader = New-AzADGroup -DisplayName $AADGrpNavnReader -MailNickName "NA"

venteanimasjon

#Deployment av resurss gruppe og roller 
New-AzSubscriptionDeployment -Name BizRGDeploymentRBAC -Location $Region -TemplateFile main.bicep -resourceGroupName $RGNavn -resourceGroupLocation $Region -principalIdOwner $AADGroupOwner.Id -principalIdContributor $AADGroupContributor.Id -principalIdReader $AADGroupReader.Id -roleDefinitionIdOwner $RBACOwner -roleDefinitionIdContributor $RBACContributor -roleDefinitionIdReader $RBACReader
