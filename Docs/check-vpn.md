## The *check-vpn.ps1* Script

This PowerShell script queries and prints the status of any VPN connection.

## Parameters
```powershell
check-vpn.ps1 [<CommonParameters>]

[<CommonParameters>]
    This script supports the common parameters: Verbose, Debug, ErrorAction, ErrorVariable, WarningAction, 
    WarningVariable, OutBuffer, PipelineVariable, and OutVariable.
```

## Example
```powershell
PS> ./check-vpn

```

## Notes
Author: Markus Fleschutz | License: CC0

## Related Links
https://github.com/fleschutz/PowerShell

## Source Code
```powershell
<#
.SYNOPSIS
	Checks the VPN connection
.DESCRIPTION
	This PowerShell script queries and prints the status of any VPN connection.
.EXAMPLE
	PS> ./check-vpn
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

try {
	$NoVPN = $true
	if ($IsLinux) {
		# TODO
	} else {
		$Connections = (Get-VPNConnection)
		foreach($Connection in $Connections) {
			"✅ VPN '$($Connection.Name)' is $($Connection.ConnectionStatus)"
			$NoVPN = $false
		}
	}
	if ($NoVPN) { "⚠️ No VPN connection" }
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
```

*Generated by convert-ps2md.ps1 using the comment-based help of check-vpn.ps1*
