<# 
AD_DNS_Host_Search v1.0
Dennis Chow 20130923

This script uses the System.Net.Dns calls for IPv4 resolution from an expanded AD Computername Query into a CSV file.

Original one liner: #dsquery computer -name HOUDC0* -limit 10 | %{ $_.TrimStart('\"CN=') } | %{ $_.Split(',')[0] } | ForEach-Object{ -join ((Get-DnsEntry $_ ),",",($_))} | tee AD_HOST_IP_RESOLVE.csv

Ref: 
http://blogs.technet.com/b/heyscriptingguy/archive/2009/02/26/how-do-i-query-and-retrieve-dns-information.aspx
http://www.powershellmagazine.com/2012/09/18/pstip-resolve-ip-address-or-a-host-name-using-net-framework/
http://blog.forrestshields.com/post/2012/08/01/Resolving-Reverse-DNS-Lookups-in-PowerShell.aspx
http://stackoverflow.com/questions/3008545/powershell-writing-errors-and-ouput-to-a-text-file-and-console
#>

#Get some input for variables
$arg0 = Read-Host "Please enter what hostname(s) you would like to search for. Ex: HOU* or HOUDC0* [ENTER]"
Write-Host ""
Write-Host "You entered:" $arg0
Write-Host ""
$arg1 = Read-Host "How many results do you want to limit ascending? Ex: Use 0 for no limit. [ENTER]"
Write-Host ""
Write-Host "You entered:" $arg1
Write-Host ""
$arg2 = Read-Host "Enter a file name you want to use Ex: output.csv [NOTE: DEFAULT OUTPUT IS CSV] [ENTER]"
Write-Host ""
Write-Host "You entered:" $arg2
Write-Host ""

Write-Host "Starting up..."
#Create Get-DnsEntry Create a function using System.Net.DNS from framework
Function Get-DnsEntry($iphost)
{
 If($ipHost -match "^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$")
  {
    [System.Net.Dns]::GetHostEntry($iphost).HostName
  }
 ElseIf( $ipHost -match "^.*")
   {
	#Returns IPv4 or IPv6 address from Array
    #[System.Net.Dns]::GetHostEntry($iphost).AddressList[0].IPAddressToString
	#Filter on IPv4 addresses only using a Compare
	[System.Net.Dns]::GetHostEntry($iphost).AddressList | Where-Object {$_.AddressFamily -eq 'InterNetwork'} |ForEach-Object {$_.IPAddressToString}
   } 
 ELSE { Throw "Invalid IPv4 Address or Hostname" }
} #end Get-DnsEntry

dsquery computer -name $arg0 -limit $arg1 | %{ $_.TrimStart('\"CN=') } | %{ $_.Split(',')[0] } | `
ForEach-Object `
	{
		-join ((Get-DnsEntry $_ ),",",($_)) | Tee-Object $arg2 -Append
	};

Write-Host ""
Write-Host ""
Get-Content $arg2 | Measure-Object -Line
