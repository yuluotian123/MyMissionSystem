param(
    [string]$OutputDirectory,
    [string]$RenderDocDirectory,
    [switch]$SkipProfiling
)
$ErrorActionPreference='Stop'
$workspace=[IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..'))
if(-not $OutputDirectory) {$OutputDirectory=Join-Path $workspace ('Captures\SRP-Town-'+[DateTime]::Now.ToString('yyyyMMdd-HHmmss'))}
if(-not $RenderDocDirectory) {$RenderDocDirectory=Join-Path $workspace 'Temp\RelinkTools\RenderDoc\RenderDoc_1.46_64'}
$player=Join-Path $workspace 'Temp\RelinkTownValidation\Player\RelinkTown.exe'
if(-not (Test-Path -LiteralPath $player)) {throw 'BuildBenchmarkPlayer must complete first.'}
if(Get-Process -Name RelinkTown -ErrorAction SilentlyContinue) {throw 'The town validation player is already running.'}
New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
$started=[DateTime]::UtcNow
$arguments=@('capture','--opt-disallow-fullscreen','--opt-capture-all-cmd-lists','-c',('"'+(Join-Path $OutputDirectory 'town')+'"'),('"'+$player+'"'),
    '-batchmode','-force-d3d11','-screen-fullscreen','0','-screen-width','1280','-screen-height','720','-relink-output',('"'+$OutputDirectory+'"'),'-logFile',('"'+(Join-Path $OutputDirectory 'player.log')+'"'))
$launch=Start-Process -FilePath (Join-Path $RenderDocDirectory 'renderdoccmd.exe') -ArgumentList $arguments -WindowStyle Hidden -PassThru
$launch.WaitForExit()
# renderdoccmd returns its target ID, rather than a conventional zero success code.
$report=Join-Path $OutputDirectory 'performance.json'
$deadline=[DateTime]::UtcNow.AddMinutes(5)
while(-not (Test-Path -LiteralPath $report) -or (Get-Item -LiteralPath $report).LastWriteTimeUtc -lt $started) {
    if([DateTime]::UtcNow -gt $deadline) {throw 'No fresh benchmark result within five minutes. Inspect player.log.'}
    Start-Sleep -Milliseconds 250
}
$manifest=@()
foreach($resolution in @('1280x720','1920x1080','2560x1440')) {
    $rdc=Join-Path $OutputDirectory ('Native-'+$resolution+'_capture.rdc')
    if(-not (Test-Path -LiteralPath $rdc) -or (Get-Item -LiteralPath $rdc).LastWriteTimeUtc -lt $started) {throw ('No fresh RenderDoc capture '+$resolution)}
    $item=[ordered]@{resolution=$resolution;rdc=[IO.Path]::GetFileName($rdc);bytes=(Get-Item -LiteralPath $rdc).Length;sha256=(Get-FileHash -LiteralPath $rdc -Algorithm SHA256).Hash}
    if(-not $SkipProfiling) {
        $env:RELINK_TOWN_RDC=$rdc
        $env:RELINK_TOWN_PROFILE_OUTPUT=Join-Path $OutputDirectory ('GPU-'+$resolution+'.json')
        $profile=Start-Process -FilePath (Join-Path $RenderDocDirectory 'qrenderdoc.exe') -ArgumentList @('--python',('"'+(Join-Path $PSScriptRoot 'profile_relink_town.py')+'"')) -WindowStyle Hidden -PassThru
        $profile.WaitForExit()
        $timing=Get-Content -LiteralPath $env:RELINK_TOWN_PROFILE_OUTPUT -Raw | ConvertFrom-Json
        if($timing.state -ne 'complete') {throw ('GPU replay measurement failed '+$resolution)}
        $item['gpu_replay_median_ms']=$timing.gpu_event_sum_median_ms
    }
    $manifest+=$item
}
$manifest | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $OutputDirectory 'capture-manifest.json') -Encoding utf8
Write-Output ('Town captures completed: '+$OutputDirectory)
