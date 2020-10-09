[cmdletbinding()]
<#
    .PARAMETER servicepla_name
    Nome do App Service Plan.
    .PARAMETER location
    Nome da localização GEO dos recursos no Azure.
    .PARAMETER subscription
    ID da assinatura no Azure.
    .PARAMETER resourcegroup_name
    Nome do Resource Group.
    .PARAMETER webapp_name
    Nome do Webapp.
#>
param(
    $subscription,
    $resourcegroup_name,
    $location,
    $servicepla_name,
    $webapp_name
)

try {
    Write-Information "Iniciando script de criação da Infraestrutura."

    $valorTagCreateBy = (Get-WmiObject -Class win32_computersystem -ComputerName localhost).PrimaryOwnerName

    #Resource Group
    Write-Information "Verificando se Resource Group existe."
    $resourcegroup = az group list --subscription $subscription --query "[?name==$($resourcegroup_name)]" | ConvertFrom-Json
    if($resourcegroup.count -eq 0 ) {
        Write-Information "Criando Resource Group."
        $resourcegroup = az group create `
                        --name $resourcegroup_name `
                        --location $location `
                        --subscription $subscription `
                        --tags create_by=$valorTagCreateBy | ConvertFrom-Json
    }

    #Service Plan
    Write-Information "Verificando se Service Plan existe."
    $serviceplan = az appservice plan list --resource-group $resourcegroup.name --subscription $subscription --query "[?name==$($servicepla_name)]" | ConvertFrom-Json
    if($serviceplan.count -eq 0){
        Write-Information "Criando ServicePlan."
        $serviceplan = az appservice plan create `
                        --name $servicepla_name `
                        --resource-group $resourcegroup.name `
                        --location $location `
                        --sku "FREE" `
                        --subscription $subscription `
                        --tags create_by=$valorTagCreateBy | ConvertFrom-Json
    }

    #WebApp
    Write-Information "Verificando se Webapp existe."
    $webapp = az webapp list --resource-group $resourcegroup.name --subscription $subscription --query "[?name==$($webapp_name)]" | ConvertFrom-Json
    if($webapp.count -eq 0){
        Write-Information "Criando Webapp."
        $webapp = az webapp create `
                    --name $webapp_name `
                    --resource-group $resourcegroup.name `
                    --plan $serviceplan.id `
                    --subscription $subscription `
                    --tags create_by=$valorTagCreateBy | ConvertFrom-Json
    }

    Write-Output "https://$($webapp.defaultHostName)"

    Write-Information "Script finalizado e infraestrutura criada."

}
catch {
    Write-Error $_.Exception.Message
}