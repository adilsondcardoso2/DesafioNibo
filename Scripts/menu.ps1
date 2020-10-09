write-information "Autenticacao Azure."
#az login

$msbuildDir = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\MSBuild\Current\Bin\MSBuild.exe"
$projDir = "C:\Repos-adilson-cardoso\NiboDevOpsChallenge\ProjetoNibo"
$projectName = "Nibo.DevOpsChallenge"
$solutionName = "Nibo.DevOpsChallenge.sln"
$packageuZip = "Nibo.DevOpsChallenge.zip"
$outDir = "C:\temp\nibo"
$subscription = ""
$resourcegroup_name = "RG_ADC"
$location = "brazilsouth"
$servicepla_name = "mysvcplanadc"
$webapp_name = "mywebappadc"

.\build.ps1 -outDir $outDir -projDir $projDir -solutionName $solutionName -projectName $projectName -packageZip $packageuZip -msbuildDir $msbuildDir

.\infrastructure.ps1 -subscription $subscription -resourcegroup_name $resourcegroup_name -location $location -servicepla_name $servicepla_name -webapp_name $webapp_name

.\deployment.ps1 -outDir $outDir -packageZip $packageuZip -subscription $subscription -resourcegroup_name $resourcegroup_name -webapp_name $webapp_name