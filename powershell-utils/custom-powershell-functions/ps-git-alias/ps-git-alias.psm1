# personal alias for git
function g() {
	git
}

function gs() {
	git status
}

function gcf() {
	git config
}

function gaa() { 
	git add . 
}

function glg() {
	git log
}

function gpsh() { 
	git push
}

function gpl() {
	git pull
}

function gme() { 
	git merge
}

function grl() {
	git reflog
}

function gd() { 
	git diff
}

function grs() {
	git reset
}

function gr() {
	git remote
}

function gcp() { 
	git cherry-pick
}

function grb() { 
	git rebase
}

function gco() {
	$branchName = Read-Host "Branch name ";

	if ([string]::IsNullOrEmpty($branchName)) {
		Write-Host "`nBranch name not valid!" -ForegroundColor "Red"
	}
	else {
		git checkout $BranchName
	}
}

function gb() {
	$branchName = Read-Host "Branch name ";

	if ([string]::IsNullOrEmpty($branchName)) {
		Write-Host "`nBranch name not valid!" -ForegroundColor "Red"
	}
	else {
		git branch $BranchName
	}
}

function gcom() {
	$commitMessage = Read-Host "Commit message ";

	if ([string]::IsNullOrEmpty($commitMessage)) {
		Write-Host "`nCommit message not valid!" -ForegroundColor "Red"
	}
	else {
		git commit -m $commitMessage
	}
}

function gpush() { 
	$optionSelected = Read-Host "Would like to run the following commands? `n`n>> git add . `n>> git commit `n>> git push `n`nY) Yes `nN) No ";
	if ([string]::IsNullOrEmpty($optionSelected)) {
		Write-Host "`nOption not valid!" -ForegroundColor "Red"
		Exit
	}
	else {
		if ($optionSelected -eq "Y") {
			$commitMessage = Read-Host "Add commit message ";

			if ([string]::IsNullOrEmpty($commitMessage)) {
				Write-Host "`nCommit message not valid!" -ForegroundColor "Red"
				Exit
			}
			else {
				git add .

				git commit -m $commitMessage

				git push 
			}
		}
		elseif ($projectOptionSelected -eq "N") {
			Write-Host "`nClosing application!" -ForegroundColor "Red"
			Exit
		}
		else {
			Write-Host "`nOption not valid!" -ForegroundColor "Red"
			Exit
		}
	}
}

function gcl(
	[Parameter()]
	[string]$url) {
	git clone $url
}

Export-ModuleMember -Function g
Export-ModuleMember -Function gs
Export-ModuleMember -Function gcf
Export-ModuleMember -Function gaa
Export-ModuleMember -Function glg
Export-ModuleMember -Function gpsh
Export-ModuleMember -Function gpl
Export-ModuleMember -Function gme
Export-ModuleMember -Function grl
Export-ModuleMember -Function gd
Export-ModuleMember -Function grs
Export-ModuleMember -Function gr
Export-ModuleMember -Function gcp
Export-ModuleMember -Function grb
Export-ModuleMember -Function gco
Export-ModuleMember -Function gb
Export-ModuleMember -Function gcom
Export-ModuleMember -Function gpush
Export-ModuleMember -Function gcl
