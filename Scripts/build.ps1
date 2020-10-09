[cmdletbinding()]
<#
    .PARAMETER outDir
    Diretório de saída dos artefatos compilados.
    .PARAMETER projDir
    Diretório do projeto onde esta o arquivo .sln.
    .PARAMETER solutionName
    Nome do arquivo .sln.
    .PARAMETER projectName
    Nome do projeto ex.: Nibo.DevOpsChallenge.
    .PARAMETER packageZip
    Nome do arquivo zip com os artefafos compactados.
    .PARAMETER msbuildDir
    Diretório do MSBuild.exe.
#>
param(
    $outDir,
    $projDir,
    $solutionName,
    $projectName,
    $packageZip,
    $msbuildDir
)
try {
    
    Write-Information "Iniciando build aplicação."

    New-Alias msdeploy $msbuildDir

    msdeploy "$projDir\$solutionName" /p:DeployOnBuild=true /p:OutDir=$outDir /p:Configuration=release

    Compress-Archive -path "$outDir\_PublishedWebsites\$projectName\*" `
                    -CompressionLevel "Fastest" `
                    -DestinationPath "$outDir\$projectName.zip" -Force

    Write-Output "OutDir=$outDir\$packageZip"

    Write-Information "Fim build aplicação."

}
catch {
    Write-Error $_.Exception.Message
}