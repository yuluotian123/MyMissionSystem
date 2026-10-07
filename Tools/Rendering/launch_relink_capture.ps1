<#
Launch-only experiment. Never closes an existing game or modifies game files.
Baseline launches without injection. StandardD3D11 temporarily sets RenderDoc's
NV.BlockNVAPI flag to test whether the engine has a standard draw fallback.
This combination produced complete scene captures on this installation; details
and scope of validation are in Documentation/Rendering/Relink-Reverse-Engineering.md.
#>
[CmdletBinding()]
param(
    [ValidateSet('Baseline', 'StandardD3D11')]
    [string]$Mode = 'Baseline',
    [string]$GamePath = 'D:\Steam\steamapps\common\Granblue Fantasy Relink\granblue_fantasy_relink.exe',
    [string]$RenderDocDirectory = '',
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'
$workspacePath = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
if (-not $RenderDocDirectory) {
    $RenderDocDirectory = Join-Path $workspacePath 'Temp/RelinkTools/RenderDoc/RenderDoc_1.46_64'
}
$captureDirectory = Join-Path $workspacePath 'Captures/Relink'
$configPath = Join-Path $env:APPDATA 'renderdoc/renderdoc.conf'
$captureTool = Join-Path $RenderDocDirectory 'renderdoccmd.exe'
$gameDirectory = Split-Path -Parent $GamePath
if (-not (Test-Path -LiteralPath $GamePath -PathType Leaf)) { throw 'Game executable not found.' }
if ($Mode -eq 'StandardD3D11' -and -not (Test-Path -LiteralPath $captureTool -PathType Leaf)) {
    throw 'RenderDoc executable not found. Supply -RenderDocDirectory.'
}
if ($GamePath.Contains('"') -or $gameDirectory.Contains('"') -or $captureDirectory.Contains('"')) {
    throw 'Paths containing quotes are not supported.'
}
if ($DryRun) {
    [pscustomobject]@{ Mode = $Mode; Game = $GamePath; Captures = $captureDirectory;
        TemporaryConfig = $(if ($Mode -eq 'StandardD3D11') { $configPath } else { 'none' });
        CaptureAllCommandLists = ($Mode -eq 'StandardD3D11'); GameWillBeClosed = $false }
    return
}
if (Get-Process -Name 'granblue_fantasy_relink' -ErrorAction SilentlyContinue) {
    throw 'The game is running. Exit normally after saving, then rerun. This script will not close it.'
}

$oldAppId = $env:SteamAppId
$oldGameId = $env:SteamGameId
$configChanged = $false
try {
    $env:SteamAppId = '881020'
    $env:SteamGameId = '881020'
    if ($Mode -eq 'Baseline') {
        Start-Process -FilePath $GamePath -WorkingDirectory $gameDirectory -WindowStyle Hidden
        return
    }
    [xml]$config = Get-Content -LiteralPath $configPath -Raw
    $node = $config.SelectSingleNode('/config/NV/BlockNVAPI')
    if (-not $node) { throw 'RenderDoc NV.BlockNVAPI setting missing; do not invent a replacement config.' }
    $oldBlockValue = $node.InnerText
    $originalBytes = [IO.File]::ReadAllBytes($configPath)
    New-Item -ItemType Directory -Path $captureDirectory -Force | Out-Null
    [IO.File]::WriteAllBytes((Join-Path $captureDirectory 'renderdoc-config-before-experiment.xml'), $originalBytes)
    $node.InnerText = 'true'
    $config.Save($configPath)
    $patchedBytes = [IO.File]::ReadAllBytes($configPath)
    $configChanged = $true
    $arguments = @('capture', '--opt-hook-children', '--opt-disallow-fullscreen',
        '--opt-capture-all-cmd-lists', '-d', ('"' + $gameDirectory + '"'),
        '-c', ('"' + (Join-Path $captureDirectory 'standard_d3d11') + '"'), ('"' + $GamePath + '"'))
    $launcher = Start-Process -FilePath $captureTool -ArgumentList $arguments -WindowStyle Hidden -PassThru
    if (-not $launcher.WaitForExit(15000)) { throw 'Launcher did not finish in 15 seconds; verify the diagnostic log before capturing.' }
    # The capture command returns its target-control identifier on success,
    # rather than zero (renderdoccmd.cpp, CaptureCommand::Execute).
    $targetPort = $launcher.ExitCode
    if ($targetPort -lt 1024 -or $targetPort -gt 65535) {
        throw "RenderDoc returned unexpected target identifier or error code $targetPort."
    }
    [pscustomobject]@{ Mode = $Mode; TargetPort = $targetPort; Captures = $captureDirectory }
    Write-Output 'Game launched. Verify NV.BlockNVAPI=True in the new RenderDoc diagnostic log.'
    Write-Output 'Check that buildings, ground and characters are visible before requesting a frame.'
}
finally {
    $env:SteamAppId = $oldAppId
    $env:SteamGameId = $oldGameId
    if ($configChanged) {
        $currentBytes = [IO.File]::ReadAllBytes($configPath)
        if ([Convert]::ToBase64String($currentBytes) -eq [Convert]::ToBase64String($patchedBytes)) {
            [IO.File]::WriteAllBytes($configPath, $originalBytes)
        } else {
            # Preserve any independent changes made during the experiment.
            [xml]$currentConfig = Get-Content -LiteralPath $configPath -Raw
            $currentNode = $currentConfig.SelectSingleNode('/config/NV/BlockNVAPI')
            if (-not $currentNode) { throw 'Cannot restore NV.BlockNVAPI; use the saved config backup.' }
            $currentNode.InnerText = $oldBlockValue
            $currentConfig.Save($configPath)
        }
    }
}
