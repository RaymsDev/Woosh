# escape=`

# db image
FROM microsoft/mssql-server-windows-express:latest
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV ACCEPT_EULA="Y"
ENV sa_password="P@ssw0rd"
ENV script_name="hydrate.sql"
ENV db_name="Mountain"

#WORKDIR C:\init
#COPY Initialize-Database.ps1 .
#COPY --from=builder C:\Mountain.* .
#
#RUN ./Initialize-Database.ps1 -sa_password $env:sa_password -db_name $env:db_name -script_name $env:script_name -Verbose
#
#WORKDIR C:\
