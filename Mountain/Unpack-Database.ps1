param(
    [Parameter(Mandatory=$false)]
    [string]$sqlpackage,
    [string]$hostname,
    [string]$sa_password,
	[string]$db_name,
	[string]$script_name)

# start the service
Write-Verbose 'Starting Unpack'
# deploy or upgrade the database:
C:\SqlPackage.CommandLine.14.0.3953.4\tools\SqlPackage.exe /Action:Publish /SourceFile:"C:\src\bin\Debug\Mountain.dacpac" /TargetConnectionString:"Data Source=db,1433;Initial Catalog=Mountain;Persist Security Info=True;User ID=sa;Password=P@ssw0rd"
#$SqlCmdVars = "DatabaseName=$db_name", "DefaultFilePrefix=$db_name", "DefaultDataPath=c:\database\", "DefaultLogPath=c:\database\"  
#Invoke-Sqlcmd -InputFile $script_name -Variable $SqlCmdVars -Verbose

Write-Output "Coucou"