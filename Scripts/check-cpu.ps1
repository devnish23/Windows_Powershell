﻿<#
.SYNOPSIS
	Queries and prints CPU details
.DESCRIPTION
	This PowerShell script queries CPU details (name, type, speed, temperature, etc.) and prints it.
.EXAMPLE
	PS> ./check-cpu
	✅ AMD Ryzen 5 5500U with Radeon Graphics (CPU0, 2100MHz, 31.3°C)
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

function GetCPUTemperatureInCelsius {
	$Temp = 99999.9 # unsupported
	if ($IsLinux) {
		if (Test-Path "/sys/class/thermal/thermal_zone0/temp" -pathType leaf) {
			[int]$IntTemp = Get-Content "/sys/class/thermal/thermal_zone0/temp"
			$Temp = [math]::round($IntTemp / 1000.0, 1)
		}
	} else {
		$Objects = Get-WmiObject -Query "SELECT * FROM Win32_PerfFormattedData_Counters_ThermalZoneInformation" -Namespace "root/CIMV2"
		foreach ($Obj in $Objects) {
			$HiPrec = $Obj.HighPrecisionTemperature
			$Temp = [math]::round($HiPrec / 100.0, 1)
		}
	}
	return $Temp;
}

try {
	Write-Progress "⏳ Querying CPU details..."
	$Status = "✅"
	$Celsius = GetCPUTemperatureInCelsius
	if ($Celsius -eq 99999.9) {
		$Temp = "no temp"
	} elseif ($Celsius -gt 50) {
		$Temp = "$($Celsius)°C"
		$Status = "⚠"
	} elseif ($Celsius -lt 0) {
		$Temp = "$($Celsius)°C"
		$Status = "⚠"
	} else {
		$Temp = "$($Celsius)°C"
	} 

	if ($IsLinux) {
		$Name = $PSVersionTable.OS
		if ($Name -like "*-generic *") {
			if ([System.Environment]::Is64BitOperatingSystem) {
				$Arch = "x64"
			} else {
				$Arch = "x86"
			}
		} elseif ($Name -like "*-raspi *") {
			if ([System.Environment]::Is64BitOperatingSystem) {
				$Arch = "ARM64"
			} else {
				$Arch = "ARM32"
			}
		} else {
			$Arch = ""
		}
		$CPUName = "$Arch CPU"
		$DeviceID = ""
		$Speed = ""
		$Socket = ""
	} else {
		$Details = Get-WmiObject -Class Win32_Processor
		$CPUName = $Details.Name.trim()
		$DeviceID = "$($Details.DeviceID), "
		$Speed = "$($Details.MaxClockSpeed)MHz, "
		$Socket = "$($Details.SocketDesignation) socket, "
	}
	$Cores = [System.Environment]::ProcessorCount
	Write-Host "$Status $CPUName ($Cores cores, $($DeviceID)$($Speed)$($Socket)$Temp)"
	Write-Progress -completed "Querying CPU details finished."
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
