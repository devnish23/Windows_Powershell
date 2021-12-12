﻿<#
.SYNOPSIS
	Switches to a random wallpaper
.DESCRIPTION
	This script downloads a random photo and sets it as desktop wallpaper.
.PARAMETER Category
	Specifies the photo category (beach, city, ...)
.EXAMPLE
	PS> ./next-random-wallpaper 
.NOTES
	Author: Markus Fleschutz · License: CC0
.LINK
	https://github.com/fleschutz/PowerShell
#>

param([string]$Category = "")

function GetTempDir {
        if ("$env:TEMP" -ne "") { return "$env:TEMP" }
        if ("$env:TMP" -ne "")  { return "$env:TMP" }
        if ($IsLinux) { return "/tmp" }
        return "C:\Temp"
}

try {
	& "$PSScriptRoot/give-reply.ps1" "Loading from Unsplash..."

	$Path = "$(GetTempDir)/next_wallpaper.jpg"
	& wget -O $Path "https://source.unsplash.com/3840x2160?$Category"
	if ($lastExitCode -ne "0") { throw "Download failed" }

	& "$PSScriptRoot/set-wallpaper.ps1" -ImageFile "$Path"
	exit 0 # success
} catch {
	"⚠️ Error: $($Error[0]) ($($MyInvocation.MyCommand.Name):$($_.InvocationInfo.ScriptLineNumber))"
	exit 1
}