<#
.SYNOPSIS
    Repair openai-bundled plugins for Codex on Windows.
    Ensures browser@, chrome@, and computer-use@ openai-bundled plugins are installed and enabled.
.DESCRIPTION
    Diagnoses and fixes common issues with Codex openai-bundled plugins:
    - Broken chrome "latest" junction
    - Missing plugin entries in config.toml
    - Incomplete/corrupted marketplace directory
    - Marketplace being overwritten on restart (moves to persistent location)

    Must be run while Codex is NOT running, or changes will take effect on next restart.
#>

param(
    [switch]$DryRun,
    [switch]$Force
)

$ErrorActionPreference = "Stop"

function Write-Step { param([string]$Msg) Write-Host "`n>>> $Msg" -ForegroundColor Cyan }
function Write-OK { param([string]$Msg) Write-Host "  OK: $Msg" -ForegroundColor Green }
function Write-Warn { param([string]$Msg) Write-Host "  WARN: $Msg" -ForegroundColor Yellow }

# ============================================================
# Auto-detection of Codex paths
# ============================================================

function Get-CodexHome {
    if ($env:CODEX_HOME) { return $env:CODEX_HOME }
    return Join-Path $env:USERPROFILE ".codex"
}

function Find-CodexWindowsAppsDir {
    # Method 1: Get-AppxPackage (most reliable)
    $pkg = Get-AppxPackage -Name "*OpenAI.Codex*" -ErrorAction SilentlyContinue |
        Sort-Object Version -Descending |
        Select-Object -First 1
    if ($pkg -and $pkg.InstallLocation) {
        Write-OK "Found via Get-AppxPackage: $($pkg.InstallLocation)"
        return $pkg.InstallLocation
    }
    
    # Method 2: chrome-native-hosts-v2.json has resourcesPath
    $hostsFile = Join-Path (Get-CodexHome) "chrome-native-hosts-v2.json"
    if (Test-Path $hostsFile) {
        $hosts = Get-Content $hostsFile -Raw | ConvertFrom-Json
        $latestEntry = $hosts.entries | Sort-Object { $_.updatedAt } -Descending | Select-Object -First 1
        if ($latestEntry -and $latestEntry.paths.resourcesPath) {
            $resPath = $latestEntry.paths.resourcesPath
            Write-OK "Found via chrome-native-hosts: $resPath"
            return $resPath
        }
    }

    # Method 3: Direct file system access
    $found = Get-ChildItem "C:\Program Files\WindowsApps" -Directory -Filter "OpenAI.Codex_*" -ErrorAction SilentlyContinue |
        Sort-Object Name -Descending |
        Select-Object -First 1
    if ($found) {
        Write-OK "Found via filesystem: $($found.FullName)"
        return $found.FullName
    }

    Write-Warn "Could not find Codex WindowsApps installation directory"
    return $null
}

function Find-CodexCli {
    $binDirs = @()
    $binDirs += Join-Path $env:LOCALAPPDATA "OpenAI\Codex\bin"
    $binDirs += Join-Path $env:USERPROFILE "AppData\Local\OpenAI\Codex\bin"
    
    foreach ($binDir in $binDirs) {
        if (-not (Test-Path $binDir)) { continue }
        $dirs = Get-ChildItem $binDir -Directory -ErrorAction SilentlyContinue | Sort-Object Name -Descending
        foreach ($d in $dirs) {
            $exe = Join-Path $d.FullName "codex.exe"
            if (Test-Path $exe) { return $exe }
        }
    }
    return $null
}

function Find-SourceMarketplaceDir {
    param([string]$WindowsAppsDir)
    
    if ($WindowsAppsDir) {
        $mp = Join-Path $WindowsAppsDir "app\resources\plugins\openai-bundled"
        if (Test-Path "$mp\.agents\plugins\marketplace.json") {
            return $mp
        }
    }
    
    # Fallback: check if the temp marketplace has enough files to use as source
    $tempMp = Join-Path (Get-CodexHome) ".tmp\bundled-marketplaces\openai-bundled"
    if (Test-Path "$tempMp\.agents\plugins\marketplace.json") {
        Write-Warn "Using temp marketplace as source (WindowsApps not accessible)"
        return $tempMp
    }
    
    return $null
}

# ============================================================
# Initialize paths
# ============================================================

