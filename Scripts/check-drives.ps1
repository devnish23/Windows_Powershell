﻿<#
.SYNOPSIS
	Checks the drive space
.DESCRIPTION
	This PowerShell script checks all drives for free space left.
.PARAMETER MinLevel
	Specifies the minimum warning level (10 GB by default)
.EXAMPLE
	PS> ./check-drives
	✅ Drive C uses 87GB of 249GB
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

param([int]$MinLevel = 10) # 10 GB minimum

function Bytes2String { param([int64]$Bytes)
        if ($Bytes -lt 1000) { return "$Bytes bytes" }
        $Bytes /= 1000
        if ($Bytes -lt 1000) { return "$($Bytes)KB" }
        $Bytes /= 1000
        if ($Bytes -lt 1000) { return "$($Bytes)MB" }
        $Bytes /= 1000
        if ($Bytes -lt 1000) { return "$($Bytes)GB" }
        $Bytes /= 1000
        if ($Bytes -lt 1000) { return "$($Bytes)TB" }
        $Bytes /= 1000
        if ($Bytes -lt 1000) { return "$($Bytes)PB" }
        $Bytes /= 1000
        if ($Bytes -lt 1000) { return "$($Bytes)EB" }
}

try {
	Write-Progress "⏳ Querying drives..."
	$Drives = Get-PSDrive -PSProvider FileSystem 
	foreach($Drive in $Drives) {
		$ID = $Drive.Name
		$Details = (Get-PSDrive $ID)
		[int64]$Free = $Details.Free
 		[int64]$Used = $Details.Used
		[int64]$Total = ($Used + $Free)

		if ($Total -eq 0) {
			Write-Host "✅ Drive $ID is empty"
		} elseif ($Free -eq 0) {
			Write-Host "⚠️ Drive $ID with $(Bytes2String $Total) is full!"
		} elseif ($Free -lt $MinLevel) {
			Write-Host "⚠️ Drive $ID with $(Bytes2String $Total) is nearly full ($(Bytes2String $Free) free)!"
		} elseif ($Used -lt $Free) {
			Write-Host "✅ Drive $ID uses $(Bytes2String $Used) of $(Bytes2String $Total)"
		} else {
			Write-Host "✅ Drive $ID has $(Bytes2String $Free) of $(Bytes2String $Total) free"
		}
	}
	Write-Progress -completed "Querying drives finished."
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}