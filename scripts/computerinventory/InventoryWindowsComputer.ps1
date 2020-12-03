# ----- ONIFY API SETUP ------
$ONIFY_api_token = "******"
$ONIFY_api_url = "https://****/api/v2"
$ONIFY_api_items_url = $ONIFY_api_url + "/admin/items"
$ONIFY_headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$ONIFY_headers.Add("Authorization", $ONIFY_api_token)

# ----- COMPUTER INVENTORY ------
$computername =  Get-WmiObject Win32_OperatingSystem | select -ExpandProperty CSName
$os_name = Get-WmiObject Win32_OperatingSystem | Select-Object -ExpandProperty Caption 
$os_architecture = Get-WmiObject Win32_OperatingSystem | select -ExpandProperty OSArchitecture
$manufacturer = Get-WmiObject win32_computersystem | select -ExpandProperty Manufacturer
$model = Get-WmiObject win32_computersystem | select -ExpandProperty Model
$cpu_manufacturer = Get-WmiObject Win32_Processor | select -ExpandProperty Name
$disk_size = Get-WmiObject win32_diskDrive | Measure-Object -Property Size -Sum | % {[math]::round(($_.sum /1GB),0)}
$memory = Get-WMIObject -class Win32_PhysicalMemory | Measure-Object -Property capacity -Sum | % {[Math]::Round(($_.sum / 1GB),2)}
$username = Get-WMIObject -class Win32_ComputerSystem | select -ExpandProperty PrimaryOwnerName 

# ----- SET ITEM OBJECT ------
$attributes = @{
    os_name = $os_name
    os_architecture = $os_architecture
    manufacturer = $manufacturer
    model = $model
    cpu_manufacturer = $cpu_manufacturer 
    disk_size = "$disk_size Gb"
    memory = "$memory Gb"
}

$item = @{
	key = $computername
	name = $computername
	description = ""
	icon = "/icons/computer.svg"
	tag = @("asset", "windows")
	attribute = $attributes
	owner = $username
    status = "Active"
    type = "computer"
    modifieddate = (get-date).ToString()
} 

# ----- SEND ITEM OBJECT ------
$json = $item | ConvertTo-Json -Depth 5
Invoke-RestMethod -Method POST -Uri $ONIFY_api_items_url -Headers $ONIFY_headers -Body ([System.Text.Encoding]::UTF8.GetBytes($json)) -ContentType application/json
