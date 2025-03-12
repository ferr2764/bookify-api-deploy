FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj và restore dependencies
COPY *.sln .
COPY ["bookify-api/*.csproj", "bookify-api/"]
RUN dotnet restore "bookify-api/bookify-api.csproj"

# Copy toàn bộ source code và build
COPY . .
WORKDIR "/src/bookify-api"
RUN dotnet publish -c Release -o /app/publish

# Tạo image final
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "bookify-api.dll"]