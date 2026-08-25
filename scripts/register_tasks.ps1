# Registers the shower schedule with Windows Task Scheduler.
#   Showers hourly on the hour, 9am-3pm local.
#   Reviews 30 minutes later, 9:30am-3:30pm local.
# Re-run to update; pass -Unregister to remove both tasks.
param(
    [switch]$Unregister,
    [string]$ShowerStart = '09:00',
    [string]$ReviewStart = '09:30',
    [int]$Hours = 6            # repetitions after the first: 6 => 7 runs, 9am..3pm
)
$ErrorActionPreference = 'Stop'
$scripts = $PSScriptRoot

$tasks = @(
    @{ Name = 'ShowerThoughts-Shower'; Script = 'run_shower.ps1'; Start = $ShowerStart },
    @{ Name = 'ShowerThoughts-Review'; Script = 'run_review.ps1'; Start = $ReviewStart }
)

foreach ($t in $tasks) {
    if (Get-ScheduledTask -TaskName $t.Name -ErrorAction SilentlyContinue) {
        Unregister-ScheduledTask -TaskName $t.Name -Confirm:$false
    }
    if ($Unregister) { Write-Host "removed $($t.Name)"; continue }

    $action = New-ScheduledTaskAction -Execute 'powershell.exe' `
        -Argument "-NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$(Join-Path $scripts $t.Script)`""

    $trigger = New-ScheduledTaskTrigger -Daily -At $t.Start
    $trigger.Repetition = (New-ScheduledTaskTrigger -Once -At $t.Start `
        -RepetitionInterval (New-TimeSpan -Hours 1) `
        -RepetitionDuration (New-TimeSpan -Hours $Hours)).Repetition

    $settings = New-ScheduledTaskSettingsSet `
        -StartWhenAvailable `
        -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries `
        -ExecutionTimeLimit (New-TimeSpan -Hours 1) `
        -MultipleInstances IgnoreNew

    Register-ScheduledTask -TaskName $t.Name -Action $action -Trigger $trigger `
        -Settings $settings -Description "Artificial Shower Thoughts: $($t.Script)" | Out-Null
    Write-Host "registered $($t.Name) - daily $($t.Start), every hour x$($Hours + 1)"
}
