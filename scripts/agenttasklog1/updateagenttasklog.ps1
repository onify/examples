param(
	[Parameter(mandatory=$false)]
    [string]$onifytaskid,
	[Parameter(mandatory=$false)]
    [string]$onifyusertoken
)

$onify_tasklog_uri = "https://api.onify.company.com/api/v1/my/agent/task/$onifytaskid/log"
$onify_headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$onify_headers.Add("Authorization", $onifyusertoken)

foreach($i in 1..10) {
    $level = "info"
    if ($i -eq 5) { $level = "warn" }
    if ($i -eq 10) { $level = "error" }
    $body = @{
        message = "Testing $i"
        level = $level
    }
    $json = $body | ConvertTo-Json
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 # Onify requires TLS 1.2 but is not enabled default in PowerSHell
    $r = Invoke-RestMethod -Method PUT -Uri $onify_tasklog_uri -Headers $onify_headers -Body ([System.Text.Encoding]::UTF8.GetBytes($json)) -ContentType application/json
    Start-Sleep 1
}
"OK"
