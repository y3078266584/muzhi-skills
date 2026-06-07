<#
.SYNOPSIS
    Clean up orphaned Codex session files whose project directories no longer exist.
.DESCRIPTION
    Scans all session .jsonl files under $env:USERPROFILE\.codex\sessions, extracts the
    cwd (project path) from each, and deletes sessions where the project no longer exists
    on disk. Also removes empty date subdirectories.
#>

$ErrorActionPreference = "Stop"
$sessionsRoot = Join-Path $env:USERPROFILE ".codex\sessions"

if (-not (Test-Path $sessionsRoot)) {
    Write-Host "Sessions directory not found: $sessionsRoot"
    exit 0
}

Write-Host "=== Scanning Codex sessions ===" -ForegroundColor Cyan

# Collect all session files and their cwd
$sessionFiles = Get-ChildItem -Path $sessionsRoot -Recurse -Filter "*.jsonl" -ErrorAction SilentlyContinue
$totalFiles = $sessionFiles.Count
Write-Host "Found $totalFiles session file(s).`n"

$toDelete = @()
$projectCounts = @{}
$orphanedCwds = @{}
$existingCwds = @{}

foreach ($file in $sessionFiles) {
    $line = Get-Content $file.FullName -TotalCount 1 -ErrorAction SilentlyContinue
    if ($line -match '"cwd":"([^"]+)"') {
        $cwd = $matches[1] -replace '\\\\', '\'

        if (Test-Path $cwd) {
            $existingCwds[$cwd] = $true
        } else {
            $toDelete += $file
            $orphanedCwds[$cwd] = $true
            $projectCounts[$cwd] += 1
        }
    }
}

# Report findings
if ($toDelete.Count -eq 0) {
    Write-Host "No orphaned sessions found. All $($existingCwds.Count) project(s) still exist." -ForegroundColor Green
    exit 0
}

Write-Host "=== Orphaned projects (directory no longer exists) ===" -ForegroundColor Yellow
foreach ($cwd in ($projectCounts.Keys | Sort-Object)) {
    Write-Host "  [$($projectCounts[$cwd]) session(s)] $cwd" -ForegroundColor DarkYellow
}

Write-Host "`n=== Active projects (will keep) ===" -ForegroundColor Green
foreach ($cwd in ($existingCwds.Keys | Sort-Object)) {
    Write-Host "  $cwd"
}

Write-Host "`nWill delete $($toDelete.Count) orphaned session file(s)." -ForegroundColor Yellow

# Delete orphaned sessions
$deleted = 0
foreach ($file in $toDelete) {
    try {
        Remove-Item -LiteralPath $file.FullName -Force -ErrorAction Stop
        $deleted++
    } catch {
        Write-Host "  WARNING: Could not delete $($file.FullName): $_" -ForegroundColor Red
    }
}

Write-Host "Deleted $deleted session file(s)." -ForegroundColor Green

# Clean up empty directories
Write-Host "`n=== Cleaning empty directories ===" -ForegroundColor Cyan
$emptyDirs = Get-ChildItem -Path $sessionsRoot -Recurse -Directory -ErrorAction SilentlyContinue |
    Where-Object { (Get-ChildItem $_.FullName -File -Recurse -ErrorAction SilentlyContinue | Measure-Object).Count -eq 0 } |
    Sort-Object FullName -Descending

foreach ($dir in $emptyDirs) {
    try {
        Remove-Item -LiteralPath $dir.FullName -Force -ErrorAction Stop
        Write-Host "  Removed empty: $($dir.FullName)"
    } catch {
        Write-Host "  WARNING: Could not remove $($dir.FullName): $_" -ForegroundColor Red
    }
}

# Final summary
$remaining = @(Get-ChildItem -Path $sessionsRoot -Recurse -Filter "*.jsonl" -ErrorAction SilentlyContinue)
Write-Host "`n=== Done ===" -ForegroundColor Cyan
Write-Host "Deleted: $deleted session(s) from $($orphanedCwds.Count) orphaned project(s)" -ForegroundColor Green
Write-Host "Remaining: $($remaining.Count) session(s) from $($existingCwds.Count) active project(s)" -ForegroundColor Green
