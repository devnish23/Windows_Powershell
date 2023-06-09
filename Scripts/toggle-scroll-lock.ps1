﻿<#
.SYNOPSIS
	Toggle Scroll Lock
.DESCRIPTION
	This PowerShell script toggles the Scroll Lock key state.
.EXAMPLE
	PS> ./toggle-scroll-lock
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

try {
	$wsh = New-Object -ComObject WScript.Shell
	$wsh.SendKeys('{SCROLLLOCK}')
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}