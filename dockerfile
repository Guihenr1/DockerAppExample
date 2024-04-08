# First stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.sln .
COPY WebApiDocker.Web/*.csproj ./WebApiDocker.Web/
RUN dotnet restore

# Copy everything else and build website
COPY WebApiDocker.Web/. ./WebApiDocker.Web/
WORKDIR /app/WebApiDocker.Web
RUN dotnet publish -c release -o /app/publish

# Final stage
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "WebApiDocker.Web.dll"]