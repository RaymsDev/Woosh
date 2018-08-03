param(
    [Parameter(Mandatory=$false)]
    [string]$sqlpackage_path,
    [string]$dacpac_path,
    [string]$hostname,
	[string]$port,
    [string]$sa_password,
	[string]$db_name)

# start the service
Write-Verbose 'Starting Deploy'
# deploy or upgrade the database:
Invoke-Expression "$sqlpackage_path\SqlPackage.exe /Action:Publish /SourceFile:$dacpac_path\$db_name.dacpac /TargetConnectionString:'Data Source=$hostname,$port;Initial Catalog=$db_name;Persist Security Info=True;User ID=sa;Password=$sa_password'"

Write-Verbose 'Deploy Success'