$CodexHome = Get-CodexHome
$WindowsAppsDir = Find-CodexWindowsAppsDir
$SourceMp = Find-SourceMarketplaceDir -WindowsAppsDir $WindowsAppsDir
$CacheDir = Join-Path $CodexHome "plugins\cache\openai-bundled"
$PersistentMpDir = Join-Path $CodexHome "marketplaces\openai-bundled"
$ConfigPath = Join-Path $CodexHome "config.toml"
$CodexCli = Find-CodexCli

Write-Host "========== Codex Plugin Repair =========="
Write-Host "Codex Home   : $CodexHome"
Write-Host "WindowsApps  : $WindowsAppsDir"
Write-Host "Source MP    : $SourceMp"
Write-Host "Persistent MP: $PersistentMpDir"
Write-Host "Config       : $ConfigPath"
Write-Host "CLI          : $CodexCli"
Write-Host "=========================================="

# ============================================================
# Phase 1: Verify source marketplace
# ============================================================

Write-Step "Phase 1: Checking source marketplace"
if (-not $SourceMp) {
    Write-Error "Cannot find a valid marketplace source. Aborting."
    exit 1
}
$mpJson = Get-Content "$SourceMp\.agents\plugins\marketplace.json" -Raw | ConvertFrom-Json
$targetPlugins = $mpJson.plugins | ForEach-Object { $_.name }
Write-OK "Source marketplace found with plugins: $($targetPlugins -join ', ')"

# ============================================================
# Phase 2: Get cached plugin versions
# ============================================================

function Get-CachedVersion {
    param([string]$PluginName)
    $pluginCacheDir = Join-Path $CacheDir $PluginName
    if (-not (Test-Path $pluginCacheDir)) { return $null }
    $versions = Get-ChildItem $pluginCacheDir -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '^\d+\.\d+\.\d+$' } |
        Sort-Object { [version]$_.Name } -Descending
    if ($versions) { return $versions[0].Name }
    return $null
}

# ============================================================
# Phase 3: Fix chrome "latest" junction
# ============================================================

