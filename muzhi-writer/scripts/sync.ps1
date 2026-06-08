param(
    [switch]$Force
)

$source = "E:\AI\AI Coding\Interacting with Codex\My Skills\muzhi-writer"
$target = "$env:USERPROFILE\.codex\skills\muzhi-writer"

if (-not (Test-Path $target)) {
    Write-Host "muzhi-writer not installed. Copying..."
    Copy-Item -Recurse $source $target
    Write-Host "Done. Restart Codex."
    exit
}

$sourceTime = (Get-ChildItem -Recurse $source | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime
$targetTime = (Get-ChildItem -Recurse $target | Sort-Object LastWriteTime -Descending | Select-Object -First 1).LastWriteTime

if ($sourceTime -gt $targetTime -or $Force) {
    Write-Host "Source is newer. Syncing..."
    Remove-Item -Recurse -Force $target
    Copy-Item -Recurse $source $target
    # Strip BOM from all files after copy
    $utf8NoBOM = New-Object System.Text.UTF8Encoding $false
    Get-ChildItem -Recurse -File $target | ForEach-Object {
        $c = [System.IO.File]::ReadAllText($_.FullName, [System.Text.UTF8Encoding]::new($true))
        [System.IO.File]::WriteAllText($_.FullName, $c, $utf8NoBOM)
    }
    Write-Host "Done. muzhi-writer updated (BOM stripped)."
} else {
    Write-Host "Already up to date."
}