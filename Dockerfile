#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0-bullseye-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0-bullseye-slim-amd64 AS build
WORKDIR /src
COPY ["hellocontainers.csproj", "."]
RUN dotnet restore "./hellocontainers.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "hellocontainers.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "hellocontainers.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "hellocontainers.dll"]