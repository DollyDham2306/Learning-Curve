#local path Information
do
{
	write-host "Please enter the local git directory path where you want to continue this process."
	$localgitPath = Read-Host
}
until ($localgitPath -ne "")

cd $localgitPath

do
{
	write-host "Please enter the prefix for temporary branch used for cherry picking the commits."
	$Prefix = Read-Host
}
until ($Prefix -ne "")

$baseBranchName
do
{
	write-host "Please enter the repository branch name from which you want to create temporary branch."
	$baseBranchName = Read-Host
}
until ($baseBranchName -ne "")


#Getting the CommitId and its confirmation
$commits = @()
do
{
	$input = (Read-Host -Prompt "Please enter TFS-GIT commit ID and press ENTER if complete")
	if ($input -ne "") 
	{
		$commits += $input
	}
}
until ($input -eq "")

# Display list of commits and get confirmation from User
foreach ($i in $commits)
{
	Write-Host $i
}
$decision = Read-Host -Prompt "Type 'y' if committed ids are correct?"

if ($decision -eq "y")
{
	git checkout $baseBranchName
	git pull origin $baseBranchName
	git checkout -b $Prefix-Pre-Release
 	git push --set-upstream origin $Prefix-Pre-Release
	
	Foreach ($commitid in $commits)
	{
		Git cherry-pick -x $commitid
		#git cherry-pick --continue
	}

	#Commit to local
	#git add .
	#git commit -m "Cherry picked committed"
	
	#Push the branch
	git push --set-upstream origin $Prefix-Pre-Release
}
else
{
	write-host "Nothing is changed on server. Thank you"
}

#git request-pull $Prefix-Pre-Release

#$ver = Read-Host -Prompt "Do you want to delete the temporary branch created here i.e. $Prefix-Pre-Release (y/n)."
#if ($ver -eq "y")
#{
#git branch -d $Prefix-Pre-release
#git branch -D $Prefix-Pre-release
#}
