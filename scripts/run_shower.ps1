# Scheduled shower (Windows). PowerShell twin of run_shower.sh.
# Model choice is part of the experiment: traces record which model showered,
# and the reviewer counts per-model recurrences. Rotate models if curious.
$ErrorActionPreference = 'Stop'
# Bill the Claude Code subscription, not API credits: a machine-wide
# ANTHROPIC_API_KEY would otherwise switch headless runs to pay-as-you-go.
$env:ANTHROPIC_API_KEY = $null

$repo = Split-Path -Parent $PSScriptRoot
Set-Location $repo

$model = if ($env:SHOWER_MODEL) { $env:SHOWER_MODEL } else { 'opus' }  # opus = latest Opus | sonnet | a full model id
$log   = Join-Path $repo 'logs\cron.log'
$lock  = Join-Path $repo 'logs\.session.lock'

if (-not (Test-Path (Split-Path $log))) { New-Item -ItemType Directory (Split-Path $log) | Out-Null }

# One Claude session at a time - shower and review share this working tree.
if (Test-Path $lock) {
    $age = (Get-Date) - (Get-Item $lock).LastWriteTime
    if ($age.TotalMinutes -lt 90) {
        Add-Content $log "[$(Get-Date -Format s)] shower skipped - session already running"
        exit 0
    }
    Remove-Item $lock -Force   # stale lock from a crashed run
}
New-Item -ItemType File $lock | Out-Null

try {
    Add-Content $log "[$(Get-Date -Format s)] shower start ($model)"
    & claude -p "/shower" `
        --model $model `
        --allowedTools "Skill,Read,Write,Edit,Glob,Grep,WebFetch,Bash(git:*)" 2>&1 |
        Add-Content $log
    Add-Content $log "[$(Get-Date -Format s)] shower end (exit $LASTEXITCODE)"
} catch {
    Add-Content $log "[$(Get-Date -Format s)] shower failed: $_"
} finally {
    Remove-Item $lock -Force -ErrorAction SilentlyContinue
}
