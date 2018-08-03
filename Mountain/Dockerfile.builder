# escape=`
FROM microsoft/dotnet-framework:4.7.2-sdk

LABEL maintainer="Rayms <rayms.dev@gmail.com>"

#SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]
RUN nuget install Microsoft.Data.Tools.Msbuild -Version 10.0.61804.210 -Force
RUN nuget install SqlPackage.CommandLine -Version 14.0.3953.4 -Force

ENV MSBUILD_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin" `
	DATATOOLS_PATH="Microsoft.Data.Tools.Msbuild.10.0.61804.210\lib\net46" `
	SQLPACKAGE_PATH="C:\SqlPackage.CommandLine.14.0.3953.4\tools"

RUN $env:PATH = $env:SQLPACKAGE_PATH + ';' + $env:DATATOOLS_PATH + ';' + $env:MSBUILD_PATH + ';' + $env:PATH; `
	[Environment]::SetEnvironmentVariable('PATH', $env:PATH, [EnvironmentVariableTarget]::Machine)

#RUN setx SQLDBExtensionsRefPath $env:DATATOOLS_PATH /M
#RUN setx SSDTPath $env:DATATOOLS_PATH /M

WORKDIR C:\src
COPY . .

ENV db_name="Mountain"

RUN msbuild $db_name.sqlproj `
      /p:SQLDBExtensionsRefPath="C:\Microsoft.Data.Tools.Msbuild.10.0.61804.210\lib\net46" `
      /p:SqlServerRedistPath="C:\Microsoft.Data.Tools.Msbuild.10.0.61804.210\lib\net46"

ENV sa_password="P@ssw0rd"
ENV script_name="hydrate.sql"

CMD ./Unpack-Database.ps1 -sqlpackage $env:SQLPACKAGE_PATH -hostname $env:hostname -sa_password $env:sa_password -db_name $env:db_name -script_name $env:script_name -Verbose

