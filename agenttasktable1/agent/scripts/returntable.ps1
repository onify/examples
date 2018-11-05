# Convert tab seperated csv file to json and return it to show as table
Get-Content "$PSScriptRoot\arp.csv" | ConvertFrom-Csv -Delimiter "`t" | ConvertTo-Json -Compress
