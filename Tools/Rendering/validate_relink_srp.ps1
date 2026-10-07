param(
    [string]$UnityEditorPath = 'D:\Hub\Editor\6000.3.10f1\Editor\Unity.exe'
)
$ErrorActionPreference = 'Stop'
$workspace = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
$validationProject = Join-Path $workspace 'Temp\RelinkDeferredValidation'
$logPath = Join-Path $workspace 'Temp\RelinkDeferredValidation.log'
if (-not (Test-Path -LiteralPath $UnityEditorPath -PathType Leaf)) { throw "Unity editor not found: $UnityEditorPath" }
if (Test-Path -LiteralPath (Join-Path $validationProject 'Temp\UnityLockfile')) {
    throw 'The isolated validation project is already open. Close that project before running validation.'
}
foreach ($folder in @('Assets', 'Packages', 'ProjectSettings')) {
    New-Item -ItemType Directory -Path (Join-Path $validationProject $folder) -Force | Out-Null
}
Copy-Item -LiteralPath (Join-Path $workspace 'Assets\RelinkStyle') -Destination (Join-Path $validationProject 'Assets') -Recurse -Force
Copy-Item -LiteralPath (Join-Path $workspace 'ProjectSettings\ProjectVersion.txt') -Destination (Join-Path $validationProject 'ProjectSettings\ProjectVersion.txt') -Force
Set-Content -LiteralPath (Join-Path $validationProject 'Packages\manifest.json') -Value '{"dependencies":{}}' -Encoding utf8
$started = [DateTime]::UtcNow
$arguments = @('-batchmode', '-force-d3d11', '-noUpm', '-projectPath', ('"' + $validationProject + '"'),
    '-executeMethod', 'MyMission.Rendering.Editor.RelinkValidation.Run', '-logFile', ('"' + $logPath + '"'))
Write-Output "Running standalone SRP GPU validation in $validationProject"
$process = Start-Process -FilePath $UnityEditorPath -ArgumentList $arguments -WindowStyle Hidden -PassThru
$process.WaitForExit()
$resultPath = Join-Path $validationProject 'Validation\result.txt'
if ($process.ExitCode -ne 0 -or -not (Test-Path -LiteralPath $resultPath)) {
    throw "Unity validation failed (exit $($process.ExitCode)). Inspect $logPath"
}
if ((Get-Item -LiteralPath $resultPath).LastWriteTimeUtc -lt $started -or (Get-Content -LiteralPath $resultPath -Raw) -notmatch '^PASS:') {
    throw "No fresh passing result was produced. Inspect $resultPath and $logPath"
}
$contractPath = Join-Path $validationProject 'Validation\contract.txt'
$freshContract = Test-Path -LiteralPath $contractPath
if ($freshContract) {
    $freshContract = ((Get-Item -LiteralPath $contractPath).LastWriteTimeUtc -ge $started) -and ((Get-Content -LiteralPath $contractPath -Raw) -match 'PASS: 17 numeric GPU contract checks\.')
}
if (-not $freshContract) {
    throw 'No fresh deferred GPU contract result was produced.'
}
if (Select-String -LiteralPath $logPath -Pattern 'Shader error|error CS\d+' -Quiet) { throw "Compiler errors in $logPath" }
$evidence = Join-Path $workspace 'Documentation\Rendering\Evidence\srp-deferred'
New-Item -ItemType Directory -Path $evidence -Force | Out-Null
$files = @('result.txt', 'contract.txt', 'Environment.png', 'MaterialReference.png', 'PrototypeForward.png', 'Normals.png', 'Depth.png',
    'DeferredView5.png', 'DeferredView6.png', 'DeferredView7.png', 'DeferredView8.png', 'DeferredView9.png',
    'DeferredView10.png', 'DeferredView11.png', 'DeferredView12.png')
foreach ($file in $files) {
    Copy-Item -LiteralPath (Join-Path $validationProject ('Validation\' + $file)) -Destination (Join-Path $evidence $file) -Force
}
$generated = Join-Path $workspace 'Assets\RelinkStyle\Generated'
$validatedGenerated = Join-Path $validationProject 'Assets\RelinkStyle\Generated'
foreach ($item in @('Reference', 'Reference.meta', 'RelinkMaterialReference.unity', 'RelinkMaterialReference.unity.meta')) {
    Copy-Item -LiteralPath (Join-Path $validatedGenerated $item) -Destination $generated -Recurse -Force
}
$sourcePaths = @('Assets/RelinkStyle/Runtime/RelinkRenderPipeline.cs', 'Assets/RelinkStyle/Runtime/RelinkDeferredRenderer.cs',
    'Assets/RelinkStyle/Runtime/RelinkRenderPipelineAsset.cs', 'Assets/RelinkStyle/Shaders/RelinkEnvironment.shader',
    'Assets/RelinkStyle/Shaders/RelinkEnvironment.cginc', 'Assets/RelinkStyle/Shaders/RelinkDeferred.shader',
    'Assets/RelinkStyle/Shaders/RelinkSourceLighting.cginc', 'Assets/RelinkStyle/Shaders/RelinkComposite.shader',
    'Assets/RelinkStyle/Shaders/RelinkSky.shader', 'Assets/RelinkStyle/Editor/RelinkValidation.cs',
    'Assets/RelinkStyle/Editor/RelinkDeferredValidation.cs', 'Assets/RelinkStyle/Editor/RelinkReferenceSceneTools.cs',
    'Assets/RelinkStyle/Editor/RelinkSceneTools.cs', 'Assets/RelinkStyle/Editor/RelinkDemoSceneSetup.cs',
    'Assets/RelinkStyle/Generated/RelinkScenePipeline.asset')
$hashes = [ordered]@{}
foreach ($path in $sourcePaths) { $hashes[$path] = (Get-FileHash -LiteralPath (Join-Path $workspace $path) -Algorithm SHA256).Hash }
$checks = Select-String -LiteralPath $logPath -Pattern 'RELINK_CHECK|RELINK_VALIDATION_PASS|RELINK_DEMO_SETUP_PASS' | ForEach-Object { $_.Line }
$manifest = [ordered]@{
    validated_at_utc = [DateTime]::UtcNow.ToString('o')
    unity_version = (Get-Content -LiteralPath (Join-Path $workspace 'ProjectSettings\ProjectVersion.txt') -TotalCount 1)
    api = 'Direct3D11'; package_dependencies = @(); reference_capture = 'standard_d3d11_frame10803.rdc'
    rendering_path = 'EvidenceDeferred'; result = (Get-Content -LiteralPath $resultPath -Raw).Trim()
    checks = @($checks); source_sha256 = $hashes
}
$manifest | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath (Join-Path $evidence 'manifest.json') -Encoding utf8
Write-Output "PASS. Evidence: $evidence"
