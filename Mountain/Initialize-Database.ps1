# Adapted from Microsoft's SQL Server Express sample:
# https://github.com/Microsoft/sql-server-samples/blob/master/samples/manage/windows-containers/mssql-server-2016-express-windows/start.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$sa_password,
	[string]$db_name,
	[string]$script_name)

# start the service
Write-Verbose 'Starting SQL Server'
start-service MSSQL`$SQLEXPRESS

if ($sa_password -ne "_") {
	Write-Verbose 'Changing SA login credentials'
    $sqlcmd = "ALTER LOGIN sa with password='$sa_password'; ALTER LOGIN sa ENABLE;"
    Invoke-Sqlcmd -Query $sqlcmd -ServerInstance ".\SQLEXPRESS" 
}

# attach data files if they exist: 
$mdfPath = "c:\database\$db_name.mdf"
if ((Test-Path $mdfPath) -eq $true) {
    $sqlcmd = "CREATE DATABASE $db_name ON (FILENAME = N'$mdfPath')"
    $ldfPath = "c:\database\$db_name.ldf"
    if ((Test-Path $mdfPath) -eq $true) {
        $sqlcmd =  "$sqlcmd, (FILENAME = N'$ldfPath')"
    }
    $sqlcmd = "$sqlcmd FOR ATTACH;"
    Write-Verbose "Invoke-Sqlcmd -Query $($sqlcmd) -ServerInstance '.\SQLEXPRESS'"
    Invoke-Sqlcmd -Query $sqlcmd -ServerInstance ".\SQLEXPRESS"
}
# deploy or upgrade the database:
$SqlPackagePath = 'SqlPackage.exe'
& $SqlPackagePath  `
    /sf:$db_name.dacpac `
    /a:Script /op:$script_name /p:CommentOutSetVarDeclarations=true `
    /tsn:.\SQLEXPRESS /tdn:$db_name /tu:sa /tp:$sa_password 

$SqlCmdVars = "DatabaseName=$db_name", "DefaultFilePrefix=$db_name", "DefaultDataPath=c:\database\", "DefaultLogPath=c:\database\"  
Invoke-Sqlcmd -InputFile $script_name -Variable $SqlCmdVars -Verbose

# relay SQL event logs to Docker
$lastCheck = (Get-Date).AddSeconds(-2) 
while ($true) { 
    Get-EventLog -LogName Application -Source "MSSQL*" -After $lastCheck | Select-Object TimeGenerated, EntryType, Message	 
    $lastCheck = Get-Date 
    Start-Sleep -Seconds 2 
}