param([switch]$Rebuild)
$ErrorActionPreference='Stop'
$workspace=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
if($Rebuild) {& (Join-Path $PSScriptRoot 'validate_relink_town.ps1') -Method 'MyMission.Rendering.Editor.RelinkTownSceneTools.BuildBenchmarkPlayer'}
$player=Join-Path $workspace 'Temp\RelinkTownValidation\Player\RelinkTown.exe'
if(-not (Test-Path -LiteralPath $player)) {throw 'BuildBenchmarkPlayer must complete first, or use -Rebuild.'}
if(Get-Process -Name RelinkTown -ErrorAction SilentlyContinue) {throw 'The town player is already running.'}
$output=Join-Path $workspace 'Temp\RelinkDynamicValidation'
New-Item -ItemType Directory -Path $output -Force | Out-Null
$started=[DateTime]::UtcNow
$process=Start-Process -FilePath $player -ArgumentList @('-batchmode','-force-d3d11','-screen-fullscreen','0','-screen-width','1280','-screen-height','720',
    '-relink-dynamic-only','-relink-output',('"'+$output+'"'),'-logFile',('"'+(Join-Path $output 'player.log')+'"')) -WindowStyle Hidden -PassThru
$process.WaitForExit()
$report=Join-Path $output 'dynamic-contract.json'
if(-not (Test-Path -LiteralPath $report) -or (Get-Item -LiteralPath $report).LastWriteTimeUtc -lt $started) {throw 'No fresh dynamic validation result.'}
$data=Get-Content -LiteralPath $report -Raw | ConvertFrom-Json
if($process.ExitCode -ne 0 -or -not $data.passed -or @($data.checks).Count -ne 7) {throw 'Dynamic GPU validation failed. Inspect Temp/RelinkDynamicValidation.'}
$evidence=Join-Path $workspace 'Documentation\Rendering\Evidence\srp-town'
Copy-Item -LiteralPath $report -Destination $evidence -Force
Get-ChildItem -LiteralPath (Join-Path $workspace 'Temp\RelinkTownValidation\Assets\RelinkStyle\Runtime') -Filter '*.meta' | ForEach-Object {
    $destination=Join-Path (Join-Path $workspace 'Assets\RelinkStyle\Runtime') $_.Name
    if(-not (Test-Path -LiteralPath $destination)) {Copy-Item -LiteralPath $_.FullName -Destination $destination}
}
Write-Output 'PASS: 7 dynamic GPU checks published, across actual Player frames.'
