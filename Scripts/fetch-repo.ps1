﻿<#
.SYNOPSIS
	Fetches updates for a Git repo
.DESCRIPTION
	This PowerShell script fetches updates for a local Git repository (including submodules).
.PARAMETER RepoDir
	Specifies the path to the Git repository.
.EXAMPLE
	PS> ./fetch-repo
	⏳ (1/3) Searching for Git executable...  git version 2.38.1.windows.1
	⏳ (2/3) Checking Git repository 📂PowerShell...
	⏳ (3/3) Fetching updates (including submodules)...
	✔️ fetched updates for 📂PowerShell repository in 2 sec.
.LINK
	https://github.com/fleschutz/PowerShell
.NOTES
	Author: Markus Fleschutz | License: CC0
#>

param([string]$RepoDir = "$PWD")

try {
	$StopWatch = [system.diagnostics.stopwatch]::startNew()

	Write-Host "⏳ (1/3) Searching for Git executable...  " -noNewline
	& git --version
	if ($lastExitCode -ne "0") { throw "Can't execute 'git' - make sure Git is installed and available" }

	$RepoDirName = (Get-Item "$RepoDir").Name
	Write-Host "⏳ (2/3) Checking Git repository...       📂$RepoDirName"
	if (!(Test-Path "$RepoDir" -pathType container)) { throw "Can't access folder: $RepoDir" }

	Write-Host "⏳ (3/3) Fetching updates... "
	& git -C "$RepoDir" fetch --all --recurse-submodules --prune --prune-tags --force 
	if ($lastExitCode -ne "0") { throw "'git fetch' failed with exit code $lastExitCode" }
	
	[int]$Elapsed = $StopWatch.Elapsed.TotalSeconds
	"✔️ fetched updates for 📂$RepoDirName repository in $Elapsed sec."
	exit 0 # success
} catch {
	"⚠️ Error in line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}