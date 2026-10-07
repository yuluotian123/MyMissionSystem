param([string]$Method = 'MyMission.Rendering.Editor.RelinkTownSceneTools.InventoryAssets')
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$townProject = Join-Path $workspace 'Temp\RelinkTownValidation'
if (Test-Path -LiteralPath (Join-Path $townProject 'Temp\UnityLockfile')) { throw 'Town validation project is already open.' }
foreach ($folder in @('Assets','Packages','ProjectSettings')) {
    New-Item -ItemType Directory -Path (Join-Path $townProject $folder) -Force | Out-Null
}
Copy-Item -LiteralPath (Join-Path $workspace 'Assets\RelinkStyle') -Destination (Join-Path $townProject 'Assets') -Recurse -Force
$artFolders = @(
'Assets/Resources/Art/Test/八方旅人1/建筑1/MbdMD_Co_T_Plain_L_A_Build_02',
'Assets/Resources/Art/Test/八方旅人1/建筑1/MbdMD_Co_T_River_L_A_WeaponShop',
'Assets/Resources/Art/Test/八方旅人1/建筑1/ObjMD_Arch_A',
'Assets/Resources/Art/Test/八方旅人1/建筑1/ObjMD_Church_A',
'Assets/Resources/Art/Test/八方旅人2/建筑/EnvBdgMD_City_C_Outdoor_4W4D_A',
'Assets/Resources/Art/Test/八方旅人2/建筑/EnvBdgMD_City_D_Outdoor_4W5D_2F',
'Assets/Resources/Art/Test/八方旅人2/建筑/EnvBdgMD_Plain_A_Outdoor_Entrance_A',
'Assets/Resources/Art/Test/八方旅人2/建筑组件/EnvObjMD_Stairs_A_Large',
'Assets/Resources/Art/Test/八方旅人2/植物_八方旅人2/树灌木/EnvFldMD_Tree_A_Forest_LA',
'Assets/Resources/Art/Test/八方旅人2/植物_八方旅人2/树灌木/EnvFldMD_Tree_E_MA_LOD0',
'Assets/Resources/Art/Test/八方旅人2/植物_八方旅人2/树灌木/EnvFldMD_Tree_I_L',
'Assets/Resources/Art/Test/八方旅人2/山石_八方旅人2/EnvFldMD_FoliageStone_A_MA')
foreach ($relative in $artFolders) {
    $source = Join-Path $workspace $relative
    $destination = Join-Path $townProject $relative
    New-Item -ItemType Directory -Path $destination -Force | Out-Null
    Get-ChildItem -LiteralPath $source -File | Where-Object { $_.Name -notmatch '\.max(\.meta)?$' } | ForEach-Object {
        Copy-Item -LiteralPath $_.FullName -Destination $destination -Force
    }
    if (Test-Path -LiteralPath ($source + '.meta')) { Copy-Item -LiteralPath ($source + '.meta') -Destination ($destination + '.meta') -Force }
}
Copy-Item -LiteralPath (Join-Path $workspace 'ProjectSettings\ProjectVersion.txt') -Destination (Join-Path $townProject 'ProjectSettings\ProjectVersion.txt') -Force
Set-Content -LiteralPath (Join-Path $townProject 'Packages\manifest.json') -Value '{"dependencies":{}}' -Encoding utf8
$unityArgs = @('-batchmode','-force-d3d11','-noUpm','-projectPath',('"'+$townProject+'"'),'-executeMethod',$Method,'-logFile',('"'+(Join-Path $workspace 'Temp\RelinkTownValidation.log')+'"'))
$started = [DateTime]::UtcNow
$process = Start-Process -FilePath 'D:\Hub\Editor\6000.3.10f1\Editor\Unity.exe' -ArgumentList $unityArgs -WindowStyle Hidden -PassThru
$process.WaitForExit()
if ($process.ExitCode -ne 0) { throw "Town validation failed: $($process.ExitCode). See Temp/RelinkTownValidation.log" }
if ($Method -eq 'MyMission.Rendering.Editor.RelinkTownSceneTools.ValidateTown') {
    $result = Join-Path $townProject 'Validation\town-result.txt'
    $contract = Join-Path $townProject 'Validation\advanced-contract.txt'
    foreach ($file in @($result,$contract)) {
        if (-not (Test-Path -LiteralPath $file) -or (Get-Item -LiteralPath $file).LastWriteTimeUtc -lt $started) { throw "No fresh validation result: $file" }
    }
    if ((Get-Content -LiteralPath $result -Raw) -notmatch '^PASS:' -or (Get-Content -LiteralPath $contract -Raw) -match 'FAIL:' -or @(Select-String -LiteralPath $contract -Pattern '^PASS:').Count -lt 18) { throw 'Town GPU acceptance did not pass.' }
    if (Select-String -LiteralPath (Join-Path $workspace 'Temp\RelinkTownValidation.log') -Pattern 'Shader error|error CS\d+' -Quiet) { throw 'Town compiler errors detected.' }
    $evidence = Join-Path $workspace 'Documentation\Rendering\Evidence\srp-town'
    New-Item -ItemType Directory -Path $evidence -Force | Out-Null
    foreach ($item in @('Town-MarketStreet.png','Town-Terrace.png','Town-Plaza.png','advanced-contract.txt','local-shadow-debug.txt','town-result.txt')) {
        Copy-Item -LiteralPath (Join-Path $townProject ('Validation\'+$item)) -Destination $evidence -Force
    }
    Get-ChildItem -LiteralPath (Join-Path $townProject 'Validation') -Filter 'Town-View*.png' | ForEach-Object { Copy-Item -LiteralPath $_.FullName -Destination $evidence -Force }
    # Keep the generated scene's MonoScript/Shader GUIDs on its first import in the real project.
    $validatedStyle = Join-Path $townProject 'Assets\RelinkStyle'
    Get-ChildItem -LiteralPath $validatedStyle -Filter '*.meta' -File -Recurse | ForEach-Object {
        $relative = $_.FullName.Substring($validatedStyle.Length+1)
        $destination = Join-Path (Join-Path $workspace 'Assets\RelinkStyle') $relative
        if (-not (Test-Path -LiteralPath $destination)) {
            New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
            Copy-Item -LiteralPath $_.FullName -Destination $destination
        }
    }
    foreach ($item in @('Town','Town.meta','RelinkTown.unity','RelinkTown.unity.meta','RelinkTownPipeline.asset','RelinkTownPipeline.asset.meta')) {
        Copy-Item -LiteralPath (Join-Path $validatedStyle ('Generated\'+$item)) -Destination (Join-Path $workspace 'Assets\RelinkStyle\Generated') -Recurse -Force
    }
    $hashes=[ordered]@{}
    Get-ChildItem -LiteralPath (Join-Path $workspace 'Assets\RelinkStyle') -File -Recurse | Where-Object { $_.Extension -in @('.cs','.shader','.cginc','.compute') } | ForEach-Object {
        $hashes[$_.FullName.Substring($workspace.Length+1).Replace('\','/')] = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash
    }
    [ordered]@{utc=[DateTime]::UtcNow.ToString('o');result=(Get-Content -LiteralPath $result -Raw).Trim();contracts=@(Get-Content -LiteralPath $contract);api='Direct3D11';package_dependencies=@();source_sha256=$hashes} |
        ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $evidence 'manifest.json') -Encoding utf8
    Write-Output "PASS. Scene and evidence published to $workspace"
}
Write-Output "Completed $Method in $townProject"
