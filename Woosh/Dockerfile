FROM microsoft/aspnetcore:2.0-nanoserver-1709 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0-nanoserver-1709 AS build
WORKDIR /src
COPY Woosh/Woosh.csproj Woosh/
RUN dotnet restore Woosh/Woosh.csproj
COPY . .
WORKDIR /src/Woosh
RUN dotnet build Woosh.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish Woosh.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "Woosh.dll"]
