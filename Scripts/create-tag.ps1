#!/bin/powershell
<#
.SYNTAX       ./create-tag.ps1 [<new-tag-name>] [<repo-dir>]
.DESCRIPTION  creates a new tag in the current/given Git repository 
.LINK         https://github.com/fleschutz/PowerShell
.NOTES        Author: Markus Fleschutz / License: CC0
#>

param($NewTagName = "", $RepoDir = "$PWD")

if ($NewTagName -eq "") {
	$NewTagName = read-host "Enter new branch name"
}

try {
	if (-not(test-path "$RepoDir" -pathType container)) { throw "Can't access directory: $RepoDir" }
	set-location "$RepoDir"

	& git --version
	if ($lastExitCode -ne "0") { throw "Can't execute 'git' - make sure Git is installed and available" }

	$Result = (git status)
	if ($lastExitCode -ne "0") { throw "'git status' failed in $RepoDir" }
	if ("$Result" -notmatch "nothing to commit, working tree clean") { throw "Repository is NOT clean: $Result" }

	& git fetch --all --recurse-submodules
	if ($lastExitCode -ne "0") { throw "'git fetch --all --recurse-submodules' failed" }

	& git tag "$NewTagName"
        if ($lastExitCode -ne "0") { throw "Error: 'git tag $NewTagName' failed!" }

        & git push origin "$NewTagName"
	if ($lastExitCode -ne "0") { throw "Error: 'git push origin $NewTagName' failed!" }

	exit 0
} catch {
	write-error "ERROR: line $($_.InvocationInfo.ScriptLineNumber): $($Error[0])"
	exit 1
}
