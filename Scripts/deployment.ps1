[cmdletbinding()]
<#
    .PARAMETER outDir
    Diretório de saída dos artefatos compilados.
    .PARAMETER packageZip
    Nome do arquivo zip com os artefafos compactados.
    .PARAMETER subscription
    ID da assinatura no Azure.
    .PARAMETER resourcegroup_name
    Nome do resource group.
    .PARAMETER webapp_name
    Nome do webapp.
#>
param(
    $outDir,
    $packageZip,
    $subscription,
    $resourcegroup_name,
    $webapp_name
)

try {
    
    Write-Information "Iniciando publicação."

    az webapp deployment source config-zip `
        --name $webapp_name `
        --resource-group $resourcegroup_name `
        --subscription $subscription `
        --src "$outDir\$packageZip"

    Write-Information "Fim publicação."

}
catch {
    Write-Error $_.Exception.Message    
}