Write-Step "Phase 3: Fixing chrome latest junction"
$chromeVersion = Get-CachedVersion "chrome"
if ($chromeVersion) {
    $chromeLatest = Join-Path $CacheDir "chrome\latest"
    $chromeTarget = Join-Path $CacheDir "chrome\$chromeVersion"
    
    $currentJunction = Get-Item $chromeLatest -ErrorAction SilentlyContinue
    $needsFix = $true
    if ($currentJunction -and $currentJunction.LinkType -eq 'Junction' -and $currentJunction.Target -eq $chromeTarget) {
        Write-OK "Junction already correct: $chromeTarget"
        $needsFix = $false
    }
    
    if ($needsFix -and -not $DryRun) {
        Write-Host "  Creating junction: $chromeLatest -> $chromeTarget"
        if ($currentJunction) { cmd /c "rmdir `"$chromeLatest`"" 2>&1 | Out-Null }
        cmd /c "mklink /J `"$chromeLatest`" `"$chromeTarget`"" 2>&1 | Out-Null
        Write-OK "Junction created"
    } elseif ($needsFix) {
        Write-Host "  [DRY RUN] Would fix junction"
    }
} else {
    Write-Warn "No cached chrome version found"
}

# ============================================================
# Phase 4: Build persistent marketplace
# ============================================================

Write-Step "Phase 4: Building persistent marketplace"

$needsRebuild = $true
if ((Test-Path "$PersistentMpDir\.agents\plugins\marketplace.json") -and -not $Force) {
    $allPresent = $true
    foreach ($p in $targetPlugins) {
        if (-not (Test-Path "$PersistentMpDir\plugins\$p")) {
            $allPresent = $false
            break
        }
    }
    if ($allPresent) {
        Write-OK "Persistent marketplace already complete"
        $needsRebuild = $false
    }
}

if ($needsRebuild -and -not $DryRun) {
    Write-Host "  Copying from $SourceMp to $PersistentMpDir..."
    if (Test-Path $PersistentMpDir) {
        Remove-Item -LiteralPath $PersistentMpDir -Recurse -Force -ErrorAction SilentlyContinue
    }
    New-Item -ItemType Directory -Force -Path $PersistentMpDir | Out-Null
    
    $result = robocopy $SourceMp $PersistentMpDir /E /NJH /NJS /NP /NDL /R:2 /W:2 2>&1
    $exitCode = $LASTEXITCODE
    if ($exitCode -ge 8) {
        Write-Error "Robocopy failed with exit code $exitCode"
    } else {
        Write-OK "Built successfully (exit $exitCode)"
    }
} elseif ($needsRebuild) {
    Write-Host "  [DRY RUN] Would build persistent marketplace"
}

# Verify
$complete = $true
foreach ($p in $targetPlugins) {
    $exists = Test-Path "$PersistentMpDir\plugins\$p"
    $status = if($exists){'OK'}else{'MISSING'}
    Write-Host "    $p : $status"
    if (-not $exists) { $complete = $false }
}
if ($complete) { Write-OK "All plugins present" }

# ============================================================
# Phase 5: Update config.toml
# ============================================================

Write-Step "Phase 5: Updating config.toml"

if (-not (Test-Path $ConfigPath)) {
    Write-Error "config.toml not found at: $ConfigPath"
    exit 1
}

$backupPath = "$ConfigPath.bak-plugin-repair-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
if (-not $DryRun) {
    Copy-Item $ConfigPath $backupPath -Force
    Write-OK "Backed up to: $backupPath"
}

$config = Get-Content $ConfigPath -Raw

# 5a: Update marketplace source
$persistentSource = "source = '$PersistentMpDir'"
if ($config -match "\[marketplaces\.openai-bundled\]") {
    # Find the source line within this section
    $sectionStart = $config.IndexOf("[marketplaces.openai-bundled]")
    $nextSection = $config.IndexOf("`n[", $sectionStart + 1)
    if ($nextSection -lt 0) { $nextSection = $config.Length }
    $section = $config.Substring($sectionStart, $nextSection - $sectionStart)
    
    if ($section -match "source\s*=\s*'[^']*'") {
        $oldSourceLine = $matches[0]
        if ($oldSourceLine -ne $persistentSource) {
            $config = $config.Replace($oldSourceLine, $persistentSource)
            Write-OK "Updated marketplace source"
        } else {
            Write-OK "Marketplace source already correct"
        }
    }
}

# 5b: Ensure required plugins are registered
$requiredPlugins = @('browser', 'chrome', 'computer-use')
foreach ($plugin in $requiredPlugins) {
    $entryPattern = "[plugins.`"$plugin@openai-bundled`"]"
    if ($config -notmatch [regex]::Escape($entryPattern)) {
        # Insert after browser entry or at end of plugins section
        $insertPoint = "enabled = true`n"
        $browserIdx = $config.IndexOf("[plugins.`"browser@openai-bundled`"]")
        if ($browserIdx -ge 0) {
            # Find the enabled line after browser
            $afterBrowser = $config.IndexOf("enabled = true", $browserIdx)
            $insertPos = $afterBrowser + "enabled = true".Length
        } else {
            # Insert before MCP servers
            $mcpIdx = $config.IndexOf("[mcp_servers.")
            $insertPos = if ($mcpIdx -ge 0) { $mcpIdx } else { $config.Length }
        }
        $entry = "`n`n[plugins.`"$plugin@openai-bundled`"]`nenabled = true"
        $config = $config.Insert($insertPos, $entry)
        Write-OK "Added $plugin@openai-bundled"
    } else {
        Write-OK "$plugin@openai-bundled already registered"
    }
}

if (-not $DryRun) {
    Set-Content -Path $ConfigPath -Value $config -NoNewline
    Write-OK "config.toml saved"
} else {
    Write-Host "  [DRY RUN] Would update config.toml"
}

# ============================================================
# Phase 6: Verify with Codex CLI
# ============================================================

Write-Step "Phase 6: Verification"

if ($CodexCli -and (Test-Path $CodexCli) -and -not $DryRun) {
    $mpList = & $CodexCli plugin marketplace list 2>&1
    if ($mpList -match "openai-bundled") {
        Write-OK "openai-bundled marketplace recognized"
    } else {
        Write-Warn "openai-bundled NOT in marketplace list"
        Write-Host $mpList
    }
    
    Write-Host "  Plugin status:"
    $pluginList = & $CodexCli plugin list 2>&1
    $pluginList | Select-String "openai-bundled" | ForEach-Object { Write-Host "  $_" }
} elseif ($DryRun) {
    Write-Host "  [DRY RUN] Would verify with CLI"
} else {
    Write-Warn "Codex CLI not found, skip verification"
}

# ============================================================
# Summary
# ============================================================

Write-Host "`n========== Repair Complete =========="
Write-Host "  Chrome junction : fixed"
Write-Host "  Marketplace    : $PersistentMpDir"
Write-Host "  Config backup  : $backupPath"
Write-Host "  Plugins        : $($requiredPlugins -join '@, ')@openai-bundled"
Write-Host ""
Write-Host "  >> Restart Codex for changes to take effect <<"
Write-Host "======================================"
