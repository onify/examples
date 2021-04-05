param(
	[Parameter(mandatory=$true)]
    [string]$orgnr
)

#Install-Module Selenium

$Driver = Start-SeFirefox -StartURL "https://www.allabolag.se" -Quiet

$searchBox = $Driver.FindElementByXPath('/html/body/div[4]/div[2]/div/div[1]/header/div/div[1]/div[1]/div[2]/form/div/input');
Send-SeKeys -Element $searchBox -Keys $orgnr
Send-SeKeys -Element $searchBox -Keys ([OpenQA.Selenium.Keys]::Enter)

$ceoElement = $Driver.FindElementByXPath('/html/body/div[4]/div[5]/div/div[1]/div[3]/div/div[1]/div[1]/div[3]/div[1]/dl/dd[1]/a');
$phoneElement = $Driver.FindElementByXPath('/html/body/div[4]/div[5]/div/div[1]/div[3]/div/div[1]/div[1]/div[3]/div[2]/dl/dd[1]/a/span');
"CEO: " + $ceoElement.Text
"Phone: " + $phoneElement.Text

Stop-SeDriver -Target $Driver
