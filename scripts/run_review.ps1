# Scheduled post-shower review (Windows). PowerShell twin of run_review.sh.
# Run some time after run_shower.ps1 so the reviewer gets fresh context,
# uncontaminated by the shower session.
$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo

$model = if ($env:REVIEW_MODEL) { $env:REVIEW_MODEL } else { 'opus' }  # opus = latest Opus | sonnet | a full model id
$log   = Join-Path $repo 'logs\cron.log'
$lock  = Join-Path $repo 'logs\.session.lock'

if (-not (Test-Path (Split-Path $log))) { New-Item -ItemType Directory (Split-Path $log) | Out-Null }

# One Claude session at a time - shower and review share this working tree.
if (Test-Path $lock) {
    $age = (Get-Date) - (Get-Item $lock).LastWriteTime
    if ($age.TotalMinutes -lt 90) {
        Add-Content $log "[$(Get-Date -Format s)] review skipped - session already running"
        exit 0
    }
    Remove-Item $lock -Force   # stale lock from a crashed run
}
New-Item -ItemType File $lock | Out-Null

try {
    Add-Content $log "[$(Get-Date -Format s)] review start ($model)"
    & claude -p "/post-shower" `
        --model $model `
        --allowedTools "Skill,Read,Write,Edit,Glob,Grep,WebSearch,WebFetch,Bash(git:*)" 2>&1 |
        Add-Content $log
    Add-Content $log "[$(Get-Date -Format s)] review end (exit $LASTEXITCODE)"
} catch {
    Add-Content $log "[$(Get-Date -Format s)] review failed: $_"
} finally {
    Remove-Item $lock -Force -ErrorAction SilentlyContinue
}
