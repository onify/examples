param(
	[Parameter(mandatory=$false)]
	[string]$OnifyTaskID # The taskid to update logs for (default variable from the agent task)
)

$config = Get-Content -Raw -Path "$PSScriptRoot\..\config.json" -Encoding "UTF8" | ConvertFrom-Json
$onify_tasklog_uri = $config.hub_url + "/api/v1/my/agent/task/$OnifyTaskID/log"
$onify_headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$onify_headers.Add("Authorization", $config.hub_token)

foreach($i in 1..10) {
    $level = "info"
    if ($i -eq 5) { $level = "warn" }
    if ($i -eq 10) { $level = "error" }
    $body = @{
        message = "Testing $i"
        info = $level
    }
    $json = $body | ConvertTo-Json
    $r = Invoke-RestMethod -Method PUT -Uri $onify_tasklog_uri -Headers $onify_headers -Body ([System.Text.Encoding]::UTF8.GetBytes($json)) -ContentType application/json
    Start-Sleep 1
}
"OK"